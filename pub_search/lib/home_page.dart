import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_search/search_text_field.dart';

import 'package_details_page.dart';
import 'package_list.dart';
import 'rounded_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    _textFieldFocusNode.addListener(_updateVisualization);
    _textFieldController.addListener(_updateVisualization);

    _updateRecentSearchesFromStorage();
  }

  final _textFieldController = TextEditingController();
  final _textFieldFocusNode = FocusNode();

  final _client = PubClient();
  final box = GetStorage();

  final _foundPackages = <String>[];
  final _recentSearches = <String>[];

  bool get _isSearching => _textFieldController.text.length >= 2;

  bool _showNoRecentSearchesMessage = true;
  bool _showRecentSearches = false;
  bool _showNoPackagesFound = false;
  bool _showFoundPackages = false;

  void _updateVisualization() {
    setState(() {
      _showRecentSearches = _recentSearches.isNotEmpty && !_isSearching;

      _showNoRecentSearchesMessage = _recentSearches.isEmpty && !_isSearching;
    });
  }

  void _updateRecentSearchesFromStorage() {
    final storedRecentSearches =
        (box.read<List<dynamic>>('packages') ?? []).cast<String>();

    if (storedRecentSearches.isNotEmpty) {
      _recentSearches.clear();
      _recentSearches.addAll(storedRecentSearches);

      _updateVisualization();
    }
  }

  void _searchPackages(String term) async {
    if (_isSearching) {
      setState(() {
        _showNoPackagesFound = false;
        _showNoRecentSearchesMessage = false;
        _showRecentSearches = false;
      });

      final searchResults = await _client.search(term);

      setState(() {
        _foundPackages.clear();
        _foundPackages.addAll(
          searchResults.packages.take(5).map((x) => x.package),
        );

        _showNoPackagesFound = _foundPackages.isEmpty;
        _showFoundPackages = _foundPackages.isNotEmpty;
      });

      return;
    }

    setState(() {
      _showFoundPackages = false;
      _showNoPackagesFound = false;
      _showNoRecentSearchesMessage = _recentSearches.isEmpty;
      _showRecentSearches = _recentSearches.isNotEmpty;
      _foundPackages.clear();
    });
  }

  Future<void> _goToPackageDetailsPage(String packageName) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PackageDetailsPage(
          packageName: packageName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: SizedBox(
            width: 237,
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                SearchTextField(
                  controller: _textFieldController,
                  focusNode: _textFieldFocusNode,
                  onChanged: _searchPackages,
                ),
                const SizedBox(
                  height: 6,
                ),
                if (_showNoRecentSearchesMessage)
                  const RoundedContainer(
                    child: Text(
                      'No Recent Searches',
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (_showRecentSearches)
                  PackageList(
                    title: 'Recent Searches',
                    packages: _recentSearches,
                    onSelectPackage: _goToPackageDetailsPage,
                  ),
                if (_showNoPackagesFound)
                  const RoundedContainer(
                    child: Text('No packages found'),
                  ),
                if (_showFoundPackages)
                  PackageList(
                    packages: _foundPackages,
                    onSelectPackage: (String packageName) async {
                      _savePackageOnRecentSearches(packageName);

                      await _goToPackageDetailsPage(packageName);
                    },
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    _textFieldController.clear();
                    _textFieldFocusNode.unfocus();

                    setState(() {
                      _foundPackages.clear();
                      _recentSearches.clear();
                    });

                    await box.erase();

                    _updateVisualization();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.clear),
                      Text(
                        'Clear all data',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _savePackageOnRecentSearches(String packageName) async {
    if (!_recentSearches.contains(packageName)) {
      setState(() {
        _recentSearches.insert(0, packageName);
      });

      await box.write('packages', _recentSearches);
    }
  }
}
