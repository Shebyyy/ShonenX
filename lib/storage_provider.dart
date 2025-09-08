// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:shonenx/core_new/eval/model/source_preference.dart';
import 'package:shonenx/main.dart';
import 'package:shonenx/core_new/models/category.dart';
import 'package:shonenx/core_new/models/changed.dart';
import 'package:shonenx/core_new/models/chapter.dart';
import 'package:shonenx/core_new/models/download.dart';
import 'package:shonenx/core_new/models/update.dart';
import 'package:shonenx/core_new/models/history.dart';
import 'package:shonenx/core_new/models/manga.dart';
import 'package:shonenx/core_new/models/settings.dart';
import 'package:shonenx/core_new/models/source.dart';
import 'package:shonenx/core_new/models/sync_preference.dart';
import 'package:shonenx/core_new/models/track.dart';
import 'package:shonenx/core_new/models/track_preference.dart';
import 'package:shonenx/core_new/utils/string_extensions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class StorageProvider {
  static bool _hasPermission = false;
  Future<bool> requestPermission() async {
    if (_hasPermission) return true;
    if (Platform.isAndroid) {
      Permission permission = Permission.manageExternalStorage;
      if (await permission.isGranted) {
        return true;
      } else {
        final result = await permission.request();
        if (result == PermissionStatus.granted) {
          _hasPermission = true;
          return true;
        }
        return false;
      }
    }
    return true;
  }

  Future<void> deleteBtDirectory() async {
    final d = await getBtDirectory();
    await Directory(d!.path).delete(recursive: true);
  }

  Future<void> deleteTmpDirectory() async {
    final d = await getTmpDirectory();
    await Directory(d!.path).delete(recursive: true);
  }

  Future<Directory?> getDefaultDirectory() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory("/storage/emulated/0/ShonenX/");
    } else {
      final dir = await getApplicationDocumentsDirectory();
      directory = Directory(path.join(dir.path, 'ShonenX'));
    }
    return directory;
  }

  Future<Directory?> getBtDirectory() async {
    final gefaultDirectory = await getDefaultDirectory();
    String dbDir = path.join(gefaultDirectory!.path, 'torrents');
    await Directory(dbDir).create(recursive: true);
    return Directory(dbDir);
  }

  Future<Directory?> getTmpDirectory() async {
    final gefaultDirectory = await getDirectory();
    String dbDir = path.join(gefaultDirectory!.path, 'tmp');
    await Directory(dbDir).create(recursive: true);
    return Directory(dbDir);
  }

  Future<Directory?> getIosBackupDirectory() async {
    final gefaultDirectory = await getDefaultDirectory();
    String dbDir = path.join(gefaultDirectory!.path, 'backup');
    await Directory(dbDir).create(recursive: true);
    return Directory(dbDir);
  }

  Future<Directory?> getDirectory() async {
    Directory? directory;
    String dPath = isar.settings.getSync(227)!.downloadLocation ?? "";
    if (Platform.isAndroid) {
      directory = Directory(
        dPath.isEmpty ? "/storage/emulated/0/ShonenX/" : "$dPath/",
      );
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final p = dPath.isEmpty ? dir.path : dPath;
      directory = Directory(path.join(p, 'ShonenX'));
    }
    return directory;
  }

  Future<Directory?> getMangaMainDirectory(Chapter chapter) async {
    final manga = chapter.manga.value!;
    final itemType = chapter.manga.value!.itemType;
    final itemTypePath = itemType == ItemType.manga
        ? "Manga"
        : itemType == ItemType.anime
        ? "Anime"
        : "Novel";
    final dir = await getDirectory();
    return Directory(
      path.join(
        dir!.path,
        'downloads',
        itemTypePath,
        '${manga.source} (${manga.lang!.toUpperCase()})',
        manga.name!.replaceForbiddenCharacters('_'),
      ),
    );
  }

  Future<Directory?> getMangaChapterDirectory(
    Chapter chapter, {
    Directory? mangaMainDirectory,
  }) async {
    final basedir = mangaMainDirectory ?? await getMangaMainDirectory(chapter);
    String scanlator = chapter.scanlator?.isNotEmpty ?? false
        ? "${chapter.scanlator!.replaceForbiddenCharacters('_')}_"
        : "";
    return Directory(
      path.join(
        basedir!.path,
        scanlator + chapter.name!.replaceForbiddenCharacters('_').trim(),
      ),
    );
  }

  Future<Directory?> getDatabaseDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      return dir;
    } else {
      String dbDir = path.join(dir.path, 'ShonenX', 'databases');
      await Directory(dbDir).create(recursive: true);
      return Directory(dbDir);
    }
  }

  Future<Directory?> getGalleryDirectory() async {
    String gPath = (await getDirectory())!.path;
    if (Platform.isAndroid) {
      gPath = "/storage/emulated/0/Pictures/ShonenX/";
    } else {
      gPath = path.join(gPath, 'Pictures');
    }
    await Directory(gPath).create(recursive: true);
    return Directory(gPath);
  }

  Future<Isar> initDB(String? path, {bool? inspector = false}) async {
    Directory? dir;
    if (path == null) {
      dir = await getDatabaseDirectory();
    } else {
      dir = Directory(path);
    }

    final isar = await Isar.open(
      [
        MangaSchema,
        ChangedPartSchema,
        ChapterSchema,
        CategorySchema,
        UpdateSchema,
        HistorySchema,
        DownloadSchema,
        SourceSchema,
        SettingsSchema,
        TrackPreferenceSchema,
        TrackSchema,
        SyncPreferenceSchema,
        SourcePreferenceSchema,
        SourcePreferenceStringValueSchema,
      ],
      directory: dir!.path,
      name: "shonenxDb",
      inspector: inspector!,
    );

    final settings = await isar.settings.filter().idEqualTo(227).findFirst();
    if (settings == null) {
      await isar.writeTxn(() async {
        isar.settings.put(Settings());
      });
    }

    return isar;
  }
}
