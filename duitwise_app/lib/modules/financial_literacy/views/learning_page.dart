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
    
    // Fetch lessons on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!lessonState.isLoading && lessonState.lessons.isEmpty) {
        notifier.fetchLessons();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              
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
                          Text(
                            "Financial Learning",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          if (lessonState.filteredLessons.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

              // Search Bar
              const SizedBox(height: 20),
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Search lessons...",
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

              // Filter Section - MOVED TO TOP
              const SizedBox(height: 12),

              // Category Filter Chips
              _buildCategoryFilterChips(lessonState, notifier),
              
              const SizedBox(height: 12),

              // Difficulty Filter Chips
              _buildDifficultyFilterChips(lessonState, notifier),

              // Active Filters Display - ALWAYS VISIBLE NOW
              const SizedBox(height: 20),
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Active Filters:",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Empty state - show when no filters
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
                      
                      // Selected Categories
                      if (lessonState.selectedCategories.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: lessonState.selectedCategories.map((category) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 71, 178, 160),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromARGB(255, 71, 178, 160),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () => notifier.toggleCategory(category),
                                    child: Icon(
                                      Icons.close,
                                      size: 14,
                                      color: const Color.fromARGB(255, 71, 178, 160),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      
                      // Selected Difficulties
                      if (lessonState.selectedDifficulties.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: lessonState.selectedDifficulties.map((difficulty) {
                              final difficultyText = _getDifficultyText(difficulty);
                              final difficultyColor = _getDifficultyColor(difficulty);
                              
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: difficultyColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getDifficultyIcon(difficulty),
                                      size: 14,
                                      color: difficultyColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      difficultyText,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: difficultyColor,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () => notifier.toggleDifficulty(difficulty),
                                      child: Icon(
                                        Icons.close,
                                        size: 14,
                                        color: difficultyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      
                      // Clear All Filters Button - INSIDE Active Filters box
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
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                      Icon(
                                        Icons.clear_all,
                                        size: 16,
                                        color: Colors.blue.shade700,
                                      ),
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

              // Loading State
              if (lessonState.isLoading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                    ),
                  ),
                ),

              // Error State
              if (lessonState.error != null)
                RoundedCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 48),
                          const SizedBox(height: 10),
                          Text(
                            lessonState.error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => notifier.fetchLessons(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Empty State (no lessons or no results)
              if (!lessonState.isLoading && 
                  lessonState.filteredLessons.isEmpty && 
                  lessonState.error == null)
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
                const SizedBox(height: 20),

                // Lessons Grid/List
                ...lessonState.filteredLessons.map((lesson) {
                  return Column(
                    children: [
                      _buildLessonCard(context, lesson),
                      const SizedBox(height: 15),
                    ],
                  );
                }).toList(),
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
                color: isSelected ? 
                  const Color.fromARGB(255, 71, 178, 160) : 
                  Colors.grey.shade300,
                width: isSelected ? 2.0 : 1.5,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: const Color.fromARGB(255, 71, 178, 160).withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ] : [],
            ),
            child: Text(
              category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? 
                  const Color.fromARGB(255, 71, 178, 160) : 
                  Colors.grey.shade700,
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
        final difficultyText = _getDifficultyText(difficulty);
        final difficultyColor = _getDifficultyColor(difficulty);
        
        return GestureDetector(
          onTap: () => notifier.toggleDifficulty(difficulty),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? difficultyColor : Colors.grey.shade300,
                width: isSelected ? 2.0 : 1.5,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: difficultyColor.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ] : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getDifficultyIcon(difficulty),
                  size: 14,
                  color: isSelected ? difficultyColor : Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Text(
                  difficultyText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? difficultyColor : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Helper methods for difficulty display
  String _getDifficultyText(int difficulty) {
    switch (difficulty) {
      case 1: return 'Beginner';
      case 2: return 'Intermediate';
      case 3: return 'Advanced';
      default: return 'Unknown';
    }
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1: return const Color.fromARGB(255, 78, 183, 47);
      case 2: return Colors.orange;
      case 3: return const Color.fromARGB(255, 163, 69, 180);
      default: return Colors.grey;
    }
  }

  IconData _getDifficultyIcon(int difficulty) {
    switch (difficulty) {
      case 1: return Icons.flag;
      case 2: return Icons.trending_up;
      case 3: return Icons.star;
      default: return Icons.help;
    }
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
                      Icon(
                        lesson.difficultyIcon,
                        size: 14,
                        color: Colors.white,
                      ),
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
            
            // Duration
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.timer,
                    size: 18,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 8),
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
                      "${lesson.durationMinutes} minutes",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
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
                
                const SizedBox(width: 12),
                
                // Quiz Button
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade700, width: 1.5),
                  ),
                  child: IconButton(
                    onPressed: () => QuizNavigationService.showQuizDialog(context, lesson),
                    icon: Icon(
                      Icons.quiz,
                      color: const Color.fromARGB(255, 255, 255, 255),
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
}