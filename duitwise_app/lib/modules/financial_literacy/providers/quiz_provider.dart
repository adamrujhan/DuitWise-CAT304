import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async'; // ADD THIS FOR TIMER
import 'package:duitwise_app/data/models/lesson_model.dart';
import 'package:duitwise_app/data/models/quiz_model.dart';
import 'package:duitwise_app/data/repositories/quiz_repository.dart';

// Provider for QuizRepository
final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository();
});

// State for quiz session
class QuizSessionState {
  final String lessonId;
  final Lesson? lesson;
  final List<QuizQuestion> questions;
  final List<String?> userAnswers;
  final List<int> timeSpentPerQuestion; // seconds spent on each question
  final int currentQuestionIndex;
  final DateTime startedAt;
  final bool isLoading;
  final String? error;
  final bool isCompleted;

  QuizSessionState({
    required this.lessonId,
    this.lesson,
    this.questions = const [],
    this.userAnswers = const [],
    this.timeSpentPerQuestion = const [],
    this.currentQuestionIndex = 0,
    required this.startedAt,
    this.isLoading = false,
    this.error,
    this.isCompleted = false,
  });

  // Get current question
  QuizQuestion? get currentQuestion {
    if (currentQuestionIndex < questions.length) {
      return questions[currentQuestionIndex];
    }
    return null;
  }

  // Calculate total time allotted
  int get totalTimeAllotted {
    return questions.fold(0, (sum, question) => sum + question.timePerQuestion);
  }

  // Calculate time spent so far
  int get totalTimeSpent {
    return timeSpentPerQuestion.fold(0, (sum, time) => sum + time);
  }

  // Calculate remaining time for current question
  int get remainingTimeForCurrentQuestion {
    if (currentQuestion == null) return 0;
    final timeSpent = currentQuestionIndex < timeSpentPerQuestion.length 
        ? timeSpentPerQuestion[currentQuestionIndex] 
        : 0;
    return currentQuestion!.timePerQuestion - timeSpent;
  }

  // Calculate current score
  int get currentScore {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (i < userAnswers.length && userAnswers[i] != null) {
        if (questions[i].isAnswerCorrect(userAnswers[i]!)) {
          score += questions[i].points;
        }
      }
    }
    return score;
  }

  // Get progress percentage
  double get progress {
    if (questions.isEmpty) return 0;
    return (currentQuestionIndex + 1) / questions.length;
  }

  // Check if quiz is finished
  bool get isLastQuestion {
    return currentQuestionIndex >= questions.length - 1;
  }

  // Copy with method for immutability
  QuizSessionState copyWith({
    String? lessonId,
    Lesson? lesson,
    List<QuizQuestion>? questions,
    List<String?>? userAnswers,
    List<int>? timeSpentPerQuestion,
    int? currentQuestionIndex,
    DateTime? startedAt,
    bool? isLoading,
    String? error,
    bool? isCompleted,
  }) {
    return QuizSessionState(
      lessonId: lessonId ?? this.lessonId,
      lesson: lesson ?? this.lesson,
      questions: questions ?? this.questions,
      userAnswers: userAnswers ?? this.userAnswers,
      timeSpentPerQuestion: timeSpentPerQuestion ?? this.timeSpentPerQuestion,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      startedAt: startedAt ?? this.startedAt,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// Quiz Notifier - Riverpod 3.x syntax
class QuizNotifier extends Notifier<QuizSessionState> {
// Store userId
  Timer? _timer; // Timer for countdown
  int _currentQuestionTimeElapsed = 0;
  
  @override
  QuizSessionState build() {
    return QuizSessionState(
      lessonId: '',
      startedAt: DateTime.now(),
    );
  }

  // Initialize with lesson ID (called from outside)
  void initialize(String lessonId, {String? userId}) {
    
    // RESET to initial state
    state = QuizSessionState(
      lessonId: lessonId,
      startedAt: DateTime.now(),
      isLoading: true, // Show loading
    );
    
    _loadQuiz();
  }

  // Start timer for current question
  void _startTimer() {
    _timer?.cancel();
    _currentQuestionTimeElapsed = 0;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentQuestionTimeElapsed++;
      
      // Update time spent for current question
      if (state.currentQuestionIndex < state.timeSpentPerQuestion.length) {
        final newTimeSpent = List<int>.from(state.timeSpentPerQuestion);
        newTimeSpent[state.currentQuestionIndex] = _currentQuestionTimeElapsed;
        state = state.copyWith(timeSpentPerQuestion: newTimeSpent);
      }
      
      // Check if time's up
      final currentQuestion = state.currentQuestion;
      if (currentQuestion != null && 
          _currentQuestionTimeElapsed >= currentQuestion.timePerQuestion) {
        _stopTimer();
        timeOutCurrentQuestion();
      }
    });
  }

  // Stop timer
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // Load quiz questions
  Future<void> _loadQuiz() async {
    if (state.lessonId.isEmpty) return;
    
    try {
      final repository = ref.read(quizRepositoryProvider);
      
      // Fetch lesson info
      final lesson = await repository.getLessonForQuiz(state.lessonId);
      
      // Fetch questions
      final questions = await repository.getQuestionsByLessonId(state.lessonId);
      
      if (questions.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'No questions available for this lesson',
        );
        return;
      }

      // Initialize arrays for answers and time tracking
      final userAnswers = List<String?>.filled(questions.length, null);
      final timeSpentPerQuestion = List<int>.filled(questions.length, 0);

      state = state.copyWith(
        lesson: lesson,
        questions: questions,
        userAnswers: userAnswers,
        timeSpentPerQuestion: timeSpentPerQuestion,
        isLoading: false,
      );
      
      // Start timer for first question
      _startTimer();
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load quiz: $e',
      );
    }
  }

  // Submit answer for current question
  void submitAnswer(String answer) {
    if (state.currentQuestionIndex >= state.questions.length) return;

    final newAnswers = List<String?>.from(state.userAnswers);
    newAnswers[state.currentQuestionIndex] = answer;
    
    state = state.copyWith(userAnswers: newAnswers);
  }

  // Move to next question
  void nextQuestion() {
    _stopTimer();
    
    if (state.isLastQuestion) {
      // Quiz completed
      _completeQuiz();
    } else {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
      );
      _startTimer(); // Start timer for new question
    }
  }

  // Move to previous question (if allowed)
  void previousQuestion() {
    _stopTimer();
    
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex - 1,
      );
      
      // Get time already spent on this question
      if (state.currentQuestionIndex < state.timeSpentPerQuestion.length) {
        _currentQuestionTimeElapsed = state.timeSpentPerQuestion[state.currentQuestionIndex];
      }
      
      _startTimer(); // Restart timer for this question
    }
  }

  // Update time spent on current question
  void updateTimeSpent(int seconds) {
    if (state.currentQuestionIndex >= state.timeSpentPerQuestion.length) return;

    final newTimeSpent = List<int>.from(state.timeSpentPerQuestion);
    newTimeSpent[state.currentQuestionIndex] = seconds;
    
    state = state.copyWith(timeSpentPerQuestion: newTimeSpent);
  }

  // Auto-move when time runs out
  void timeOutCurrentQuestion() {
    submitAnswer(''); // Empty answer for timeout
    if (!state.isLastQuestion) {
      nextQuestion();
    } else {
      _completeQuiz();
    }
  }

  // Complete quiz and calculate results
  void _completeQuiz() {
    _stopTimer();
    state = state.copyWith(isCompleted: true);
  }

  // Reset quiz
  void resetQuiz() {
    _stopTimer();
    state = QuizSessionState(
      lessonId: state.lessonId,
      startedAt: DateTime.now(),
    );
    _loadQuiz();
  }
}

// Provider for quiz session
final quizSessionProvider = NotifierProvider<QuizNotifier, QuizSessionState>(
  () => QuizNotifier(),
);