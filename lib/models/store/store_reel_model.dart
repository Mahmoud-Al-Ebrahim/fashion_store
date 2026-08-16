// To parse this JSON data, do
//
//     final storeReelModel = storeReelModelFromJson(jsonString);

import 'dart:convert';

StoreReelModel storeReelModelFromJson(String str) => StoreReelModel.fromJson(json.decode(str));

String storeReelModelToJson(StoreReelModel data) => json.encode(data.toJson());

class StoreReelModel {
  final List<Video>? videos;

  StoreReelModel({
    this.videos,
  });

  factory StoreReelModel.fromJson(Map<String, dynamic> json) => StoreReelModel(
    videos: json["videos"] == null ? [] : List<Video>.from(json["videos"]!.map((x) => Video.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "videos": videos == null ? [] : List<dynamic>.from(videos!.map((x) => x.toJson())),
  };
}

class Video {
  final String? id;
  final String? videoUrl;
  final String? thumbnailUrl;

  Video({
    this.id,
    this.videoUrl,
    this.thumbnailUrl,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: json["id"],
    videoUrl: json["videoUrl"],
    thumbnailUrl: json["thumbnailUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "videoUrl": videoUrl,
    "thumbnailUrl": thumbnailUrl,
  };
}
