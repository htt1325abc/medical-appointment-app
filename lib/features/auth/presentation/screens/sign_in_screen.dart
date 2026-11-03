import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/widgets/app_button.dart';
import '../../../../core/design_system/widgets/app_text_field.dart';
import '../widgets/auth_scaffold.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    required this.onCreateAccount,
    required this.onForgotPassword,
    required this.onSignedIn,
    super.key,
  });

  final VoidCallback onCreateAccount;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignedIn;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSignedIn();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Chào mừng trở lại!',
      child: AuthContent(
        formKey: _formKey,
        children: [
          const AuthDescription('Đăng nhập để tiếp tục'),
          AppTextField(
            controller: _accountController,
            hintText: 'Số điện thoại hoặc email',
            icon: Icons.person_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Nhập số điện thoại hoặc email'
                : null,
          ),
          AppTextField(
            controller: _passwordController,
            hintText: 'Mật khẩu',
            icon: Icons.lock_outline_rounded,
            textInputAction: TextInputAction.done,
            obscureText: _obscurePassword,
            validator: (value) =>
                value == null || value.isEmpty ? 'Nhập mật khẩu' : null,
            onFieldSubmitted: (_) => _submit(),
            suffixIcon: IconButton(
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              tooltip: _obscurePassword ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 18,
                color: AppColors.muted,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onForgotPassword,
              child: const Text('Quên mật khẩu?'),
            ),
          ),
          AppButton(label: 'Đăng nhập', onPressed: _submit),
          Center(
            child: Text(
              'Hoặc đăng nhập với',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.muted),
            ),
          ),
          const _SocialSignInRow(),
          Center(
            child: TextButton(
              onPressed: widget.onCreateAccount,
              child: const Text('Chưa có tài khoản? Đăng ký'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialSignInRow extends StatelessWidget {
  const _SocialSignInRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(
          tooltip: 'Đăng nhập bằng Google',
          icon: Icons.g_mobiledata_rounded,
          color: AppColors.success,
        ),
        SizedBox(width: AppSpacing.xl),
        _SocialButton(
          tooltip: 'Đăng nhập bằng Apple',
          icon: Icons.apple,
          color: AppColors.ink,
        ),
        SizedBox(width: AppSpacing.xl),
        _SocialButton(
          tooltip: 'Đăng nhập bằng Facebook',
          icon: Icons.facebook_rounded,
          color: AppColors.deep,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.tooltip,
    required this.icon,
    required this.color,
  });

  final String tooltip;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      tooltip: tooltip,
      style: IconButton.styleFrom(
        minimumSize: const Size.square(48),
        side: const BorderSide(color: AppColors.border),
        backgroundColor: AppColors.white,
      ),
      icon: Icon(icon, color: color, size: 22),
    );
  }
}
