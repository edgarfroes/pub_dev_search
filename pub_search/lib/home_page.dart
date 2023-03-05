import 'package:flutter/material.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_search/search_text_field.dart';

import 'package_details_page.dart';
import 'package_list.dart';
import 'rounder_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textFieldController = TextEditingController();
  final _textFieldFocusNode = FocusNode();

  final client = PubClient();

  final _foundPackages = <String>[];
  final _recentSearches = <String>[];

  @override
  void initState() {
    super.initState();

    _textFieldFocusNode.addListener(_updateVisualization);
    _textFieldController.addListener(_updateVisualization);
  }

  void _updateVisualization() {
    setState(() {
      _showNoRecentSearches =
          _recentSearches.isEmpty && _foundPackages.isEmpty && !_isSearching;

      _showRecentSearches = _recentSearches.isNotEmpty && !_isSearching;

      _showNoRecentSearches = _recentSearches.isEmpty && !_isSearching;
    });
  }

  bool get _isSearching => _textFieldController.text.length >= 2;

  bool _showNoRecentSearches = true;
  bool _showRecentSearches = false;
  bool _showNoPackagesFound = false;
  bool _showFoundPackages = false;

  void _searchPackages(String term) async {
    if (_isSearching) {
      setState(() {
        _showNoPackagesFound = false;
        _showNoRecentSearches = false;
        _showRecentSearches = false;
      });

      final searchResults = await client.search(term);

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
      _showNoRecentSearches = _recentSearches.isEmpty;
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
                if (_showNoRecentSearches)
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
                      if (!_recentSearches.contains(packageName)) {
                        setState(() {
                          _recentSearches.add(packageName);
                        });
                      }

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
}
