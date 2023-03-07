import 'package:get/get.dart';

import '../../services/pub_service.dart';

class DetailsPageController extends GetxController with StateMixin {
  final PubService pubService;
  late final PackageDescriptionController packageDescriptionController;
  late final PackageMetricsController packageMetricsController;

  DetailsPageController({
    required this.pubService,
  });

  final packageName = ''.obs;

  @override
  onInit() {
    super.onInit();

    _initDependencies();

    fetch();
  }

  void _initDependencies() {
    packageName.value = (Get.arguments['packageName'] as String);

    packageDescriptionController = Get.put(
      PackageDescriptionController(
        pubService: Get.find<PubService>(),
        packageName: packageName.value,
      ),
    );

    packageMetricsController = Get.put(
      PackageMetricsController(
        pubService: Get.find<PubService>(),
        packageName: packageName.value,
      ),
    );
  }

  Future<void> fetch() async {
    try {
      change(null, status: RxStatus.loading());

      await Future.wait([
        packageDescriptionController.fetch(),
        packageMetricsController.fetch(),
      ]);

      if (packageDescriptionController.status == RxStatus.error() &&
          packageMetricsController.status == RxStatus.error()) {
        throw Exception('Error fetching everything');
      }

      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error('Error loading package info'));
    }
  }
}

class PackageDescriptionController extends GetxController
    with StateMixin<String> {
  final PubService pubService;
  final String packageName;

  PackageDescriptionController({
    required this.pubService,
    required this.packageName,
  });

  Future<void> fetch() async {
    try {
      change(null, status: RxStatus.loading());

      final description = await pubService.getDescription(packageName);

      if (description.isEmpty) {
        throw Exception('Description can\'t be empty');
      }

      change(description, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error('Error loading package description'));
    }
  }
}

class PackageMetricsController extends GetxController
    with StateMixin<PackageMetrics> {
  final PubService pubService;
  final String packageName;

  PackageMetricsController({
    required this.pubService,
    required this.packageName,
  });

  Future<void> fetch() async {
    try {
      change(null, status: RxStatus.loading());

      final metrics = await pubService.getMetrics(packageName);

      change(metrics, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error('Error loading package metrics'));
    }
  }
}
