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

    _textFieldFocusNode.addListener(_updatePackageListRender);
    _textFieldController.addListener(_updatePackageListRender);

    _updateRecentSearchesFromStorage();
  }

  final _textFieldController = TextEditingController();
  final _textFieldFocusNode = FocusNode();

  final _client = PubClient();
  final _box = GetStorage();

  final _foundPackages = <String>[];
  final _recentSearches = <String>[];

  bool get _isInSearchingMode => _textFieldController.text.length >= 2;

  bool _showEmptyRecentSearches = true;
  bool _showRecentSearches = false;
  bool _showNoPackagesFoundMessage = false;
  bool _showSearchResult = false;
  bool _errorFetchingPackages = false;
  bool _loadingPackages = false;

  void _updatePackageListRender() {
    setState(() {
      _showRecentSearches = _recentSearches.isNotEmpty && !_isInSearchingMode;

      _showEmptyRecentSearches = _recentSearches.isEmpty && !_isInSearchingMode;
    });
  }

  void _updateRecentSearchesFromStorage() {
    final storedRecentSearches =
        (_box.read<List<dynamic>>(_storageBoxName) ?? []).cast<String>();

    if (storedRecentSearches.isNotEmpty) {
      _recentSearches.clear();
      _recentSearches.addAll(storedRecentSearches);

      _updatePackageListRender();
    }
  }

  void _searchPackages(String term) async {
    if (_isInSearchingMode) {
      setState(() {
        _loadingPackages = true;
        _showNoPackagesFoundMessage = false;
        _showEmptyRecentSearches = false;
        _showRecentSearches = false;
        _errorFetchingPackages = false;
      });

      try {
        final searchResults = await _client.search(term);

        setState(() {
          _foundPackages.clear();
          _foundPackages.addAll(
            searchResults.packages.take(5).map((x) => x.package),
          );

          _showNoPackagesFoundMessage = _foundPackages.isEmpty;
          _showSearchResult = _foundPackages.isNotEmpty;
        });
      } catch (e) {
        setState(() {
          _errorFetchingPackages = true;
          _showSearchResult = false;
          _showNoPackagesFoundMessage = false;
        });
      } finally {
        setState(() {
          _loadingPackages = false;
        });
      }

      return;
    }

    setState(() {
      _loadingPackages = false;
      _showSearchResult = false;
      _errorFetchingPackages = false;
      _showNoPackagesFoundMessage = false;
      _showEmptyRecentSearches = _recentSearches.isEmpty;
      _showRecentSearches = _recentSearches.isNotEmpty;
      _foundPackages.clear();
    });
  }

  Future _goToPackageDetailsPage(String packageName) async {
    _textFieldFocusNode.unfocus();
    _textFieldController.clear();

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PackageDetailsPage(
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 237),
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(
                        height: 100,
                      ),
                      Center(
                        child: SearchTextField(
                          controller: _textFieldController,
                          focusNode: _textFieldFocusNode,
                          onChanged: _searchPackages,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      if (_loadingPackages && !_showSearchResult)
                        Container(
                          padding: const EdgeInsets.only(top: 30),
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        ),
                      if (_showEmptyRecentSearches)
                        const RoundedContainer(
                          child: Text(
                            'No Recent Searches',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (_errorFetchingPackages)
                        const RoundedContainer(
                          child: Text(
                            'Error searching packages',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (_showRecentSearches)
                        PackageList(
                          title: 'Recent Searches',
                          packages: _recentSearches,
                          onSelectPackage: _goToPackageDetailsPage,
                        ),
                      if (_showNoPackagesFoundMessage)
                        const RoundedContainer(
                          child: Text('No packages found'),
                        ),
                      if (_showSearchResult && _isInSearchingMode)
                        PackageList(
                          packages: _foundPackages,
                          onSelectPackage: (String packageName) async {
                            _addPackageToRecentSearches(packageName);

                            await _goToPackageDetailsPage(packageName);
                          },
                        ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  fillOverscroll: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: TextButton(
                          onPressed: () async {
                            _textFieldController.clear();
                            _textFieldFocusNode.unfocus();

                            setState(() {
                              _foundPackages.clear();
                              _recentSearches.clear();
                            });

                            await _box.erase();

                            _updatePackageListRender();
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

  Future<void> _addPackageToRecentSearches(String packageName) async {
    if (!_recentSearches.contains(packageName)) {
      setState(() {
        _recentSearches.insert(0, packageName);
      });

      await _box.write(_storageBoxName, _recentSearches);
    }
  }
}

const String _storageBoxName = 'packages';
