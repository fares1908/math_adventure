import 'dart:convert';

import 'package:flutter/services.dart';

import '../model/question.dart';

/// تحميل الأسئلة مع إمكانيّة تقييد الأنواع وعدد الأسئلة.
///  - [allowedTypes] مثال: ['addition','subtraction']
///  - [total]        عدد الأسئلة المطلوب إرجاعها بعد الخلط.
Future<List<Question>> loadQuestionsFromAsset({
  List<String>? allowedTypes,
  int total = 10,
}) async {
  // ❶ قراءة ملف الـ JSON
  final String jsonStr =
      await rootBundle.loadString('assets/data/questions_1000.json');
  final List<dynamic> jsonList = json.decode(jsonStr);

  // ❷ تحويله إلى كائنات Question
  final List<Question> all = jsonList.map((e) => Question.fromJson(e)).toList();

  // ❸ فلترة حسب الأنواع المسموح بها (إن وُجدت)
  final List<Question> filtered = allowedTypes == null
      ? all
      : all.where((q) => allowedTypes.contains(q.type)).toList();

  // ❹ خلط القائمة
  filtered.shuffle();

  // ❺ اقتطاع العدد المطلوب
  return filtered.take(total.clamp(0, filtered.length)).toList();
}
