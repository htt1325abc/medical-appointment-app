import 'package:flutter/material.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/widgets/mobile_frame.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = <_OnboardingPageData>[
    _OnboardingPageData(
      icon: Icons.medical_services_rounded,
      title: 'Đặt lịch khám dễ dàng',
      description: 'Tiết kiệm thời gian,\nchủ động chăm sóc sức khỏe',
    ),
    _OnboardingPageData(
      icon: Icons.calendar_month_rounded,
      title: 'Đa dạng chuyên khoa',
      description: 'Kết nối với hàng nghìn\nbác sĩ uy tín',
    ),
    _OnboardingPageData(
      icon: Icons.health_and_safety_rounded,
      title: 'Quản lý sức khỏe toàn diện',
      description: 'Lưu trữ lịch sử khám,\nkết quả và đơn thuốc',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page == _pages.length - 1) {
      widget.onFinished();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MobileFrame(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: TextButton(
                    onPressed: widget.onFinished,
                    child: const Text('Bỏ qua'),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (value) => setState(() => _page = value),
                  itemBuilder: (context, index) =>
                      _OnboardingPage(data: _pages[index], index: index),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Row(
                  children: [
                    for (var index = 0; index < _pages.length; index++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: index == _page ? 24 : 7,
                        height: 7,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: index == _page
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                    const Spacer(),
                    Semantics(
                      button: true,
                      label: _page == _pages.length - 1
                          ? 'Bắt đầu sử dụng'
                          : 'Trang tiếp theo',
                      child: InkWell(
                        onTap: _next,
                        customBorder: const CircleBorder(),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data, required this.index});

  final _OnboardingPageData data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            flex: 5,
            child: _CareIllustration(icon: data.icon, variant: index),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 22),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.muted),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

class _CareIllustration extends StatelessWidget {
  const _CareIllustration({required this.icon, required this.variant});

  final IconData icon;
  final int variant;

  @override
  Widget build(BuildContext context) {
    final accent = switch (variant) {
      0 => AppColors.deep,
      1 => const Color(0xFF4C9FEE),
      _ => const Color(0xFF2388E8),
    };
    return Center(
      child: AspectRatio(
        aspectRatio: 1.08,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFEAF8FC),
                shape: BoxShape.circle,
              ),
            ),
            Positioned(
              left: 18,
              top: 36,
              child: _Dot(size: 22, color: AppColors.soft),
            ),
            Positioned(
              right: 22,
              bottom: 34,
              child: _Dot(size: 34, color: const Color(0xFFD7F0FA)),
            ),
            Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(48),
                border: Border.all(color: const Color(0xFFD8F0F8), width: 5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x17006DA5),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Icon(icon, size: 104, color: accent),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
