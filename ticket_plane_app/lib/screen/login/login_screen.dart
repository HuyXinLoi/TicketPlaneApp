import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ticket_plane_app/screen/login/bloc/login_bloc.dart';
import 'package:ticket_plane_app/screen/login/bloc/login_event.dart';
import 'package:ticket_plane_app/screen/login/bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStates.success) {
            context.go('/nav');
          } else if (state.status == LoginStates.failure) {
            Flushbar(
              message: state.errorMessage ?? 'Login Failed',
              margin: const EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(8),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 3),
              flushbarPosition: FlushbarPosition.TOP, // Hiển thị ở phía trên
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
            // Background gradient
            _buildBackgroundGradient(),
            // Main content
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    // Không cần autovalidate nữa
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo or Title
                        _buildTitle(),
                        const SizedBox(height: 40),
                        // Email and password fields
                        _buildEmailField(),
                        const SizedBox(height: 20),
                        _buildPasswordField(),
                        const SizedBox(height: 30),
                        // Login button
                        _buildLoginButton(),
                        const SizedBox(height: 20),
                        // Divider
                        _buildDivider(),
                        const SizedBox(height: 20),
                        // Social login buttons
                        _buildSocialLoginButtons(context),
                        const SizedBox(height: 30),
                        // Sign up link
                        _buildSignUpLink(),
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
          'Welcome Back!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Log in to continue',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.email,
          onChanged: (value) {
            context.read<LoginBloc>().add(LoginEmailChanged(email: value));
            // Gửi event validate khi giá trị thay đổi
            context
                .read<LoginBloc>()
                .add(LoginEmailValidationChanged(email: value));
          },
          // Không cần validator ở đây nữa
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Username',
            prefixIcon: const Icon(Icons.person, color: Colors.grey),
            // Hiển thị lỗi nếu không hợp lệ
            //errorText: state.isEmailValid ? null : 'Invalid email',
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
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.password,
          obscureText: _obscurePassword,
          onChanged: (value) {
            context
                .read<LoginBloc>()
                .add(LoginPasswordChanged(password: value));
            // Gửi event validate khi giá trị thay đổi
            context
                .read<LoginBloc>()
                .add(LoginPasswordValidationChanged(password: value));
          },
          // Không cần validator ở đây nữa
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Password',
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
            // Hiển thị lỗi nếu không hợp lệ
            //errorText: state.isPasswordValid ? null : 'Invalid password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.status == LoginStates.loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<LoginBloc>().add(LoginSubmitted());
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
                  'Log In',
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
            'OR',
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
            context
                .read<LoginBloc>()
                .add(LoginWithGooglePressed(context: context));
          },
        ),
        const SizedBox(width: 20),
        SocialIconButton(
          icon: FontAwesomeIcons.facebookF,
          color: Colors.blue,
          onPressed: () {
            context
                .read<LoginBloc>()
                .add(LoginWithFacebookPressed(context: context));
          },
        ),
        const SizedBox(width: 20),
        SocialIconButton(
          icon: FontAwesomeIcons.apple,
          color: Colors.black,
          onPressed: () {
            context.read<LoginBloc>().add(LoginWithApplePressed());
          },
        ),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return TextButton(
      onPressed: () {
        context.go('/signup');
      },
      child: RichText(
        text: const TextSpan(
          text: 'Don’t have an account? ',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
          children: [
            TextSpan(
              text: 'Sign Up',
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

// Widget for social icon buttons (No changes needed here)
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
