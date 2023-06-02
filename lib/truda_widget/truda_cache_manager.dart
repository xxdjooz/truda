import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cache_manager/src/storage/file_system/file_system.dart';

/// aic的缓存管理器
class TrudaAicCacheManager {
  static const key = 'aicCache';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 2),
      maxNrOfCacheObjects: 20,
      repo: JsonCacheInfoRepository(databaseName: key),
      // fileSystem: IOFileSystem(key),
      fileService: HttpFileService(),
    ),
  );
}

/// 礼物的缓存管理器
class TrudaGiftCacheManager {
  static const key = 'giftCache';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 50,
      repo: JsonCacheInfoRepository(databaseName: key),
      // fileSystem: IOFileSystem(key),
      fileService: HttpFileService(),
    ),
  );
}

// getTemporaryDirectory() ：获取临时文件路径(IOS和安卓通用)
// getApplicationSupportDirectory() ：获取应用支持目录(IOS和安卓通用)
// getApplicationDocumentsDirectory() ：获取应用文件目录(IOS和安卓通用)，
// 针对 Android 设备的 AppDate 目录，iOS 设备的 NSDocumentDirectory 目录
// getLibraryDirectory() ：获取应用持久存储目录路径(仅IOS可用)
// getExternalStorageDirectory() ： 获取存储卡目录(仅安卓可用)
// getExternalCacheDirectories() ：获取外部缓存目录(仅安卓可用)
// getDownloadsDirectory() ：获取下载目录(仅桌面可用)
