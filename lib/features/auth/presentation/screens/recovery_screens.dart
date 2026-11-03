import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/widgets/app_button.dart';
import '../../../../core/design_system/widgets/app_text_field.dart';
import '../../../../core/design_system/widgets/mobile_frame.dart';
import '../widgets/auth_scaffold.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    required this.onBack,
    required this.onCodeSent,
    super.key,
  });

  final VoidCallback onBack;
  final ValueChanged<String> onCodeSent;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onCodeSent(_accountController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Quên mật khẩu',
      onBack: widget.onBack,
      child: AuthContent(
        formKey: _formKey,
        children: [
          const AuthDescription(
            'Nhập email hoặc số điện thoại để nhận mã xác thực',
          ),
          AppTextField(
            controller: _accountController,
            hintText: 'Email hoặc số điện thoại',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Nhập email hoặc số điện thoại'
                : null,
            onFieldSubmitted: (_) => _submit(),
          ),
          AppButton(label: 'Gửi mã xác thực', onPressed: _submit),
        ],
      ),
    );
  }
}

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    required this.destination,
    required this.onBack,
    required this.onVerified,
    super.key,
  });

  final String destination;
  final VoidCallback onBack;
  final VoidCallback onVerified;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  String? _error;

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _verify() {
    final code = _controllers.map((controller) => controller.text).join();
    if (code.length != 6) {
      setState(() => _error = 'Nhập đủ 6 chữ số');
      return;
    }
    widget.onVerified();
  }

  @override
  Widget build(BuildContext context) {
    final destination = widget.destination.isEmpty
        ? 'thông tin bạn đã cung cấp'
        : widget.destination;
    return AuthScaffold(
      title: 'Nhập mã xác thực',
      onBack: widget.onBack,
      bottom: AppButton(label: 'Tiếp tục', onPressed: _verify),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chúng tôi đã gửi mã 6 chữ số đến $destination',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                for (var index = 0; index < 6; index++) ...[
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        autofocus: index == 0,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textInputAction: index == 5
                            ? TextInputAction.done
                            : TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        style: Theme.of(context).textTheme.titleMedium,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          setState(() => _error = null);
                          if (value.isNotEmpty && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          }
                        },
                        onSubmitted: (_) {
                          if (index == 5) {
                            _verify();
                          }
                        },
                      ),
                    ),
                  ),
                  if (index != 5) const SizedBox(width: AppSpacing.xs),
                ],
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                _error!,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.danger),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Center(
              child: TextButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã gửi lại mã xác thực')),
                ),
                child: const Text('Gửi lại mã (00:45)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    required this.onBack,
    required this.onPasswordReset,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onPasswordReset;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onPasswordReset();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Đặt lại mật khẩu',
      onBack: widget.onBack,
      child: AuthContent(
        formKey: _formKey,
        children: [
          AppTextField(
            controller: _passwordController,
            hintText: 'Mật khẩu mới',
            icon: Icons.lock_outline_rounded,
            obscureText: true,
            textInputAction: TextInputAction.next,
            validator: _validatePassword,
          ),
          AppTextField(
            controller: _confirmController,
            hintText: 'Xác nhận mật khẩu mới',
            icon: Icons.lock_outline_rounded,
            obscureText: true,
            textInputAction: TextInputAction.done,
            validator: (value) => value != _passwordController.text
                ? 'Mật khẩu xác nhận chưa khớp'
                : null,
            onFieldSubmitted: (_) => _submit(),
          ),
          AppButton(label: 'Đặt lại mật khẩu', onPressed: _submit),
        ],
      ),
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Nhập mật khẩu mới';
    if (value.length < 8) return 'Mật khẩu cần ít nhất 8 ký tự';
    return null;
  }
}

class SignUpSuccessScreen extends StatelessWidget {
  const SignUpSuccessScreen({required this.onContinue, super.key});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return MobileFrame(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const Spacer(flex: 3),
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.white,
                    size: 52,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Đăng ký thành công!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Chào mừng bạn đến với MediCare+',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: AppColors.muted),
                ),
                const Spacer(flex: 4),
                AppButton(label: 'Bắt đầu sử dụng', onPressed: onContinue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
