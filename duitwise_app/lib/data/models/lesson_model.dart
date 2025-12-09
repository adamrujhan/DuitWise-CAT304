//////////////////////////////////////////////////////////
//                 LEARNING MODEL
//////////////////////////////////////////////////////////
library;

class LessonModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final int durationMinutes;
  final String category;
  final int difficulty;
  final List<String> learningOutcomes;

  LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.durationMinutes,
    required this.category,
    required this.difficulty,
    required this.learningOutcomes,
  });

  factory LessonModel.fromMap(Map<String, dynamic> map) {
    return LessonModel(
      id: map["id"] ?? "",
      title: map["title"] ?? "",
      description: map["description"] ?? "",
      videoUrl: map["videoUrl"] ?? "",
      durationMinutes: map["durationMinutes"] ?? 0,
      category: map["category"] ?? "",
      difficulty: map["difficulty"] ?? 0,
      learningOutcomes: map["learningOutcomes"] != null
          ? List<String>.from(map["learningOutcomes"])
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "videoUrl": videoUrl,
      "durationMinutes": durationMinutes,
      "category": category,
      "difficulty": difficulty,
      "learningOutcomes": learningOutcomes,
    };
  }
}
