import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/app/dashboard_screen.dart';
import 'screens/app/lessons_screen.dart';
import 'screens/app/profile_screen.dart';
import 'screens/app/lesson_detail_screen.dart';
import 'screens/app/chat_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/app/flashcard_screen.dart';
import 'screens/app/quiz_screen.dart';
import 'screens/app/quiz_result_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String lessons = '/lessons';
  static const String profile = '/profile';
  static const String lessonDetail = '/lesson-detail';
  static const String chat = '/chat';
  static const String flashcards = '/flashcards';
  static const String quiz = '/quiz';
  static const String quizResult = '/quiz-result';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case lessons:
        return MaterialPageRoute(builder: (_) => const LessonsScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case lessonDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => LessonDetailScreen(lessonId: args['id']),
        );
      case chat:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(chatId: args['id']),
        );
      case flashcards:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => FlashcardScreen(lessonId: args['lessonId']),
        );
      case quiz:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => QuizScreen(quizId: args['quizId']),
        );
      case quizResult:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder:
              (_) => QuizResultScreen(
                score: args['score'],
                totalQuestions: args['totalQuestions'],
                passed: args['passed'],
                quizId: args['quizId'],
              ),
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
