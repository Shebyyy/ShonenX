// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class BaseEpisode {
  String? get id;

  String? get title;

  String? get url;

  String? get thumbnail;

  bool? get isFiller;

  int? get number;
}

class BaseEpisodeModel {
  final int? totalEpisodes;
  final List<EpisodeDataModel>? episodes;

  BaseEpisodeModel({this.totalEpisodes, this.episodes});
}

class EpisodeDataModel implements BaseEpisode {
  @override
  final String? id;
  @override
  final String? title;
  @override
  final String? url;
  @override
  final String? thumbnail;
  @override
  final bool? isFiller;
  @override
  final int? number;

  EpisodeDataModel({
    this.id,
    this.title,
    this.url,
    this.thumbnail,
    this.isFiller,
    this.number,
  });

  EpisodeDataModel copyWith({
    String? id,
    String? title,
    String? url,
    String? thumbnail,
    bool? isFiller,
    int? number,
  }) {
    return EpisodeDataModel(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      thumbnail: thumbnail ?? this.thumbnail,
      isFiller: isFiller ?? this.isFiller,
      number: number ?? this.number,
    );
  }
}
