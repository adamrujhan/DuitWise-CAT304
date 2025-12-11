import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/lesson_repository.dart';
import '../../../data/models/lesson_model.dart';

class LessonState {
  final List<Lesson> lessons;
  final bool isLoading;
  final String? error;
  final Lesson? selectedLesson;

  LessonState({
    this.lessons = const [],
    this.isLoading = false,
    this.error,
    this.selectedLesson,
  });

  LessonState copyWith({
    List<Lesson>? lessons,
    bool? isLoading,
    String? error,
    Lesson? selectedLesson,
  }) {
    return LessonState(
      lessons: lessons ?? this.lessons,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedLesson: selectedLesson ?? this.selectedLesson,
    );
  }
}

class LessonNotifier extends Notifier<LessonState> {
  @override
  LessonState build() {
    return LessonState();
  }

  LessonRepository get _repository => ref.read(lessonRepositoryProvider);

  // Fetch all lessons
  Future<void> fetchLessons() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final lessons = await _repository.getAllLessons();
      state = state.copyWith(
        lessons: lessons,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load lessons: $e',
      );
    }
  }

  // Set selected lesson
  void selectLesson(Lesson lesson) {
    state = state.copyWith(selectedLesson: lesson);
  }

  // Clear selected lesson
  void clearSelectedLesson() {
    state = state.copyWith(selectedLesson: null);
  }

  // Get lessons by category
  List<Lesson> getLessonsByCategory(String category) {
    return state.lessons
        .where((lesson) => lesson.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // Get lessons by difficulty
  List<Lesson> getLessonsByDifficulty(int difficulty) {
    return state.lessons
        .where((lesson) => lesson.difficulty == difficulty)
        .toList();
  }
}

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return LessonRepository();
});

final lessonProvider = NotifierProvider<LessonNotifier, LessonState>(
  () => LessonNotifier(),
);