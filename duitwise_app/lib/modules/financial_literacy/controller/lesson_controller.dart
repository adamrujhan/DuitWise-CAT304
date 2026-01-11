import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duitwise_app/data/models/lesson_model.dart';
import 'package:duitwise_app/data/repositories/lesson_repository.dart';
import 'package:duitwise_app/modules/financial_literacy/providers/lesson_provider.dart';

final lessonControllerProvider = AsyncNotifierProvider<LessonController, void>(
  LessonController.new,
);

class LessonController extends AsyncNotifier<void> {
  late final LessonRepository _repo;

  @override
  Future<void> build() async {
    _repo = ref.read(lessonRepositoryProvider);
  }

  Future<String?> addLesson(Lesson lesson) async {
    state = const AsyncLoading();
    try {
      final id = await _repo.addLesson(lesson);
      if (id == null) {
        state = AsyncError('Failed to add lesson', StackTrace.current);
        return null;
      }
      state = const AsyncData(null);
      return id;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }

  Future<void> deleteLesson(String id) async {
    state = const AsyncLoading();
    try {
      final success = await _repo.deleteLesson(id);
      if (!success) {
        state = AsyncError('Failed to delete lesson', StackTrace.current);
        return;
      }
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
