// import 'package:shonenx/core_new/eval/model/m_manga.dart';
// import 'package:shonenx/core_new/models/source.dart';
// import '../Eval/dart/service.dart';
// import '../Eval/javascript/service.dart';

// Future<List<MManga?>>? search(
//     {required Source source,
//     required String query,
//     required int page,
//     required List<dynamic> filterList}) async {
//   List<MManga>? manga;
//   if (source.sourceCodeLanguage == SourceCodeLanguage.dart) {
//     manga = (await DartExtensionService(source).search(query, page, filterList))
//         .list;
//   } else {
//     manga =
//         (await JsExtensionService(source).search(query, page, filterList)).list;
//   }
//   return manga;
// }