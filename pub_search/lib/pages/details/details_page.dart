import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/pub_service.dart';
import '../../widgets/package_statistic.dart';
import '../../widgets/rounded_container.dart';
import 'details_page_controller.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(
      DetailsPageController(
        pubService: Get.find<PubService>(),
      ),
    );

    return _DetailsPage();
  }
}

class _DetailsPage extends GetView<DetailsPageController> {
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
                        child: Text(controller.packageName.value),
                      ),
                      const Divider(),
                      controller.obx(
                        (state) {
                          return Column(
                            children: [
                              controller.packageMetricsController.obx(
                                (state) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 13,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (state != null) ...[
                                        PackageStatistic(
                                          value: '${state.likes}',
                                          description: 'LIKES',
                                        ),
                                        PackageStatistic(
                                          value: '${state.popularity}',
                                          description: 'PUB POINTS',
                                        ),
                                        PackageStatistic(
                                          value: '${state.popularity}%',
                                          description: 'POPULARITY',
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                onLoading: Container(
                                  height: _sectionHeight,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: const LinearProgressIndicator(),
                                ),
                                onError: (error) => _ErrorLoadingPartialInfo(
                                  errorMessage:
                                      error ?? 'Error loading metrics.',
                                  onRefresh:
                                      controller.packageMetricsController.fetch,
                                ),
                              ),
                              const Divider(),
                              controller.packageDescriptionController.obx(
                                (state) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 13,
                                  ),
                                  child: Text(
                                    state ?? '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                onLoading: Container(
                                  height: _sectionHeight,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: const LinearProgressIndicator(),
                                ),
                                onError: (error) => _ErrorLoadingPartialInfo(
                                  errorMessage: 'Error loading description.',
                                  onRefresh: controller
                                      .packageDescriptionController.fetch,
                                ),
                              ),
                            ],
                          );
                        },
                        onError: (error) => _ErrorLoadingAllInfo(
                          onRefresh: controller.fetch,
                        ),
                        onLoading: Container(
                          height: _sectionHeight * 2,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
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

const double _sectionHeight = 62;
