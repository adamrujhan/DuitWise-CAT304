// lib/modules/financial_literacy/widgets/lesson_card.dart
import 'package:flutter/material.dart';
import '../../../data/models/lesson_model.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;
  final VoidCallback onQuizTap;

  const LessonCard({
    required this.lesson,
    required this.onTap,
    required this.onQuizTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with category and difficulty
              Row(
                children: [
                  _buildCategoryBadge(),
                  const SizedBox(width: 8),
                  _buildDifficultyBadge(),
                  const Spacer(),
                  _buildDurationChip(),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Title and description
              Text(
                lesson.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                lesson.description,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onTap,
                      child: const Text('Learn'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: onQuizTap,
                    icon: const Icon(Icons.quiz, size: 16),
                    label: const Text('Quiz'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: lesson.categoryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        lesson.localizedCategory,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: lesson.difficultyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            lesson.difficultyIcon,
            size: 12,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            lesson.difficultyText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationChip() {
    return Chip(
      label: Text('${lesson.durationMinutes} min'),
      backgroundColor: Colors.blue[50],
      labelStyle: const TextStyle(fontSize: 12),
    );
  }
}