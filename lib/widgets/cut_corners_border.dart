import 'package:flutter/material.dart';

/// Border kolom teks dengan sudut kanan-atas & kiri-bawah terpotong.
class CutCornersBorder extends OutlineInputBorder {
  const CutCornersBorder({
    super.borderSide = BorderSide.none,
    super.borderRadius = const BorderRadius.all(Radius.circular(2.0)),
    this.cut = 7.0,
    super.gapPadding = 2.0,
  });

  final double cut;

  @override
  CutCornersBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? gapPadding,
    double? cut,
  }) {
    return CutCornersBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      gapPadding: gapPadding ?? this.gapPadding,
      cut: cut ?? this.cut,
    );
  }

  Path _outline(Rect rect) {
    return Path()
      ..moveTo(rect.left + cut, rect.top)
      ..lineTo(rect.right - cut, rect.top)
      ..lineTo(rect.right, rect.top + cut)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left + cut, rect.bottom)
      ..lineTo(rect.left, rect.bottom - cut)
      ..lineTo(rect.left, rect.top + cut)
      ..close();
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final Paint paint = borderSide.toPaint();
    final Path outline = _outline(rect);

    // Tanpa label mengambang: gambar border penuh
    if (gapStart == null || gapExtent <= 0.0 || gapPercentage <= 0.0) {
      canvas.drawPath(outline, paint);
      return;
    }

    // Dengan label mengambang: sisakan celah di garis atas
    final double visibleExtent = gapExtent * gapPercentage;
    final double left = textDirection == TextDirection.rtl
        ? rect.right - gapStart - visibleExtent - gapPadding
        : rect.left + gapStart - gapPadding;
    final double width = visibleExtent + gapPadding * 2;
    final double h = borderSide.width * 2;

    final Path clip = Path.combine(
      PathOperation.difference,
      Path()..addRect(rect.inflate(h)),
      Path()..addRect(Rect.fromLTRB(left, rect.top - h, left + width, rect.top + h)),
    );

    canvas.save();
    canvas.clipPath(clip);
    canvas.drawPath(outline, paint);
    canvas.restore();
  }
}