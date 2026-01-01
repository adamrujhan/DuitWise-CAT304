// lib/modules/admin/admin_dashboard_page.dart
import 'package:duitwise_app/modules/financial_literacy/providers/lesson_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:duitwise_app/data/models/lesson_model.dart';
import 'package:duitwise_app/data/repositories/lesson_repository.dart';

final adminLessonsProvider = StreamProvider.autoDispose<List<Lesson>>((ref) {
  final repo = ref.watch(lessonRepositoryProvider);
  return repo.watchLessons();
});

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
      await _repo.deleteLesson(id); // <- ensure this exists in repo
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _videoUrlCtrl = TextEditingController();
  final _outcomeCtrl = TextEditingController();

  String _category = 'Budgeting';
  int _difficulty = 1;
  final List<String> _outcomes = [];

  static const _categories = <String>[
    'Budgeting',
    'Saving',
    'Investing',
    'Debt',
  ];

  static const _difficultyItems = <int>[1, 2, 3];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _videoUrlCtrl.dispose();
    _outcomeCtrl.dispose();
    super.dispose();
  }

  void _addOutcome() {
    final text = _outcomeCtrl.text.trim();
    if (text.isEmpty) return;

    if (_outcomes.contains(text)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Outcome already added')));
      return;
    }

    setState(() {
      _outcomes.add(text);
      _outcomeCtrl.clear();
    });
  }

  Future<void> _saveLesson() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (_outcomes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least 1 learning outcome')),
      );
      return;
    }

    final now = DateTime.now();

    // IMPORTANT: id can be empty here; your repository will generate it with push().key
    final lesson = Lesson(
      id: '',
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      videoUrl: _videoUrlCtrl.text.trim().isEmpty
          ? null
          : _videoUrlCtrl.text.trim(),
      category: _category,
      difficulty: _difficulty,
      learningOutcomes: List<String>.from(_outcomes),
      createdAt: now,
      updatedAt: now,
    );

    final controller = ref.read(lessonControllerProvider.notifier);
    final lessonId = await controller.addLesson(lesson);

    if (!mounted) return;

    if (lessonId != null) {
      // reset form
      _formKey.currentState!.reset();
      _titleCtrl.clear();
      _descCtrl.clear();
      _videoUrlCtrl.clear();
      _outcomeCtrl.clear();
      _outcomes.clear();
      setState(() {
        _category = _categories.first;
        _difficulty = 1;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lesson added successfully')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to add lesson')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // listen for controller errors -> snackbar
    ref.listen<AsyncValue<void>>(lessonControllerProvider, (prev, next) {
      next.whenOrNull(
        error: (e, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        },
      );
    });

    final controllerState = ref.watch(lessonControllerProvider);
    final isSaving = controllerState.isLoading;

    final lessonsAsync = ref.watch(adminLessonsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Welcome, Admin",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Lesson',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _titleCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Lesson Title',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Title is required'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _descCtrl,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Description is required'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _videoUrlCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Video URL (optional)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _category,
                                    items: _categories
                                        .map(
                                          (c) => DropdownMenuItem(
                                            value: c,
                                            child: Text(c),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) {
                                      if (v == null) return;
                                      setState(() => _category = v);
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Category',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: DropdownButtonFormField<int>(
                                    initialValue: _difficulty,
                                    items: _difficultyItems
                                        .map(
                                          (d) => DropdownMenuItem(
                                            value: d,
                                            child: Text(
                                              d == 1
                                                  ? 'Beginner'
                                                  : d == 2
                                                  ? 'Intermediate'
                                                  : 'Advanced',
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) {
                                      if (v == null) return;
                                      setState(() => _difficulty = v);
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Difficulty',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _outcomeCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Learning outcome',
                                      border: OutlineInputBorder(),
                                    ),
                                    onSubmitted: (_) => _addOutcome(),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  height: 54,
                                  child: ElevatedButton.icon(
                                    onPressed: _addOutcome,
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add'),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            if (_outcomes.isNotEmpty)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _outcomes
                                      .map(
                                        (o) => Chip(
                                          label: Text(o),
                                          onDeleted: () {
                                            setState(() => _outcomes.remove(o));
                                          },
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),

                            const SizedBox(height: 16),

                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: isSaving ? null : _saveLesson,
                                child: isSaving
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : const Text(
                                        'Save Lesson',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
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

              const SizedBox(height: 15),

              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Existing Lessons',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),

                      lessonsAsync.when(
                        loading: () => const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (e, _) => Text('Error: $e'),
                        data: (lessons) {
                          if (lessons.isEmpty) {
                            return const Text('No lessons yet.');
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: lessons.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 16),
                            itemBuilder: (context, i) {
                              final lesson = lessons[i];

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lesson.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${lesson.category} • ${lesson.difficulty == 1
                                              ? 'Beginner'
                                              : lesson.difficulty == 2
                                              ? 'Intermediate'
                                              : 'Advanced'}',
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Delete',
                                    onPressed: isSaving
                                        ? null
                                        : () => ref
                                              .read(
                                                lessonControllerProvider
                                                    .notifier,
                                              )
                                              .deleteLesson(lesson.id),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
