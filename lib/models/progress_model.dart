import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressModel {
  final String id;
  final String lessonId;
  final double progressPercentage;
  final bool isCompleted;
  final DateTime? lastUpdated;

  ProgressModel({
    required this.id,
    required this.lessonId,
    required this.progressPercentage,
    required this.isCompleted,
    this.lastUpdated,
  });

  factory ProgressModel.fromMap(Map<String, dynamic> map, String id) {
    return ProgressModel(
      id: id,
      lessonId: map['lessonId'] ?? '',
      progressPercentage: (map['progressPercentage'] ?? 0).toDouble(),
      isCompleted: map['isCompleted'] ?? false,
      lastUpdated:
          map['lastUpdated'] != null
              ? (map['lastUpdated'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lessonId': lessonId,
      'progressPercentage': progressPercentage,
      'isCompleted': isCompleted,
      'lastUpdated': lastUpdated,
    };
  }
}

class Timestamp {
  DateTime toDate() {
    return DateTime.now();
  }
}
