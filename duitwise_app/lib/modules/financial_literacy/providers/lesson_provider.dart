import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/lesson_repository.dart';
import '../../../data/models/lesson_model.dart';

class LessonState {
  final List<Lesson> lessons;
  final List<Lesson> filteredLessons;
  final bool isLoading;
  final String? error;
  final Lesson? selectedLesson;
  
  // Support multiple selections
  final List<String> selectedCategories;
  final List<int> selectedDifficulties;
  final String searchQuery;

  LessonState({
    this.lessons = const [],
    this.filteredLessons = const [],
    this.isLoading = false,
    this.error,
    this.selectedLesson,
    this.selectedCategories = const [],
    this.selectedDifficulties = const [],
    this.searchQuery = '',
  });

  LessonState copyWith({
    List<Lesson>? lessons,
    List<Lesson>? filteredLessons,
    bool? isLoading,
    String? error,
    Lesson? selectedLesson,
    List<String>? selectedCategories,
    List<int>? selectedDifficulties,
    String? searchQuery,
  }) {
    return LessonState(
      lessons: lessons ?? this.lessons,
      filteredLessons: filteredLessons ?? this.filteredLessons,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedLesson: selectedLesson ?? this.selectedLesson,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedDifficulties: selectedDifficulties ?? this.selectedDifficulties,
      searchQuery: searchQuery ?? this.searchQuery,
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
        filteredLessons: lessons,
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

  // --- Filter and Search Methods ---
  
  // Toggle category selection (multiple)
  void toggleCategory(String category) {
    final currentCategories = List<String>.from(state.selectedCategories);
    
    if (currentCategories.contains(category)) {
      currentCategories.remove(category);
    } else {
      currentCategories.add(category);
    }
    
    state = state.copyWith(selectedCategories: currentCategories);
    _applyFiltersToLessons();
  }

  // Toggle difficulty selection (multiple)
  void toggleDifficulty(int difficulty) {
    final currentDifficulties = List<int>.from(state.selectedDifficulties);
    
    if (currentDifficulties.contains(difficulty)) {
      currentDifficulties.remove(difficulty);
    } else {
      currentDifficulties.add(difficulty);
    }
    
    state = state.copyWith(selectedDifficulties: currentDifficulties);
    _applyFiltersToLessons();
  }

  // Clear all filters
  void clearFilters() {
    state = state.copyWith(
      selectedCategories: [],
      selectedDifficulties: [],
      searchQuery: '',
      filteredLessons: state.lessons,
    );
  }

  // Set search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFiltersToLessons();
  }

  // Clear search query
  void clearSearchQuery() {
    state = state.copyWith(searchQuery: '');
    _applyFiltersToLessons();
  }

  // Get available categories from lessons
  List<String> getAvailableCategories() {
    final categories = state.lessons
        .map((lesson) => lesson.category)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  // Get available difficulties from lessons
  List<int> getAvailableDifficulties() {
    final difficulties = state.lessons
        .map((lesson) => lesson.difficulty)
        .toSet()
        .toList();
    difficulties.sort();
    return difficulties;
  }

  // Private method to apply filters
  void _applyFiltersToLessons() {
    List<Lesson> filtered = state.lessons;

    // Apply category filter (multiple)
    if (state.selectedCategories.isNotEmpty) {
      filtered = filtered
          .where((lesson) => state.selectedCategories.contains(lesson.category))
          .toList();
    }

    // Apply difficulty filter (multiple)
    if (state.selectedDifficulties.isNotEmpty) {
      filtered = filtered
          .where((lesson) => state.selectedDifficulties.contains(lesson.difficulty))
          .toList();
    }

    // Apply search query
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered
          .where((lesson) =>
              lesson.title.toLowerCase().contains(query) ||
              lesson.description.toLowerCase().contains(query) ||
              lesson.category.toLowerCase().contains(query))
          .toList();
    }

    state = state.copyWith(filteredLessons: filtered);
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