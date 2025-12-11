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
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${lessonState.lessons.length} ${lessonState.lessons.length == 1 ? 'lesson' : 'lessons'}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
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
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                    ),
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
                          const Icon(Icons.error, color: Colors.red, size: 48),
                          const SizedBox(height: 10),
                          Text(
                            lessonState.error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => ref.read(lessonProvider.notifier).fetchLessons(),
                            child: const Text('Retry'),
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
                          Icon(Icons.school, size: 64, color: Colors.grey.shade600),
                          const SizedBox(height: 16),
                          Text(
                            'No learning modules available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Check back later for new content',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
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
                      const SizedBox(height: 15),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: lesson.categoryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    lesson.localizedCategory,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                // Difficulty Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      const SizedBox(width: 4),
                      Text(
                        lesson.difficultyText,
                        style: const TextStyle(
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
            
            const SizedBox(height: 16),
            
            // Lesson Title
            Text(
              lesson.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 8),
            
            // Lesson Description
            Text(
              lesson.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 20),
            
            // Duration
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.timer,
                    size: 18,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 8),
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
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Action Buttons
            Row(
              children: [
                // Learn Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showLessonDetail(context, lesson, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Start Learning',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              lesson.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(lesson.description),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to actual lesson page
              },
              child: const Text('Start Lesson'),
            ),
          ],
        ),
      ),
    );
  }

  void _startQuiz(BuildContext context, Lesson lesson, WidgetRef ref) {
    // ... (your existing quiz code)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${lesson.title} Quiz"),
        content: const Text("Are you ready to take the quiz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to quiz page
            },
            child: const Text('Start Quiz'),
          ),
        ],
      ),
    );
  }
}