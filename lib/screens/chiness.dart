import 'package:flutter/material.dart';

/// يرسم رقمًا من 0-99 على سوانپان صيني مكون من عمودين (عشرات + آحاد).
class ChineseAbacus extends StatelessWidget {
  final int number; // الرقم المطلوب إظهاره
  final double width; // عرض الإطار
  final double height; // ارتفاع الإطار

  const ChineseAbacus({
    super.key,
    required this.number,
    this.width = 240,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    // نضمن ألا نتجاوز النطاق
    final safe = number.clamp(0, 99);
    return CustomPaint(
      size: Size(width, height),
      painter: _SuanpanPainter(safe),
    );
  }
}

/*────────────────────────  Painter  ────────────────────────*/

class _SuanpanPainter extends CustomPainter {
  final int n; // 0-99
  _SuanpanPainter(this.n);

  /* ألوان مطابقة للسكرين-شوت */
  static const _frame = Color(0xFF5D3A18);
  static const _inside = Color(0xFFD8D0CB);
  static const _beam = Color(0xFF6E4114);

  static const _heaven = Color(0xFFE53935); // أحمر
  static const _earthOn = Color(0xFFE53935); // أحمر (مرفوع)
  static const _earthOff = Color(0xFF1976D2); // أزرق

  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height;
    const rH = 10.0; // نصف قطر السماوية
    const rE = 9.0; // نصف قطر الأرضيّة
    final beamY = h * .48; // موضع العارضة
    const marginX = 18.0;
    final rodX = [marginX, w - marginX]; // عمود العشرات ثم الآحاد

    /* 1) الخلفية + الإطار */
    final rect = RRect.fromLTRBR(0, 0, w, h, const Radius.circular(12));
    c.drawRRect(rect, Paint()..color = _inside);
    c.drawRRect(
        rect,
        Paint()
          ..color = _frame
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3);

    /* 2) العارضة الأفقية */
    c.drawRect(
      Rect.fromCenter(center: Offset(w / 2, beamY), width: w * .9, height: 8),
      Paint()..color = _beam,
    );

    /* 3) تفكيك الرقم */
    final tens = n ~/ 10;
    final units = n % 10;

    _drawRod(c, rodX[0], beamY, h, rH, rE, tens); // العشرات
    _drawRod(c, rodX[1], beamY, h, rH, rE, units); // الآحاد
  }

  void _drawRod(Canvas c, double x, double beamY, double h, double rH,
      double rE, int digit) {
    // سماوية مرفوعة؟
    final heavenUp = digit >= 5;
    final earthUp = heavenUp ? digit - 5 : digit; // 0-4 خرزات مرفوعة

    /* الفاصل (لون فاتح شبه الموجود) */
    c.drawLine(
      Offset(x, 8),
      Offset(x, h - 8),
      Paint()
        ..color = const Color(0xFFDECFB3)
        ..strokeWidth = 3,
    );

    /* السماوية */
    final yHInactive = rH + 10;
    final yHActive = beamY - rH - 4;
    _bead(c, x, heavenUp ? yHActive : yHInactive, rH, _heaven);

    /* الأرضيّة (٤ خرزات) */
    const gap = 6.0;
    final topStart = beamY + rE + 6;
    final bottomStart = h - 10 - rE;

    for (int i = 0; i < 4; i++) {
      final up = i < earthUp;
      final yUp = topStart + i * (2 * rE + gap);
      final yDown = bottomStart - (3 - i) * (2 * rE + gap);
      _bead(c, x, up ? yUp : yDown, rE, up ? _earthOn : _earthOff);
    }
  }

  void _bead(Canvas c, double x, double y, double r, Color clr) {
    final paint = Paint()..color = clr;
    c.drawCircle(Offset(x, y), r, paint);
    c.drawCircle(
        Offset(x, y),
        r,
        Paint()
          ..color = Colors.black54
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
  }

  @override
  bool shouldRepaint(covariant _SuanpanPainter old) => old.n != n;
}
