import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duitwise_app/core/widgets/rounded_card.dart';

import '../../../data/models/lesson_model.dart';
import '../providers/lesson_provider.dart';
import '../services/lesson_navigation_service.dart';
import '../services/quiz_navigation_service.dart';

class LearningPage extends ConsumerStatefulWidget {
  const LearningPage({super.key});

  @override
  ConsumerState<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends ConsumerState<LearningPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    ref.read(lessonProvider.notifier).setSearchQuery(query);
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(lessonProvider.notifier).clearSearchQuery();
  }

  @override
  Widget build(BuildContext context) {
    final lessonState = ref.watch(lessonProvider);
    final notifier = ref.read(lessonProvider.notifier);

    // Realtime lessons stream
    final lessonsAsync = ref.watch(lessonsStreamProvider);

    // When stream updates, push lessons into your LessonNotifier
    // NOTE: your LessonNotifier must have: setLessons(List<Lesson> lessons)
    ref.listen<AsyncValue<List<Lesson>>>(lessonsStreamProvider, (prev, next) {
      next.whenData((lessons) {
        ref.read(lessonProvider.notifier).setLessons(lessons);
      });
    });

    final isLoading = lessonsAsync.isLoading;
    final streamError = lessonsAsync.hasError ? lessonsAsync.error : null;

    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Welcome Card
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Financial Learning",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          if (lessonState.filteredLessons.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${lessonState.filteredLessons.length} ${lessonState.filteredLessons.length == 1 ? 'lesson' : 'lessons'}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Enhance your financial knowledge with interactive modules",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),

              // Search Bar
              const SizedBox(height: 15),
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade600, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Search title lessons...",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          onChanged: (value) => notifier.setSearchQuery(value),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          onPressed: _clearSearch,
                          icon: Icon(
                            Icons.clear,
                            size: 20,
                            color: Colors.grey.shade600,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                ),
              ),

              // Filters
              const SizedBox(height: 12),
              _buildCategoryFilterChips(lessonState, notifier),
              const SizedBox(height: 12),
              _buildDifficultyFilterChips(lessonState, notifier),

              // Active Filters Display
              const SizedBox(height: 15),
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Active Filters:",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (lessonState.selectedCategories.isEmpty &&
                          lessonState.selectedDifficulties.isEmpty &&
                          lessonState.searchQuery.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "No filters applied",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),

                      if (lessonState.selectedCategories.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: lessonState.selectedCategories.map((
                            category,
                          ) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    71,
                                    178,
                                    160,
                                  ),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    category,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 71, 178, 160),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () =>
                                        notifier.toggleCategory(category),
                                    child: const Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Color.fromARGB(255, 71, 178, 160),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                      if (lessonState.selectedDifficulties.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: lessonState.selectedDifficulties.map((difficulty) {
                              // Create temp lesson to use model properties
                              final tempLesson = Lesson(
                                id: '',
                                title: '',
                                description: '',
                                videoUrl: null,
                                category: '',
                                difficulty: difficulty,
                                learningOutcomes: [],
                              );
                              
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: tempLesson.difficultyColor, // USE MODEL'S difficultyColor
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(width: 4),
                                    Text(
                                      tempLesson.difficultyText, // USE MODEL'S difficultyText
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: tempLesson.difficultyColor, // USE MODEL'S difficultyColor
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () =>
                                          notifier.toggleDifficulty(difficulty),
                                      child: Icon(
                                        Icons.close,
                                        size: 14,
                                        color: tempLesson.difficultyColor, // USE MODEL'S difficultyColor
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                      if (lessonState.selectedCategories.isNotEmpty ||
                          lessonState.selectedDifficulties.isNotEmpty ||
                          lessonState.searchQuery.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  notifier.clearFilters();
                                  _clearSearch();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.blue.shade700,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 6),
                                      Text(
                                        "Clear All Filters",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Loading
              if (isLoading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue.shade700,
                      ),
                    ),
                  ),
                ),

              // Error
              if (streamError != null)
                RoundedCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 48),
                          const SizedBox(height: 10),
                          Text(
                            streamError.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Empty State (no lessons or no results)
              if (!isLoading &&
                  streamError == null &&
                  lessonState.filteredLessons.isEmpty)
                RoundedCard(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            lessonState.lessons.isEmpty
                                ? Icons.school
                                : Icons.search_off,
                            size: 64,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            lessonState.lessons.isEmpty
                                ? 'No learning modules available'
                                : 'No matching lessons found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            lessonState.lessons.isEmpty
                                ? 'Check back later for new content'
                                : 'Try different filters or search terms',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (lessonState.lessons.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: ElevatedButton(
                                onPressed: () {
                                  notifier.clearFilters();
                                  _clearSearch();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Clear All Filters'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Lessons List
              if (lessonState.filteredLessons.isNotEmpty) ...[
                ...lessonState.filteredLessons.map((lesson) {
                  return Column(
                    children: [
                      _buildLessonCard(context, lesson),
                      const SizedBox(height: 15),
                    ],
                  );
                }),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilterChips(LessonState state, LessonNotifier notifier) {
    final categories = notifier.getAvailableCategories();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final isSelected = state.selectedCategories.contains(category);

        return GestureDetector(
          onTap: () => notifier.toggleCategory(category),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color.fromARGB(255, 71, 178, 160)
                    : Colors.grey.shade300,
                width: isSelected ? 2.0 : 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          71,
                          178,
                          160,
                        ).withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color.fromARGB(255, 71, 178, 160)
                    : Colors.grey.shade700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDifficultyFilterChips(LessonState state, LessonNotifier notifier) {
  final difficulties = notifier.getAvailableDifficulties();
  
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: difficulties.map((difficulty) {
      final isSelected = state.selectedDifficulties.contains(difficulty);
      
      // Create a temporary lesson to use model properties
      final tempLesson = Lesson(
        id: '',
        title: '',
        description: '',
        videoUrl: null,
        category: '',
        difficulty: difficulty,
        learningOutcomes: [],
      );
      
      return GestureDetector(
        onTap: () => notifier.toggleDifficulty(difficulty),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? tempLesson.difficultyColor : Colors.grey.shade300,
              width: isSelected ? 2.0 : 1.5,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                // ignore: deprecated_member_use
                color: tempLesson.difficultyColor.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ] : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 6),
              Text(
                tempLesson.difficultyText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? tempLesson.difficultyColor : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}


  Widget _buildLessonCard(BuildContext context, Lesson lesson) {
  return RoundedCard(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Category and Difficulty
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Category Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: lesson.categoryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  lesson.localizedCategory,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              // Difficulty Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: lesson.difficultyColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    Text(
                      lesson.difficultyText,
                      style: const TextStyle(
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
          
          const SizedBox(height: 16),
          
          // Lesson Title
          Text(
            lesson.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 8),
          
          // Lesson Description
          Text(
            lesson.description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 20),
          
          // Action Buttons
          Row(
            children: [
              // Learn Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () => LessonNavigationService.showLessonDetail(context, lesson),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Start Lesson',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Quiz Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () => QuizNavigationService.showQuizDialog(context, lesson),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.quiz, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Start Quiz',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}}