import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageService extends GetxService {
  final GetStorage _storage;

  LocalStorageService({
    required GetStorage storage,
  }) : _storage = storage;

  Future<void> init() async {
    await GetStorage.init();
  }

  T? get<T>(String boxName) {
    return _storage.read<T>(boxName);
  }

  Future<void> save<T>(String boxName, T value) async {
    return await _storage.write(boxName, value);
  }

  Future<void> erase(String boxName) async {
    await _storage.write(boxName, null);
  }
}
