class Question {
  final String text;
  final dynamic answer;
  final String? type; // ✅ إضافة النوع

  Question({required this.text, required this.answer, this.type});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: json['text'],
      answer: json['answer'],
      type: json['type'], // ✅ قراءة النوع
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'answer': answer,
        'type': type, // ✅ حفظ النوع لو هتحتاج
      };
}
