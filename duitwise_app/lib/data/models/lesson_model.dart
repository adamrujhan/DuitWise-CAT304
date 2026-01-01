//////////////////////////////////////////////////////////
//                 LESSON MODEL
//////////////////////////////////////////////////////////
library;

import 'package:flutter/material.dart';

class Lesson {
  final String id;
  final String title;
  final String description;
  final String? videoUrl;
  final String category;
  final int difficulty; 
  final List<String> learningOutcomes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    this.videoUrl,
    required this.category,
    required this.difficulty,
    required this.learningOutcomes,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor from JSON (Firebase)
  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'],
      category: json['category'] ?? '',
      difficulty: json['difficulty'] ?? 1,
      learningOutcomes: json['learningOutcomes'] != null
          ? List<String>.from(json['learningOutcomes'])
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  String get localizedCategory => category;

  Color get categoryColor {
    return const Color.fromARGB(255, 71, 178, 160);
  }

  String get difficultyText {
    switch (difficulty) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Intermediate';
      case 3:
        return 'Advanced';
      default:
        return 'Unknown';
    }
  }

  Color get difficultyColor {
    switch (difficulty) {
      case 1:
        return const Color.fromARGB(255, 78, 183, 47);
      case 2:
        return Colors.orange;
      case 3:
        return const Color.fromARGB(255, 163, 69, 180);
      default:
        return Colors.grey;
    }
  }
}