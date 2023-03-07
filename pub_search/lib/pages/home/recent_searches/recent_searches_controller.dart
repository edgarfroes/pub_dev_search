import 'package:get/get.dart';

import '../../../services/local_storage_service.dart';

class RecentSearchesController extends GetxController
    with StateMixin<List<String>> {
  final LocalStorageService localStorageRepository;

  RecentSearchesController({
    required this.localStorageRepository,
  });

  @override
  void onInit() {
    super.onInit();

    getRecentSearches();
  }

  getRecentSearches() async {
    try {
      change([], status: RxStatus.loading());

      final packages =
          (localStorageRepository.get<List<dynamic>>(_recentPackagesBoxName) ??
                  [])
              .cast<String>();

      if (packages.isEmpty) {
        change([], status: RxStatus.empty());
        return;
      }

      change(packages, status: RxStatus.success());
    } catch (e) {
      change([], status: RxStatus.error('Error fetching recent searches'));
    }
  }

  Future<void> save(String packageName) async {
    if (state?.contains(packageName) != true) {
      change(
        [
          packageName,
          ...state ?? [],
        ],
        status: RxStatus.success(),
      );

      await localStorageRepository.save(_recentPackagesBoxName, state ?? []);
    }
  }

  void clear() {
    change([], status: RxStatus.empty());
    localStorageRepository.erase(_recentPackagesBoxName);
  }
}

const String _recentPackagesBoxName = 'recentPackages';
