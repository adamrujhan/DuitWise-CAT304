// lib/modules/financial_literacy/widgets/lesson_card.dart
import 'package:flutter/material.dart';
import '../../../data/models/lesson_model.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;
  final VoidCallback onQuizTap;

  // ignore: use_key_in_widget_constructors
  const LessonCard({
    required this.lesson,
    required this.onTap,
    required this.onQuizTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
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
                  SizedBox(width: 8),
                  _buildDifficultyStars(),
                  Spacer(),
                  _buildDurationChip(),
                ],
              ),
              
              SizedBox(height: 12),
              
              // Title and description
              Text(
                lesson.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              
              SizedBox(height: 8),
              
              Text(
                lesson.description,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              
              SizedBox(height: 8),
              
              // Malaysian example
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber[200]!),
                ),
              ),
              
              SizedBox(height: 12),
              
              // Footer with progress and quiz button
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: lesson.isCompleted ? 1.0 : 0.0,
                      backgroundColor: Colors.grey[200],
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: onQuizTap,
                    icon: Icon(Icons.quiz, size: 16),
                    label: Text('Kuiz'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _getCategoryColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        lesson.localizedCategory,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDifficultyStars() {
    return Row(
      children: List.generate(3, (index) {
        return Icon(
          Icons.star,
          size: 16,
          color: index < lesson.difficulty ? Colors.amber : Colors.grey[300],
        );
      }),
    );
  }

  Widget _buildDurationChip() {
    return Chip(
      label: Text('${lesson.duration.inMinutes} min'),
      backgroundColor: Colors.blue[50],
      labelStyle: TextStyle(fontSize: 12),
    );
  }

  Color _getCategoryColor() {
    switch (lesson.category) {
      case 'Budgeting': return Colors.blue;
      case 'Saving': return Colors.green;
      case 'Investing': return Colors.purple;
      case 'Debt': return Colors.red;
      default: return Colors.orange;
    }
  }
}