import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import './widgets/answer_button_widget.dart';
import './widgets/progress_header_widget.dart';
import './widgets/question_card_widget.dart';
import './widgets/result_card_widget.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  bool _showResult = false;

  // K53 Quiz Questions Data
  final List<Map<String, dynamic>> _questions = [
    {
      "question": "What is the speed limit in an urban area in South Africa?",
      "answers": ["60 km/h", "80 km/h", "100 km/h"],
      "correctAnswer": 0,
    },
    {
      "question": "What does a solid white line on the road indicate?",
      "answers": [
        "You may cross it",
        "You may not cross it",
        "It's a parking zone",
      ],
      "correctAnswer": 1,
    },
    {
      "question": "When must you use your vehicle's headlights?",
      "answers": [
        "Only at night",
        "From sunset to sunrise and in poor visibility",
        "Only when it rains",
      ],
      "correctAnswer": 1,
    },
    {
      "question":
          "What is the legal blood alcohol limit for drivers in South Africa?",
      "answers": ["0.05g per 100ml", "0.08g per 100ml", "0.10g per 100ml"],
      "correctAnswer": 0,
    },
    {
      "question": "What should you do when approaching a pedestrian crossing?",
      "answers": [
        "Speed up to pass quickly",
        "Slow down and be prepared to stop",
        "Honk your horn",
      ],
      "correctAnswer": 1,
    },
    {
      "question": "What does a yellow traffic light mean?",
      "answers": [
        "Speed up to pass",
        "Stop if it is safe to do so",
        "Continue at the same speed",
      ],
      "correctAnswer": 1,
    },
    {
      "question": "When are you allowed to overtake on the left?",
      "answers": [
        "Never",
        "When the vehicle in front is turning right",
        "Whenever you want",
      ],
      "correctAnswer": 1,
    },
    {
      "question": "What is the minimum following distance in good conditions?",
      "answers": ["1 second", "2 seconds", "3 seconds"],
      "correctAnswer": 1,
    },
    {
      "question": "What should you do at a four-way stop?",
      "answers": [
        "The first vehicle to arrive goes first",
        "The largest vehicle goes first",
        "Honk and go",
      ],
      "correctAnswer": 0,
    },
    {
      "question": "What does a red octagonal sign indicate?",
      "answers": ["Yield", "Stop", "No entry"],
      "correctAnswer": 1,
    },
  ];

  void _selectAnswer(int index) {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswerIndex = index;
      _isAnswered = true;

      if (index == _questions[_currentQuestionIndex]["correctAnswer"]) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _isAnswered = false;
      });
    } else {
      setState(() {
        _showResult = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _selectedAnswerIndex = null;
      _isAnswered = false;
      _showResult = false;
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home-screen');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'K53 Quiz',
        variant: CustomAppBarVariant.standard,
        onBackPressed: _navigateToHome,
      ),
      body: SafeArea(
        child: _showResult
            ? _buildResultScreen(theme)
            : _buildQuizScreen(theme),
      ),
    );
  }

  Widget _buildQuizScreen(ThemeData theme) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final answers = currentQuestion["answers"] as List<String>;
    final correctAnswer = currentQuestion["correctAnswer"] as int;

    return Column(
      children: [
        ProgressHeaderWidget(
          currentQuestion: _currentQuestionIndex + 1,
          totalQuestions: _questions.length,
          score: _score,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                QuestionCardWidget(
                  questionNumber: _currentQuestionIndex + 1,
                  questionText: currentQuestion["question"] as String,
                ),
                SizedBox(height: 3.h),
                ...List.generate(
                  answers.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: AnswerButtonWidget(
                      answerText: answers[index],
                      isSelected: _selectedAnswerIndex == index,
                      isCorrect: index == correctAnswer,
                      isAnswered: _isAnswered,
                      onTap: () => _selectAnswer(index),
                    ),
                  ),
                ),
                if (_isAnswered) ...[
                  SizedBox(height: 3.h),
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _currentQuestionIndex < _questions.length - 1
                          ? 'Next Question'
                          : 'View Results',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultScreen(ThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ResultCardWidget(score: _score, totalQuestions: _questions.length),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: _restartQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onSecondary,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Restart Quiz',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          OutlinedButton(
            onPressed: _navigateToHome,
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              side: BorderSide(color: theme.colorScheme.primary, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Back to Home',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
