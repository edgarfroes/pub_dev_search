import 'package:get/get.dart';
import 'package:pub_api_client/pub_api_client.dart';

class PubService extends GetxService {
  final PubClient _client;

  PubService({
    required PubClient client,
  }) : _client = client;

  Future<List<String>> search({
    required String term,
    int itemsPerPage = 5,
  }) async {
    return (await _client.search(term))
        .packages
        .take(itemsPerPage)
        .map((x) => x.package)
        .toList();
  }

  Future<PackageMetrics> getMetrics(String packageName) async {
    final packageScore = await _client.packageScore(packageName);

    return PackageMetrics(
      pubPoints: packageScore.grantedPoints ?? 0,
      likes: packageScore.likeCount,
      popularity: ((packageScore.popularityScore ?? 0) * 100).truncate(),
    );
  }

  Future<String> getDescription(String packageName) async {
    final packageInfo = await _client.packageInfo(packageName);

    return packageInfo.description;
  }
}

class PackageMetrics {
  final int likes;
  final int pubPoints;
  final int popularity;

  PackageMetrics({
    required this.likes,
    required this.pubPoints,
    required this.popularity,
  });
}
