import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:duitwise_app/data/models/lesson_model.dart';
import 'package:duitwise_app/data/models/quiz_model.dart';
import '../providers/quiz_provider.dart';

class QuizPage extends ConsumerStatefulWidget {
  final Lesson lesson;

  const QuizPage({super.key, required this.lesson});

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize quiz after a short delay
    Future.delayed(Duration.zero, () {
      if (!_initialized) {
        _initialized = true;
        _initializeQuiz();
      }
    });
  }

  // After:
  void _initializeQuiz() {
    final notifier = ref.read(quizSessionProvider.notifier);
    final currentState = ref.read(quizSessionProvider);
    
    // Only initialize if this is a different lesson or quiz not loaded
    if (currentState.lessonId != widget.lesson.id || 
        currentState.questions.isEmpty || 
        currentState.isCompleted) {
      notifier.initialize(widget.lesson.id);  // Remove userId parameter
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizSessionProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7),
      appBar: AppBar(
        title: Text(
          "${widget.lesson.title} Quiz",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => _showExitConfirmation(context),
        ),
        actions: [
          if (quizState.questions.isNotEmpty && !quizState.isCompleted)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  "Question ${quizState.currentQuestionIndex + 1}/${quizState.questions.length}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(quizState),
    );
  }

  Widget _buildBody(QuizSessionState state) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading quiz questions...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                state.error!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _initializeQuiz(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.isCompleted) {
      return _buildResults(state);
    }

    if (state.questions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No questions available for this lesson',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return _buildQuizContent(state);
  }

  Widget _buildQuizContent(QuizSessionState state) {
    final currentQuestion = state.currentQuestion;
    if (currentQuestion == null) {
      return const Center(child: Text('No question found'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: state.progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          
          const SizedBox(height: 20),
          
          // Timer and question header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Timer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getTimerColor(state.remainingTimeForCurrentQuestion),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _getTimerBorderColor(state.remainingTimeForCurrentQuestion)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer, size: 16, color: _getTimerIconColor(state.remainingTimeForCurrentQuestion)),
                    const SizedBox(width: 6),
                    Text(
                      "${state.remainingTimeForCurrentQuestion}s",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _getTimerTextColor(state.remainingTimeForCurrentQuestion),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Question card
          RoundedCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Question ${state.currentQuestionIndex + 1}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentQuestion.question,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Options
          Text(
            "Select your answer:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          
          const SizedBox(height: 12),
          
          ..._buildOptions(state, currentQuestion),
          
          const SizedBox(height: 30),
          
          // Navigation buttons
          Row(
            children: [              
              const SizedBox(width: 12),
              
              // Next/Submit button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final notifier = ref.read(quizSessionProvider.notifier);
                    notifier.nextQuestion();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.isLastQuestion ? 'Submit Quiz' : 'Next',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Icon(state.isLastQuestion ? Icons.check : Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper methods for timer colors
  Color _getTimerColor(int remainingTime) {
    if (remainingTime > 30) return Colors.green.shade50;
    if (remainingTime > 10) return Colors.orange.shade50;
    return Colors.red.shade50;
  }

  Color _getTimerBorderColor(int remainingTime) {
    if (remainingTime > 30) return Colors.green.shade200;
    if (remainingTime > 10) return Colors.orange.shade200;
    return Colors.red.shade200;
  }

  Color _getTimerIconColor(int remainingTime) {
    if (remainingTime > 30) return Colors.green;
    if (remainingTime > 10) return Colors.orange;
    return Colors.red;
  }

  Color _getTimerTextColor(int remainingTime) {
    if (remainingTime > 30) return Colors.green;
    if (remainingTime > 10) return Colors.orange;
    return Colors.red;
  }

  List<Widget> _buildOptions(QuizSessionState state, QuizQuestion question) {
    final currentAnswer = state.userAnswers.isNotEmpty && 
                         state.currentQuestionIndex < state.userAnswers.length
        ? state.userAnswers[state.currentQuestionIndex]
        : null;

    return question.options.entries.map((entry) {
      final optionLetter = entry.key;
      final optionText = entry.value;
      final isSelected = currentAnswer == optionLetter;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () {
            ref.read(quizSessionProvider.notifier).submitAnswer(optionLetter);
          },
          child: RoundedCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Selection indicator
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.blue.shade700 : Colors.grey.shade400,
                        width: 2,
                      ),
                      color: isSelected ? Colors.blue.shade700 : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Option letter
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        optionLetter,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.blue.shade800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Option text
                  Expanded(
                    child: Text(
                      optionText,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildResults(QuizSessionState state) {
    final percentage = state.questions.isNotEmpty 
        ? (state.currentScore / state.questions.length) * 100 
        : 0;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Result icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: percentage >= 70 ? Colors.green.shade100 : 
                       percentage >= 50 ? Colors.orange.shade100 : 
                       Colors.red.shade100,
              ),
              child: Icon(
                percentage >= 70 ? Icons.celebration : 
                percentage >= 50 ? Icons.thumb_up : 
                Icons.school,
                size: 60,
                color: percentage >= 70 ? Colors.green : 
                       percentage >= 50 ? Colors.orange : 
                       Colors.red,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Score
            Text(
              "${percentage.round()}%",
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              percentage >= 70 ? "Excellent!" : 
              percentage >= 50 ? "Good Job!" : 
              "Keep Practicing!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: percentage >= 70 ? Colors.green : 
                       percentage >= 50 ? Colors.orange : 
                       Colors.red,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              "You scored ${state.currentScore} out of ${state.questions.length}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Review section
            RoundedCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Quiz Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        _buildStatItem(
                          Icons.timer,
                          "Time Taken",
                          "${state.totalTimeSpent}s",
                        ),
                        const SizedBox(width: 16),
                        _buildStatItem(
                          Icons.quiz,
                          "Questions",
                          "${state.questions.length}",
                        ),
                        const SizedBox(width: 16),
                        _buildStatItem(
                          Icons.star,
                          "Score",
                          "${state.currentScore}",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Action buttons
            Row(
              children: [
                // Retry button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(quizSessionProvider.notifier).resetQuiz();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                    child: const Text(
                      'Retry Quiz',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Finish button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Finish',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 24, color: Colors.blue.shade700),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text('Your progress will be lost. Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit quiz page
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}