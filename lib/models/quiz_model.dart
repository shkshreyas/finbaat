import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  final String id;
  final String title;
  final String description;
  final String lessonId;
  final List<QuizQuestion> questions;
  final int passingScore;
  final int timeLimit; // in minutes
  final DateTime? createdAt;

  QuizModel({
    required this.id,
    required this.title,
    required this.description,
    required this.lessonId,
    required this.questions,
    required this.passingScore,
    required this.timeLimit,
    this.createdAt,
  });

  factory QuizModel.fromMap(Map<String, dynamic> map, String id) {
    List<QuizQuestion> quizQuestions = [];
    if (map['questions'] != null) {
      quizQuestions = List<QuizQuestion>.from(
        (map['questions'] as List).map(
          (questionMap) => QuizQuestion.fromMap(questionMap),
        ),
      );
    }

    return QuizModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      lessonId: map['lessonId'] ?? '',
      questions: quizQuestions,
      passingScore: map['passingScore'] ?? 70,
      timeLimit: map['timeLimit'] ?? 10,
      createdAt:
          map['createdAt'] != null
              ? (map['createdAt'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'lessonId': lessonId,
      'questions': questions.map((q) => q.toMap()).toList(),
      'passingScore': passingScore,
      'timeLimit': timeLimit,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String? explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    this.explanation,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctOptionIndex: map['correctOptionIndex'] ?? 0,
      explanation: map['explanation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
    };
  }
}

class QuizResult {
  final String id;
  final String quizId;
  final String userId;
  final int score;
  final int totalQuestions;
  final bool passed;
  final DateTime completedAt;

  QuizResult({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.passed,
    required this.completedAt,
  });

  factory QuizResult.fromMap(Map<String, dynamic> map, String id) {
    return QuizResult(
      id: id,
      quizId: map['quizId'] ?? '',
      userId: map['userId'] ?? '',
      score: map['score'] ?? 0,
      totalQuestions: map['totalQuestions'] ?? 0,
      passed: map['passed'] ?? false,
      completedAt:
          map['completedAt'] != null
              ? (map['completedAt'] as Timestamp).toDate()
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quizId': quizId,
      'userId': userId,
      'score': score,
      'totalQuestions': totalQuestions,
      'passed': passed,
      'completedAt': Timestamp.fromDate(completedAt),
    };
  }
}
