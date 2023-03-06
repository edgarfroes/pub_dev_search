import 'package:flutter/material.dart';
import 'package:pub_api_client/pub_api_client.dart';

import 'rounded_container.dart';

class PackageDetailsPage extends StatefulWidget {
  const PackageDetailsPage({super.key, required this.packageName});

  final String packageName;

  @override
  State<PackageDetailsPage> createState() => _PackageDetailsPageState();
}

class _PackageDetailsPageState extends State<PackageDetailsPage> {
  @override
  void initState() {
    super.initState();

    _fetchEverything();
  }

  Future<void> _fetchEverything() async {
    setState(() {
      _firstLoading = true;
    });

    // Call all APIs asynchronously.
    await Future.wait([
      _fetchPackageStatus(),
      _fetchPackageDescription(),
    ]);

    setState(() {
      _firstLoading = false;
    });
  }

  Future<void> _fetchPackageStatus() async {
    try {
      setState(() {
        _errorLoadingPackageStatus = false;
        _loadingPackageStatus = true;
      });

      final packageStatus = await _client.packageScore(widget.packageName);

      _likes = packageStatus.likeCount;
      _pubPoints = packageStatus.grantedPoints;
      _popularity = packageStatus.popularityScore;
    } catch (e) {
      setState(() {
        _errorLoadingPackageStatus = true;
      });
    } finally {
      setState(() {
        _loadingPackageStatus = false;
      });
    }
  }

  Future<void> _fetchPackageDescription() async {
    try {
      setState(() {
        _errorLoadingPackageDescription = false;
        _loadingPackageDescription = true;
      });

      final packageInfo = await _client.packageInfo(widget.packageName);

      _description = packageInfo.description;
    } catch (e) {
      setState(() {
        _errorLoadingPackageDescription = true;
      });
    } finally {
      setState(() {
        _loadingPackageDescription = false;
      });
    }
  }

  final _client = PubClient();

  bool _firstLoading = true;
  bool _loadingPackageStatus = true;
  bool _loadingPackageDescription = true;
  bool _errorLoadingPackageDescription = false;
  bool _errorLoadingPackageStatus = false;
  bool get _errorFetchingEverything =>
      _errorLoadingPackageDescription && _errorLoadingPackageStatus;

  int? _likes;
  int? _pubPoints;
  double? _popularity;
  String? _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 237,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 100,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_circle_left_outlined),
                  iconSize: 50,
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(
                  height: 6,
                ),
                RoundedContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 13,
                        ),
                        child: Text(widget.packageName),
                      ),
                      const Divider(),
                      if (_firstLoading == true)
                        Container(
                          height: _sectionHeight * 2,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        )
                      else
                        _errorFetchingEverything
                            ? _ErrorLoadingAllInfo(
                                onRefresh: _fetchEverything,
                              )
                            : Column(
                                children: [
                                  if (_loadingPackageStatus)
                                    Container(
                                      height: _sectionHeight,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: const LinearProgressIndicator(),
                                    )
                                  else if (_errorLoadingPackageStatus)
                                    _ErrorLoadingPartialInfo(
                                      errorMessage: 'Error loading status.',
                                      onRefresh: _fetchPackageStatus,
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 13,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (_likes != null)
                                            _PackageStatistic(
                                              value: '$_likes',
                                              description: 'LIKES',
                                            ),
                                          if (_pubPoints != null)
                                            _PackageStatistic(
                                              value: '$_pubPoints',
                                              description: 'PUB POINTS',
                                            ),
                                          if (_popularity != null)
                                            _PackageStatistic(
                                              value:
                                                  '${(_popularity! * 100).truncate()}%',
                                              description: 'POPULARITY',
                                            ),
                                        ],
                                      ),
                                    ),
                                  const Divider(),
                                  if (_loadingPackageDescription)
                                    Container(
                                      height: _sectionHeight,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: const LinearProgressIndicator(),
                                    )
                                  else if (_errorLoadingPackageDescription ||
                                      _description?.isNotEmpty != true)
                                    _ErrorLoadingPartialInfo(
                                      errorMessage:
                                          'Error loading description.',
                                      onRefresh: _fetchPackageDescription,
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 13,
                                      ),
                                      child: Text(
                                        _description!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                ],
                              ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorLoadingPartialInfo extends StatelessWidget {
  const _ErrorLoadingPartialInfo({
    required this.onRefresh,
    required this.errorMessage,
  });

  final String errorMessage;

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onRefresh,
      child: Container(
        height: _sectionHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 13,
        ),
        child: Row(
          children: [
            Text(
              errorMessage,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.left,
            ),
            const Spacer(),
            const Icon(Icons.refresh),
          ],
        ),
      ),
    );
  }
}

class _ErrorLoadingAllInfo extends StatelessWidget {
  const _ErrorLoadingAllInfo({
    required this.onRefresh,
  });

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onRefresh,
      child: Container(
        height: _sectionHeight * 2,
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Error loading package info',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 10,
            ),
            Icon(Icons.refresh),
          ],
        ),
      ),
    );
  }
}

class _PackageStatistic extends StatelessWidget {
  const _PackageStatistic({
    required this.value,
    required this.description,
  });

  final String value;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          description,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}

const double _sectionHeight = 62;
