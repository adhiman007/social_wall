import 'dart:convert';

import 'package:flutter/foundation.dart';

class PostModel {
  final String id;
  final String title;
  final String description;
  final String createdById;
  final String createdByName;
  final int timestamp;
  final String image;
  final String url;
  final bool hasImage;
  final List<String> likes;

  const PostModel({
    this.id = '',
    required this.title,
    required this.description,
    required this.createdById,
    required this.createdByName,
    required this.timestamp,
    required this.image,
    required this.url,
    required this.hasImage,
    required this.likes,
  });

  PostModel copyWith({
    String? id,
    String? title,
    String? description,
    String? createdById,
    String? createdByName,
    int? timestamp,
    String? image,
    String? url,
    bool? hasImage,
    List<String>? likes,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      timestamp: timestamp ?? this.timestamp,
      image: image ?? this.image,
      url: url ?? this.url,
      hasImage: hasImage ?? this.hasImage,
      likes: likes ?? this.likes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdById': createdById,
      'createdByName': createdByName,
      'timestamp': timestamp,
      'image': image,
      'url': url,
      'hasImage': hasImage,
      'likes': likes,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      title: map['title'],
      description: map['description'],
      createdById: map['createdById'],
      createdByName: map['createdByName'],
      timestamp: map['timestamp'],
      image: map['image'],
      url: map['url'],
      hasImage: map['hasImage'],
      likes: List<String>.from(map['likes']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post(title: $title, description: $description, createdById: $createdById, createdByName: $createdByName, timestamp: $timestamp, image: $image, url: $url, hasImage: $hasImage, likes: $likes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PostModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.createdById == createdById &&
        other.createdByName == createdByName &&
        other.timestamp == timestamp &&
        other.image == image &&
        other.url == url &&
        other.hasImage == hasImage &&
        listEquals(other.likes, likes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        createdById.hashCode ^
        createdByName.hashCode ^
        timestamp.hashCode ^
        image.hashCode ^
        url.hashCode ^
        hasImage.hashCode ^
        likes.hashCode;
  }
}
