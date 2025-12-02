// lib/modules/financial_literacy/models/lesson_model.dart
class Lesson {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final Duration duration;
  final String category; // Budgeting, Saving, Investing, Debt
  final int difficulty; // 1-3
  final List<String> learningOutcomes;
  final bool isCompleted;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.duration,
    required this.category,
    required this.difficulty,
    required this.learningOutcomes,
    this.isCompleted = false,
  });

  // Malaysian context translations
  String get localizedCategory {
    switch (category) {
      case 'Budgeting': return 'Bajet';
      case 'Saving': return 'Simpanan';
      case 'Investing': return 'Pelaburan';
      case 'Debt': return 'Hutang';
      default: return category;
    }
  }

  // For Malaysian Ringgit examples
  String get malaysianExample {
    switch (category) {
      case 'Budgeting': 
        return 'Contoh: Bajet bulanan pelajar RM500-800';
      case 'Saving':
        return 'Contoh: Simpan RM50/bulan dalam ASB';
      case 'Investing':
        return 'Contoh: Pelaburan awal dalam unit trust';
      case 'Debt':
        return 'Contoh: Urus pinjaman PTPTN dengan bijak';
      default: return '';
    }
  }
}