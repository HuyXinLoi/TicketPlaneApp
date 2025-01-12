import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_plane_app/screen/infomationsingup/bloc/infomation_signup_bloc.dart';
import 'package:ticket_plane_app/screen/sign_up/bloc/sign_up_bloc.dart';
import 'package:ticket_plane_app/screen/sign_up/bloc/sign_up_event.dart';
import 'package:ticket_plane_app/screen/sign_up/bloc/sign_up_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state.status == SignupStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Đăng ký thành công'),
                duration: const Duration(seconds: 3),
              ),
            );
            if (state.userId != null) {
              context.go('/user-info/${state.userId}',
                  extra: 'Đăng ký thành công');
            }
          } else if (state.status == SignupStatus.failure) {
            Flushbar(
              message: state.errorMessage ?? 'Đăng Nhập Thất Bại',
              margin: const EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(8),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 3),
              flushbarPosition: FlushbarPosition.TOP,
              icon: const Icon(
                Icons.error,
                size: 28,
                color: Colors.white,
              ),
            ).show(context);
          }
        },
        child: Stack(
          children: [
            _buildBackgroundGradient(),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildTitle(),
                        const SizedBox(height: 40),
                        _buildEmailField(),
                        const SizedBox(height: 20),
                        _buildPasswordField(),
                        const SizedBox(height: 20),
                        _buildConfirmPasswordField(),
                        const SizedBox(height: 30),
                        _buildSignUpButton(),
                        const SizedBox(height: 20),
                        _buildDivider(),
                        const SizedBox(height: 20),
                        _buildSocialLoginButtons(context),
                        const SizedBox(height: 30),
                        _buildSignInLink(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 46, 24, 240),
            Color.fromARGB(255, 61, 166, 252),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        const Text(
          'Tạo Tài Khoản',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Đăng Nhập Để Bắt Đầu',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.email,
          onChanged: (value) {
            context.read<SignupBloc>().add(SignupEmailChanged(email: value));
            context
                .read<SignupBloc>()
                .add(SignupEmailValidationChanged(email: value));
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Email',
            prefixIcon: const Icon(Icons.email, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPasswordField() {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.password,
          obscureText: _obscurePassword,
          onChanged: (value) {
            context
                .read<SignupBloc>()
                .add(SignupPasswordChanged(password: value));
            context
                .read<SignupBloc>()
                .add(SignupPasswordValidationChanged(password: value));
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Mật Khẩu',
            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? FontAwesomeIcons.eyeSlash
                    : FontAwesomeIcons.eye,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.confirmPassword,
          obscureText: _obscureConfirmPassword,
          onChanged: (value) {
            context
                .read<SignupBloc>()
                .add(SignupConfirmPasswordChanged(confirmPassword: value));
            context.read<SignupBloc>().add(
                SignupConfirmPasswordValidationChanged(
                    confirmPassword: value, password: state.password));
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Xác Nhận Mật Khẩu',
            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? FontAwesomeIcons.eyeSlash
                    : FontAwesomeIcons.eye,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignUpButton() {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return state.status == SignupStatus.loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<SignupBloc>().add(SignupSubmitted());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.purple,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Đăng Ký',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
      },
    );
  }

  Widget _buildDivider() {
    return Row(
      children: const [
        Expanded(
          child: Divider(
            color: Colors.white54,
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Hoặc',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.white54,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialIconButton(
          icon: FontAwesomeIcons.google,
          color: Colors.red,
          onPressed: () {
            // TODO: Implement sign up with Google
          },
        ),
        const SizedBox(width: 20),
        SocialIconButton(
          icon: FontAwesomeIcons.facebookF,
          color: Colors.blue,
          onPressed: () {
            // TODO: Implement sign up with Facebook
          },
        ),
        const SizedBox(width: 20),
        SocialIconButton(
          icon: FontAwesomeIcons.apple,
          color: Colors.black,
          onPressed: () {
            // TODO: Implement sign up with Apple
          },
        ),
      ],
    );
  }

  Widget _buildSignInLink() {
    return TextButton(
      onPressed: () {
        context.go('/login');
      },
      child: RichText(
        text: const TextSpan(
          text: 'Already have an account? ',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
          children: [
            TextSpan(
              text: 'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const SocialIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}
