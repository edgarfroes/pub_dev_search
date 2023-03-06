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

    _fetchPackageDetails();
  }

  Future<void> _fetchPackageDetails() async {
    setState(() {
      _loadingInfo = true;
    });

    // Call all APIs asynchronously
    await Future.wait([
      Future(() async {
        final packageInfo = await _client.packageInfo(widget.packageName);
        _description = packageInfo.description;
      }),
      Future(() async {
        final packageStatus = await _client.packageScore(widget.packageName);
        _likes = packageStatus.likeCount;
        _pubPoints = packageStatus.grantedPoints;
        _popularity = packageStatus.popularityScore;
      }),
    ]);

    setState(() {
      _loadingInfo = false;
    });
  }

  final _client = PubClient();

  bool _loadingInfo = false;

  int? _likes;
  int? _pubPoints;
  double? _popularity;
  String? _description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  color: theme.primaryColor,
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
                      Container(
                        constraints: const BoxConstraints(minHeight: 62),
                        child: Column(
                          children: [
                            if (_loadingInfo == true)
                              const LinearProgressIndicator(),
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
                            if (_description?.isNotEmpty == true)
                              Column(
                                children: [
                                  const Divider(),
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
                                  )
                                ],
                              )
                          ],
                        ),
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
