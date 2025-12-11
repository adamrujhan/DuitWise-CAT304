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
      difficulty: 1,
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
      difficulty: 1,
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
      difficulty: 2,
      learningOutcomes: [
        'Memahami terma PTPTN',
        'Perancangan pembayaran balik',
        'Kesan kredit masa depan',
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
                      Text(
                        "Welcome to Financial Learning",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
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
                      RoundedCard(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category badge
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(lesson.category),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  lesson.category,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: 12),
                              
                              // Lesson title
                              Text(
                                lesson.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              
                              SizedBox(height: 8),
                              
                              // Lesson description
                              Text(
                                lesson.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              
                              SizedBox(height: 16),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Duration
                                  Row(
                                    children: [
                                      Icon(Icons.timer, size: 16, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Text(
                                        '${lesson.duration.inMinutes} min',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  // Action buttons
                                  Row(
                                    children: [
                                      // Quiz Button
                                      InkWell(
                                        onTap: () => _startQuiz(context, lesson),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.shade100,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.quiz, size: 16, color: Colors.orange),
                                              SizedBox(width: 4),
                                              Text(
                                                'Kuiz',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.orange.shade800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      
                                      SizedBox(width: 8),
                                      
                                      // Learn Button
                                      ElevatedButton(
                                        onPressed: () => _showLessonDetail(context, lesson),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.play_arrow, size: 16, color: Colors.white),
                                            SizedBox(width: 4),
                                            Text(
                                              'Belajar',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                  );
                }).toList(),

              const SizedBox(height: 30), // Extra spacing at bottom
            ],
          ),
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
      default:
        return Colors.purple;
    }
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
          height: MediaQuery.of(context).size.height * 0.8,
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
                        'Keterangan:',
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
                        'Hasil Pembelajaran:',
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
                  label: Text('Mula Belajar (${lesson.duration.inMinutes} min)'),
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
        content: Text('Memuatkan kuiz untuk: ${lesson.title}'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}