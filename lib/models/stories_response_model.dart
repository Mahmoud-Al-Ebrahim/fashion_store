// To parse this JSON data, do
//
//     final storiesResponseModel = storiesResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:fashion_store/models/posts_response_model.dart';

StoriesResponseModel storiesResponseModelFromJson(String str) => StoriesResponseModel.fromJson(json.decode(str));

String storiesResponseModelToJson(StoriesResponseModel data) => json.encode(data.toJson());

class StoriesResponseModel {
  final List<OwnerStory>? ownerStories;
  final Stories? stories;

  StoriesResponseModel({
    this.ownerStories,
    this.stories,
  });

  StoriesResponseModel copyWith({
    List<OwnerStory>? ownerStories,
    Stories? stories,
  }) =>
      StoriesResponseModel(
        ownerStories: ownerStories ?? this.ownerStories,
        stories: stories ?? this.stories,
      );

  factory StoriesResponseModel.fromJson(Map<String, dynamic> json) => StoriesResponseModel(
    ownerStories: json["ownerStories"] == null ? [] : List<OwnerStory>.from(json["ownerStories"]!.map((x) => OwnerStory.fromJson(x))),
    stories: json["stories"] == null ? null : Stories.fromJson(json["stories"]),
  );

  Map<String, dynamic> toJson() => {
    "ownerStories": ownerStories == null ? [] : List<dynamic>.from(ownerStories!.map((x) => x.toJson())),
    "stories": stories?.toJson(),
  };
}

class OwnerStory {
  final Store? store;
  final List<Story>? stories;

  OwnerStory({
    this.store,
    this.stories,
  });

  OwnerStory copyWith({
    Store? store,
    List<Story>? stories,
  }) =>
      OwnerStory(
        store: store ?? this.store,
        stories: stories ?? this.stories,
      );

  factory OwnerStory.fromJson(Map<String, dynamic> json) => OwnerStory(
    store: json["store"] == null ? null : Store.fromJson(json["store"]),
    stories: json["stories"] == null ? [] : List<Story>.from(json["stories"]!.map((x) => Story.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "store": store?.toJson(),
    "stories": stories == null ? [] : List<dynamic>.from(stories!.map((x) => x.toJson())),
  };
}

class Owner {
  final String? id;
  final String? firstName;
  final String? lastName;

  Owner({
    this.id,
    this.firstName,
    this.lastName,
  });

  Owner copyWith({
    String? id,
    String? firstName,
    String? lastName,
  }) =>
      Owner(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
      );

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
  };
}

class Story {
  final String? id;
  final String? mediaUrl;
  final dynamic thumbnailUrl;
  final String? text;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final Reactions? reactions;
  final String? hasReacted;

  Story({
    this.id,
    this.mediaUrl,
    this.thumbnailUrl,
    this.text,
    this.createdAt,
    this.expiresAt,
    this.reactions,
    this.hasReacted,
  });

  Story copyWith({
    String? id,
    String? mediaUrl,
    dynamic thumbnailUrl,
    String? text,
    DateTime? createdAt,
    DateTime? expiresAt,
    Reactions? reactions,
    String? hasReacted,
  }) =>
      Story(
        id: id ?? this.id,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        text: text ?? this.text,
        createdAt: createdAt ?? this.createdAt,
        expiresAt: expiresAt ?? this.expiresAt,
        reactions: reactions ?? this.reactions,
        hasReacted: hasReacted ?? this.hasReacted,
      );

  factory Story.fromJson(Map<String, dynamic> json) => Story(
    id: json["id"],
    mediaUrl: json["mediaUrl"],
    thumbnailUrl: json["thumbnailUrl"],
    text: json["text"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    expiresAt: json["expiresAt"] == null ? null : DateTime.parse(json["expiresAt"]),
    reactions: json["reactions"] == null ? null : Reactions.fromJson(json["reactions"]),
    hasReacted: json["hasReacted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mediaUrl": mediaUrl,
    "thumbnailUrl": thumbnailUrl,
    "text": text,
    "createdAt": createdAt?.toIso8601String(),
    "expiresAt": expiresAt?.toIso8601String(),
    "reactions": reactions?.toJson(),
    "hasReacted": hasReacted,
  };
}

class Reactions {
  final int? like;
  final int? love;
  final int? fire;

  Reactions({
    this.like,
    this.love,
    this.fire,
  });

  Reactions copyWith({
    int? like,
    int? love,
    int? fire,
  }) =>
      Reactions(
        like: like ?? this.like,
        love: love ?? this.love,
        fire: fire ?? this.fire,
      );

  factory Reactions.fromJson(Map<String, dynamic> json) => Reactions(
    like: json["like"],
    love: json["love"],
    fire: json["fire"],
  );

  Map<String, dynamic> toJson() => {
    "like": like,
    "love": love,
    "fire": fire,
  };
}

class Stories {
  final List<OwnerStory>? items;
  final int? page;
  final int? limit;
  final int? total;

  Stories({
    this.items,
    this.page,
    this.limit,
    this.total,
  });

  Stories copyWith({
    List<OwnerStory>? items,
    int? page,
    int? limit,
    int? total,
  }) =>
      Stories(
        items: items ?? this.items,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        total: total ?? this.total,
      );

  factory Stories.fromJson(Map<String, dynamic> json) => Stories(
    items: json["items"] == null ? [] : List<OwnerStory>.from(json["items"]!.map((x) => OwnerStory.fromJson(x))),
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    "page": page,
    "limit": limit,
    "total": total,
  };
}
