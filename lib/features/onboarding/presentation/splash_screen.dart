import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/widgets/app_brand_mark.dart';
import '../../../core/design_system/widgets/mobile_frame.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1400), widget.onFinished);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileFrame(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          fit: StackFit.expand,
          children: [
            const Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 210,
                width: double.infinity,
                child: CustomPaint(painter: _CareWavePainter()),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 4),
                  const AppBrandMark(size: 112),
                  const SizedBox(height: 20),
                  Text(
                    'MediCare+',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.deep,
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sức khỏe hôm nay\nCuộc sống ngày mai',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: AppColors.muted),
                  ),
                  const Spacer(flex: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CareWavePainter extends CustomPainter {
  const _CareWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final back = Paint()..color = const Color(0xFFDDF4FA);
    final middle = Paint()..color = const Color(0xFFC6ECF6);
    final front = Paint()..color = const Color(0xFFA9DFEE);

    canvas.drawPath(
      Path()
        ..moveTo(0, 20)
        ..cubicTo(size.width * .28, -5, size.width * .40, 95, size.width, 56)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close(),
      back,
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, 92)
        ..cubicTo(size.width * .28, 54, size.width * .58, 156, size.width, 102)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close(),
      middle,
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, 134)
        ..cubicTo(size.width * .30, 84, size.width * .58, 190, size.width, 130)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close(),
      front,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
