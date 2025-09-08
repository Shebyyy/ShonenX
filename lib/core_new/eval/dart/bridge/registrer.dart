import 'package:d4rt/d4rt.dart';
import 'package:shonenx/core_new/eval/dart/bridge/document.dart';
import 'package:shonenx/core_new/eval/dart/bridge/element.dart';
import 'package:shonenx/core_new/eval/dart/bridge/filter.dart';
import 'package:shonenx/core_new/eval/dart/bridge/http.dart';
import 'package:shonenx/core_new/eval/dart/bridge/m_chapter.dart';
import 'package:shonenx/core_new/eval/dart/bridge/m_manga.dart';
import 'package:shonenx/core_new/eval/dart/bridge/m_pages.dart';
import 'package:shonenx/core_new/eval/dart/bridge/m_provider.dart';
import 'package:shonenx/core_new/eval/dart/bridge/m_source.dart';
import 'package:shonenx/core_new/eval/dart/bridge/m_status.dart';
import 'package:shonenx/core_new/eval/dart/bridge/m_track.dart';
import 'package:shonenx/core_new/eval/dart/bridge/m_video.dart';
import 'package:shonenx/core_new/eval/dart/bridge/source_preference.dart';

class RegistrerBridge {
  static void registerBridge(D4rt interpreter) {
    MDocumentBridge().registerBridgedClasses(interpreter);
    MElementBridge().registerBridgedClasses(interpreter);
    FilterBridge().registerBridgedClasses(interpreter);
    HttpBridge().registerBridgedClasses(interpreter);
    MMangaBridge().registerBridgedClasses(interpreter);
    MChapterBridge().registerBridgedClasses(interpreter);
    MPagesBridge().registerBridgedClasses(interpreter);
    MProviderBridged().registerBridgedClasses(interpreter);
    MSourceBridge().registerBridgedClasses(interpreter);
    MStatusBridge().registerBridgedEnum(interpreter);
    MTrackBridge().registerBridgedClasses(interpreter);
    MVideoBridge().registerBridgedClasses(interpreter);
    SourcePreferenceBridge().registerBridgedClasses(interpreter);
  }
}
