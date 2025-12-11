import 'package:flutter/material.dart';


class Lesson {
  final String id;
  final String title;
  final String description;
  final String? videoUrl;
  final int durationMinutes; // in minutes
  final String category; // Budgeting, Saving, Investing, Debt
  final int difficulty; // 1=Beginner, 2=Intermediate, 3=Advanced
  final List<String> learningOutcomes;
  final bool isCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    this.videoUrl,
    required this.durationMinutes,
    required this.category,
    required this.difficulty,
    required this.learningOutcomes,
    this.isCompleted = false,
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
      durationMinutes: json['durationMinutes'] ?? 0,
      category: json['category'] ?? '',
      difficulty: json['difficulty'] ?? 1,
      learningOutcomes: json['learningOutcomes'] != null
          ? List<String>.from(json['learningOutcomes'])
          : [],
      isCompleted: json['isCompleted'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  // Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'durationMinutes': durationMinutes,
      'category': category,
      'difficulty': difficulty,
      'learningOutcomes': learningOutcomes,
      'isCompleted': isCompleted,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Helper methods for UI
  Duration get duration => Duration(minutes: durationMinutes);

  String get localizedCategory {
    // Check localization first, then fallback

    
    // Default translations
    switch (category.toLowerCase()) {
      case 'budgeting': return 'Bajet';
      case 'saving': return 'Simpanan';
      case 'investing': return 'Pelaburan';
      case 'debt': return 'Hutang';
      default: return category;
    }
  }

  String get difficultyText {
    switch (difficulty) {
      case 1: return 'Beginner';
      case 2: return 'Intermediate';
      case 3: return 'Advanced';
      default: return 'Unknown';
    }
  }

  Color get difficultyColor {
    switch (difficulty) {
      case 1: return Colors.green;
      case 2: return Colors.orange;
      case 3: return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData get difficultyIcon {
    switch (difficulty) {
      case 1: return Icons.flag;
      case 2: return Icons.trending_up;
      case 3: return Icons.star;
      default: return Icons.help;
    }
  }

  // Copy with method for updates
  Lesson copyWith({
    String? id,
    String? title,
    String? description,
    String? videoUrl,
    int? durationMinutes,
    String? category,
    int? difficulty,
    List<String>? learningOutcomes,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      learningOutcomes: learningOutcomes ?? this.learningOutcomes,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}