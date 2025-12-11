import 'package:flutter/material.dart';
import 'package:duitwise_app/core/widgets/rounded_card.dart';
import '../../financial_literacy/models/lesson_model.dart';
import '../../financial_literacy/widgets/lesson_card.dart';

// ignore: use_key_in_widget_constructors
class LearningPage extends StatelessWidget {
  // Sample lessons data for Malaysian students
  final List<Lesson> lessons = [
    Lesson(
      id: '1',
      title: 'Pengenalan kepada Pengurusan Kewangan Pelajar',
      description: 'Asas pengurusan kewangan untuk pelajar universiti di Malaysia',
      videoUrl: '',
      duration: Duration(minutes: 8),
      category: 'Budgeting',
      difficulty: 1, // 1 = Beginner
      learningOutcomes: [
        'Memahami konsep pendapatan dan perbelanjaan',
        'Mengenal pasti perbelanjaan perlu vs kehendak',
        'Membuat bajet bulanan yang realistik',
      ],
    ),
    Lesson(
      id: '2',
      title: 'Strategi Menjimat Wang sebagai Pelajar',
      description: 'Tips dan teknik praktikal untuk berjimat cermat di kampus',
      videoUrl: '',
      duration: Duration(minutes: 10),
      category: 'Saving',
      difficulty: 2, // 2 = Intermediate
      learningOutcomes: [
        'Teknik penjimatan harian',
        'Menggunakan diskaun pelajar',
        'Mengelakkan pembaziran',
      ],
    ),
    Lesson(
      id: '3',
      title: 'Pinjaman Pendidikan: PTPTN & Lain-lain',
      description: 'Memahami dan mengurus pinjaman pendidikan dengan bijak',
      videoUrl: '',
      duration: Duration(minutes: 12),
      category: 'Debt',
      difficulty: 3, // 3 = Advanced
      learningOutcomes: [
        'Memahami terma PTPTN',
        'Perancangan pembayaran balik',
        'Kesan kredit masa depan',
      ],
    ),
    Lesson(
      id: '4',
      title: 'Pelaburan Awal untuk Pelajar',
      description: 'Memulakan pelaburan dengan modal kecil sebagai pelajar',
      videoUrl: '',
      duration: Duration(minutes: 15),
      category: 'Investing',
      difficulty: 3, // 3 = Advanced
      learningOutcomes: [
        'Jenis pelaburan berisiko rendah',
        'ASB dan pelaburan untuk belia',
        'Strategi dollar-cost averaging',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7), // Mint green background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              
              // Welcome to Learning Card
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

              const SizedBox(height: 20),

              // Category Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: Text("All Categories"),
                      selected: true,
                      onSelected: (bool value) {},
                    ),
                    SizedBox(width: 8),
                    FilterChip(
                      label: Text("Budgeting"),
                      selected: false,
                      onSelected: (bool value) {},
                    ),
                    SizedBox(width: 8),
                    FilterChip(
                      label: Text("Saving"),
                      selected: false,
                      onSelected: (bool value) {},
                    ),
                    SizedBox(width: 8),
                    FilterChip(
                      label: Text("Debt"),
                      selected: false,
                      onSelected: (bool value) {},
                    ),
                    SizedBox(width: 8),
                    FilterChip(
                      label: Text("Investing"),
                      selected: false,
                      onSelected: (bool value) {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // Lessons List
              if (lessons.isEmpty)
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
                            'Kandungan pembelajaran sedang disediakan',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ...lessons.map((lesson) {
                  return Column(
                    children: [
                      _buildLessonCard(lesson, context),
                      SizedBox(height: 15),
                    ],
                  );
                }).toList(),

              const SizedBox(height: 40), // Extra spacing at bottom
            ],
          ),
        ),
      ),
    );
  }

  // Build a lesson card with difficulty badge
  Widget _buildLessonCard(Lesson lesson, BuildContext context) {
    return RoundedCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Category and Difficulty
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Category Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(lesson.category),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    lesson.category,
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
                    color: _getDifficultyColor(lesson.difficulty),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getDifficultyIcon(lesson.difficulty),
                        size: 14,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        _getDifficultyText(lesson.difficulty),
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
            
            // Info Row (Duration and Progress)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Duration and Icon
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
                          "${lesson.duration.inMinutes} minutes",
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
                // Learn Button (Primary)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showLessonDetail(context, lesson),
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
                
                SizedBox(width: 12),
                
                // Quiz Button (Secondary)
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200, width: 1.5),
                  ),
                  child: IconButton(
                    onPressed: () => _startQuiz(context, lesson),
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

  // Helper function to get category color
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'budgeting':
        return Colors.blue;
      case 'saving':
        return Colors.green;
      case 'debt':
        return Colors.red;
      case 'investing':
        return Colors.purple;
      default:
        return Colors.teal;
    }
  }

  // Helper function to get difficulty color
  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1: // Beginner
        return Colors.green;
      case 2: // Intermediate
        return Colors.orange;
      case 3: // Advanced
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Helper function to get difficulty icon
  IconData _getDifficultyIcon(int difficulty) {
    switch (difficulty) {
      case 1: // Beginner
        return Icons.flag;
      case 2: // Intermediate
        return Icons.trending_up;
      case 3: // Advanced
        return Icons.star;
      default:
        return Icons.help;
    }
  }

  // Helper function to get difficulty text
  String _getDifficultyText(int difficulty) {
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

  // Build difficulty badge for legend
  Widget _buildDifficultyBadge(String text, int difficulty, BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: _getDifficultyColor(difficulty),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  void _showLessonDetail(BuildContext context, Lesson lesson) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFA0E5C7), // Match background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lesson.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              // Description
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(lesson.description),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              // Learning Outcomes
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Learning Outcomes:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Column(
                        children: lesson.learningOutcomes
                            .map((outcome) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                                      SizedBox(width: 8),
                                      Expanded(child: Text(outcome)),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              
              Spacer(),
              
              // Start Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Start video/lesson
                    Navigator.pop(context); // Close modal first
                    // TODO: Navigate to lesson player
                  },
                  icon: Icon(Icons.play_arrow),
                  label: Text('Start Learning (${lesson.duration.inMinutes} min)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _startQuiz(BuildContext context, Lesson lesson) {
    // Navigate to quiz page
    // TODO: Implement quiz navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loading quiz for: ${lesson.title}'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}