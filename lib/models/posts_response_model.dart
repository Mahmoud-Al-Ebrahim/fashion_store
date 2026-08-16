// To parse this JSON data, do
//
//     final postsResponseModel = postsResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:fashion_store/models/stories_response_model.dart';

PostsResponseModel postsResponseModelFromJson(String str) => PostsResponseModel.fromJson(json.decode(str));

String postsResponseModelToJson(PostsResponseModel data) => json.encode(data.toJson());

class PostsResponseModel {
  final List<PostModel>? items;
  final int? page;
  final int? limit;
  final int? total;

  PostsResponseModel({
    this.items,
    this.page,
    this.limit,
    this.total,
  });

  PostsResponseModel copyWith({
    List<PostModel>? items,
    int? page,
    int? limit,
    int? total,
  }) =>
      PostsResponseModel(
        items: items ?? this.items,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        total: total ?? this.total,
      );

  factory PostsResponseModel.fromJson(Map<String, dynamic> json) => PostsResponseModel(
    items: json["items"] == null ? [] : List<PostModel>.from(json["items"]!.map((x) => PostModel.fromJson(x))),
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

class PostModel {
  final String? id;
  final dynamic text;
  final String? mediaUrl;
  final dynamic thumbnailUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Store? store;
  final Reactions? reactions;
  final String? hasReacted;
  final bool? isFollowed;

  PostModel({
    this.id,
    this.text,
    this.mediaUrl,
    this.thumbnailUrl,
    this.createdAt,
    this.updatedAt,
    this.store,
    this.reactions,
    this.hasReacted,
    this.isFollowed,
  });

  PostModel copyWith({
    String? id,
    dynamic text,
    String? mediaUrl,
    dynamic thumbnailUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    Store? store,
    Reactions? reactions,
    String? hasReacted,
    bool? isFollowed
  }) =>
      PostModel(
        id: id ?? this.id,
        text: text ?? this.text,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        store: store ?? this.store,
        reactions: reactions ?? this.reactions,
        hasReacted: hasReacted ?? this.hasReacted,
        isFollowed: isFollowed ?? this.isFollowed,
      );

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json["id"],
    text: json["text"],
    mediaUrl: json["mediaUrl"],
    thumbnailUrl: json["thumbnailUrl"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    store: json["store"] == null ? null : Store.fromJson(json["store"]),
    reactions: json["reactions"] == null ? null : Reactions.fromJson(json["reactions"]),
    hasReacted: json["hasReacted"],
    isFollowed: json["isFollowed"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
    "mediaUrl": mediaUrl,
    "thumbnailUrl": thumbnailUrl,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "store": store?.toJson(),
    "reactions": reactions?.toJson(),
    "hasReacted": hasReacted,
    "isFollowed": isFollowed,
  };
}


class Store {
  final String? id;
  final String? name;
  final String? location;
  final String? latitude;
  final String? longitude;
  final dynamic identityImage1;
  final dynamic identityImage2;
  final String? logoUrl;
  final String? mainImage;
  final String? description;
  final String? workingHours;
  final String? type;
  final int? averageRating;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Owner? owner;

  Store({
    this.id,
    this.name,
    this.location,
    this.latitude,
    this.longitude,
    this.identityImage1,
    this.identityImage2,
    this.logoUrl,
    this.mainImage,
    this.description,
    this.workingHours,
    this.type,
    this.averageRating,
    this.createdAt,
    this.updatedAt,
    this.owner,
  });

  Store copyWith({
    String? id,
    String? name,
    String? location,
    String? latitude,
    String? longitude,
    dynamic identityImage1,
    dynamic identityImage2,
    String? logoUrl,
    String? mainImage,
    String? description,
    String? workingHours,
    String? type,
    int? averageRating,
    DateTime? createdAt,
    DateTime? updatedAt,
    Owner? owner,
  }) =>
      Store(
        id: id ?? this.id,
        name: name ?? this.name,
        location: location ?? this.location,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        identityImage1: identityImage1 ?? this.identityImage1,
        identityImage2: identityImage2 ?? this.identityImage2,
        logoUrl: logoUrl ?? this.logoUrl,
        mainImage: mainImage ?? this.mainImage,
        description: description ?? this.description,
        workingHours: workingHours ?? this.workingHours,
        type: type ?? this.type,
        averageRating: averageRating ?? this.averageRating,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        owner: owner ?? this.owner,
      );

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    id: json["id"],
    name: json["name"],
    location: json["location"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    identityImage1: json["identityImage1"],
    identityImage2: json["identityImage2"],
    logoUrl: json["logo_url"],
    mainImage: json["mainImage"],
    description: json["description"],
    workingHours: json["workingHours"],
    type: json["type"],
    averageRating: json["averageRating"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location": location,
    "latitude": latitude,
    "longitude": longitude,
    "identityImage1": identityImage1,
    "identityImage2": identityImage2,
    "logo_url": logoUrl,
    "mainImage": mainImage,
    "description": description,
    "workingHours": workingHours,
    "type": type,
    "averageRating": averageRating,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "owner": owner?.toJson(),
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
