import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: Text(
          'Pembelajaran Kewangan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.quiz),
            tooltip: 'Ujian Pengetahuan',
            onPressed: () {
              // Navigate to overall quiz
            },
          ),
        ],
      ),
      body: lessons.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Kandungan pembelajaran sedang disediakan',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                return LessonCard(
                  lesson: lessons[index],
                  onTap: () {
                    // Navigate to lesson detail
                    _showLessonDetail(context, lessons[index]);
                  },
                  onQuizTap: () {
                    // Start quiz for this lesson
                    _startQuiz(context, lessons[index]);
                  },
                );
              },
            ),
    );
  }

  void _showLessonDetail(BuildContext context, Lesson lesson) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
              SizedBox(height: 16),
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
              Spacer(),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Start video/lesson
                  },
                  icon: Icon(Icons.play_arrow),
                  label: Text('Mula Belajar (${lesson.duration.inMinutes} min)'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _startQuiz(BuildContext context, Lesson lesson) {
    // Navigate to quiz page
    // We'll implement this later
  }
}