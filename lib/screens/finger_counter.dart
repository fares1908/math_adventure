import 'package:flutter/material.dart';

class FingerCounterBox extends StatelessWidget {
  final int number;
  final double w; // العرض المطلوب (نستخدمه نفسه مع الـ Abacus)
  final double h; // الارتفاع المطلوب

  const FingerCounterBox({
    super.key,
    required this.number,
    this.w = 260,
    this.h = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      margin: const EdgeInsets.only(right: 4), // مسافة بسيطة من اليمين
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15), // خلفية خفيفة مثل الـ Abacus
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF5D3B0A), width: 3),
      ),
      // لتوسيط المحتوى داخل العلبة
      child: Center(child: FingerCounterCard(number: number)),
    );
  }
}

class FingerCounterCard extends StatelessWidget {
  final int number; // 0 – 999 (مثلاً)

  const FingerCounterCard({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    final units = number % 10;
    final realTens = number ~/ 10; // كل العشرات
    final leftFingers = realTens.clamp(0, 5); // الأصابع الفعليّة
    final overflow = realTens - leftFingers; // عشرات لا يمكن تمثيلها

    Widget framed(String asset, Color border) => Container(
          height: 90,
          width: 100,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border, width: 4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(asset,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.close)),
          ),
        );

    // صورة اليد الشمال مع بادج +عشرات إضافيّة
    Widget leftHand() => Stack(
          alignment: Alignment.topRight,
          children: [
            framed('assets/finger_images/left_$leftFingers.jpg',
                Colors.blueAccent),
            if (overflow > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('+$overflow',
                      style:
                          const TextStyle(fontSize: 10, color: Colors.white)),
                ),
              ),
          ],
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Finger Count: $number',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: leftHand()),
            const SizedBox(width: 12),
            Expanded(
                child: framed('assets/finger_images/right_$units.jpg',
                    Colors.pinkAccent)),
          ],
        ),
        const SizedBox(height: 6),
        Text('Tens: $realTens   Units: $units',
            style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
