import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/widgets/app_button.dart';
import '../../../../core/design_system/widgets/app_text_field.dart';
import '../widgets/auth_scaffold.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    required this.onBack,
    required this.onSignIn,
    required this.onRegistered,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onSignIn;
  final VoidCallback onRegistered;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _acceptedTerms = false;
  bool _attemptedSubmit = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _attemptedSubmit = true);
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid || !_acceptedTerms) return;
    widget.onRegistered();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Tạo tài khoản',
      onBack: widget.onBack,
      child: AuthContent(
        formKey: _formKey,
        children: [
          const AuthDescription(
            'Bắt đầu hành trình chăm sóc sức khỏe cùng MediCare+',
          ),
          AppTextField(
            controller: _nameController,
            hintText: 'Họ và tên',
            icon: Icons.person_outline_rounded,
            textInputAction: TextInputAction.next,
            validator: (value) => _required(value, 'Nhập họ và tên'),
          ),
          AppTextField(
            controller: _phoneController,
            hintText: 'Số điện thoại',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: (value) => _required(value, 'Nhập số điện thoại'),
          ),
          AppTextField(
            controller: _emailController,
            hintText: 'Email',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: _validateEmail,
          ),
          AppTextField(
            controller: _passwordController,
            hintText: 'Mật khẩu',
            icon: Icons.lock_outline_rounded,
            obscureText: true,
            textInputAction: TextInputAction.done,
            validator: _validatePassword,
            onFieldSubmitted: (_) => _submit(),
          ),
          InkWell(
            onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _acceptedTerms,
                      onChanged: (value) =>
                          setState(() => _acceptedTerms = value ?? false),
                      activeColor: AppColors.primary,
                      side: BorderSide(
                        color: _attemptedSubmit && !_acceptedTerms
                            ? AppColors.danger
                            : AppColors.muted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tôi đồng ý với Điều khoản sử dụng và Chính sách bảo mật',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _attemptedSubmit && !_acceptedTerms
                            ? AppColors.danger
                            : AppColors.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppButton(label: 'Đăng ký', onPressed: _submit),
          Center(
            child: TextButton(
              onPressed: widget.onSignIn,
              child: const Text('Đã có tài khoản? Đăng nhập'),
            ),
          ),
        ],
      ),
    );
  }

  String? _required(String? value, String message) =>
      value == null || value.trim().isEmpty ? message : null;

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nhập email';
    if (!value.contains('@')) return 'Email chưa đúng định dạng';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Nhập mật khẩu';
    if (value.length < 8) return 'Mật khẩu cần ít nhất 8 ký tự';
    return null;
  }
}
