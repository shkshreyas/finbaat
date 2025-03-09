import 'package:cloud_firestore/cloud_firestore.dart';

class FlashcardModel {
  final String id;
  final String question;
  final String answer;
  final String lessonId;
  final String? imageUrl;
  final int order;
  final DateTime? createdAt;

  FlashcardModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.lessonId,
    this.imageUrl,
    required this.order,
    this.createdAt,
  });

  factory FlashcardModel.fromMap(Map<String, dynamic> map, String id) {
    return FlashcardModel(
      id: id,
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
      lessonId: map['lessonId'] ?? '',
      imageUrl: map['imageUrl'],
      order: map['order'] ?? 0,
      createdAt:
          map['createdAt'] != null
              ? (map['createdAt'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'lessonId': lessonId,
      'imageUrl': imageUrl,
      'order': order,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}
