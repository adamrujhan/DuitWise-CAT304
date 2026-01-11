import 'package:duitwise_app/data/models/quiz_model.dart';
import 'package:duitwise_app/data/repositories/quiz_repository.dart';
import 'package:duitwise_app/modules/financial_literacy/providers/quiz_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizController extends AsyncNotifier<void> {
  late final QuizRepository _quizRepository;

  @override
  Future<void> build() async {
    _quizRepository = ref.read(quizRepositoryProvider);
  }

  Future<String?> addQuiz({
    required QuizQuestion quiz,
    required String lessonId,
  }) async {
    state = const AsyncLoading();

    try {
      final quizId = await _quizRepository.addQuiz(quiz, lessonId);
      state = const AsyncData(null);
      return quizId;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}
