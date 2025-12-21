// lib/modules/financial_literacy/services/quiz_navigation_service.dart
import 'package:flutter/material.dart';
import 'package:duitwise_app/data/models/lesson_model.dart';
import 'package:duitwise_app/data/repositories/quiz_repository.dart';
import '../views/quiz_page.dart';

class QuizNavigationService {
  // Start quiz dialog
  static Future<void> showQuizDialog(BuildContext context, Lesson lesson) async {
    final quizRepo = QuizRepository();
    
    try {
      // Fetch data FIRST
      final questionCount = await quizRepo.getQuestionCountForLesson(lesson.id);
      final totalTimeSeconds = await quizRepo.getTotalQuizTimeForLesson(lesson.id);
      
      // Then show dialog with the data
      _showQuizInfoDialog(
        context, 
        lesson, 
        questionCount, 
        (totalTimeSeconds / 60).ceil()
      );
      
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  static void _showQuizInfoDialog(
    BuildContext context,
    Lesson lesson,
    int questionCount,
    int totalTimeMinutes,
  ) {
    final difficultyColor = lesson.difficultyColor;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "${lesson.title} Quiz",
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Are you ready to take the quiz?"),
            const SizedBox(height: 10),
            
            if (lesson.learningOutcomes.isNotEmpty) ...[
              const Text(
                "This quiz covers:",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              
              Column(
                children: lesson.learningOutcomes.take(3).map((outcome) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(
                            Icons.circle,
                            size: 8,
                            color: Color.fromARGB(255, 36, 35, 35),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            outcome,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],
            
            // Difficulty info box with REAL DATA only
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: difficultyColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: difficultyColor.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              lesson.difficultyIcon,
                              size: 20,
                              color: difficultyColor,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${lesson.difficultyText} Level",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: difficultyColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "$questionCount questions • $totalTimeMinutes min",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _navigateToQuiz(context, lesson);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Start Quiz'),
          ),
        ],
      ),
    );
  }

  static void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Error Loading Quiz',
          style: TextStyle(color: Colors.red),
        ),
        content: Text(
          'Failed to load quiz information from server.\n\nError: $error',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void _showNoQuestionsDialog(BuildContext context, Lesson lesson) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'No Quiz Available',
          style: TextStyle(color: Colors.orange),
        ),
        content: Text(
          'Sorry, there are no quiz questions available for "${lesson.title}" yet.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Navigate to actual quiz page
  static void _navigateToQuiz(BuildContext context, Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(lesson: lesson),
      ),
    );
  }
}