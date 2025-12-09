//////////////////////////////////////////////////////////
//                 LEARNING MODEL
//////////////////////////////////////////////////////////
library;

class LearningModel {
  final Map<String, bool> completedLessons;
  final Map<String, int> quizScores;

  LearningModel({required this.completedLessons, required this.quizScores});

  factory LearningModel.fromMap(Map<String, dynamic> map) {
    return LearningModel(
      completedLessons: map["completedLessons"] != null
          ? Map<String, bool>.from(map["completedLessons"])
          : {},
      quizScores: map["quizScores"] != null
          ? Map<String, int>.from(map["quizScores"])
          : {},
    );
  }

  Map<String, dynamic> toMap() {
    return {"completedLessons": completedLessons, "quizScores": quizScores};
  }
}