import 'package:get/get.dart';

import '../../../services/pub_service.dart';

class SearchPackagesResultsController extends GetxController
    with StateMixin<List<String>> {
  final PubService pubService;

  SearchPackagesResultsController({
    required this.pubService,
  });

  search(String term) async {
    try {
      change([], status: RxStatus.loading());

      final packages = await pubService.search(term: term);

      if (packages.isEmpty) {
        change([], status: RxStatus.empty());
        return;
      }

      change(packages, status: RxStatus.success());
    } catch (e) {
      change([], status: RxStatus.error('Error searching packages'));
    }
  }

  void clear() {
    change([], status: RxStatus.empty());
  }
}
