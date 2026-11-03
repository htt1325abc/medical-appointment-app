import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/widgets/mobile_frame.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.title,
    required this.child,
    this.onBack,
    this.bottom,
    super.key,
  });

  final String title;
  final Widget child;
  final VoidCallback? onBack;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return MobileFrame(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 56,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (onBack != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: onBack,
                          tooltip: 'Quay lại',
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 56),
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: child),
              if (bottom != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: bottom,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthContent extends StatelessWidget {
  const AuthContent({required this.children, this.formKey, super.key});

  final List<Widget> children;
  final GlobalKey<FormState>? formKey;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          children[index],
          if (index != children.length - 1)
            const SizedBox(height: AppSpacing.md),
        ],
      ],
    );

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      child: formKey == null ? content : Form(key: formKey, child: content),
    );
  }
}

class AuthDescription extends StatelessWidget {
  const AuthDescription(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: AppColors.muted),
      ),
    );
  }
}
