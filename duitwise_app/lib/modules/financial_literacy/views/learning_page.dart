import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duitwise_app/core/widgets/rounded_card.dart';
import '../../../data/models/lesson_model.dart';
import '../providers/lesson_provider.dart';

class LearningPage extends ConsumerWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonState = ref.watch(lessonProvider);
    
    // Fetch lessons on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!lessonState.isLoading && lessonState.lessons.isEmpty) {
        ref.read(lessonProvider.notifier).fetchLessons();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              
              // Welcome Card
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Financial Learning",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          if (lessonState.lessons.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${lessonState.lessons.length} lessons",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Enhance your financial knowledge with interactive modules",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Loading State
              if (lessonState.isLoading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                ),

              // Error State
              if (lessonState.error != null)
                RoundedCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.error, color: Colors.red, size: 48),
                          SizedBox(height: 10),
                          Text(
                            lessonState.error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => ref.read(lessonProvider.notifier).fetchLessons(),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Empty State
              if (!lessonState.isLoading && lessonState.lessons.isEmpty && lessonState.error == null)
                RoundedCard(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.school, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No learning modules available',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Lessons List
              if (lessonState.lessons.isNotEmpty) ...[
                const SizedBox(height: 20),
                
                // Category Filter Chips
                // ... (keep your existing filter chips code)
                
                const SizedBox(height: 15),

                // Lessons Grid/List
                ...lessonState.lessons.map((lesson) {
                  return Column(
                    children: [
                      _buildLessonCard(lesson, context, ref),
                      SizedBox(height: 15),
                    ],
                  );
                }),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonCard(Lesson lesson, BuildContext context, WidgetRef ref) {
    return RoundedCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Category and Difficulty
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Category Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: lesson.difficultyColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    lesson.localizedCategory,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                // Difficulty Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: lesson.difficultyColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        lesson.difficultyIcon,
                        size: 14,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        lesson.difficultyText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            // Lesson Title
            Text(
              lesson.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
            
            SizedBox(height: 8),
            
            // Lesson Description
            Text(
              lesson.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),

            
            SizedBox(height: 20),
            
            // Duration and Completion Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.timer,
                        size: 18,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Duration",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          "${lesson.durationMinutes} minutes",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            // Action Buttons
            Row(
              children: [
                // Learn Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showLessonDetail(context, lesson, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow, size: 20),
                        SizedBox(width: 8),
                        Text(
                          lesson.isCompleted ? 'Review' : 'Start Learning',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(width: 12),
                
                // Quiz Button
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200, width: 1.5),
                  ),
                  child: IconButton(
                    onPressed: () => _startQuiz(context, lesson, ref),
                    icon: Icon(
                      Icons.quiz,
                      color: Colors.orange.shade700,
                      size: 22,
                    ),
                    tooltip: 'Take Quiz',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLessonDetail(BuildContext context, Lesson lesson, WidgetRef ref) {
    // ... (your existing modal code)
  }

  void _startQuiz(BuildContext context, Lesson lesson, WidgetRef ref) {
    // ... (your existing quiz code)
  }
}