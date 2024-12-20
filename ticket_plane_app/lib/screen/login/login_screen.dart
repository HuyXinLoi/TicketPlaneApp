import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6D0EB5), // Màu tím
                  Color(0xFF4059F1), // Màu xanh
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Nội dung chính
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo hoặc tiêu đề
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
                const SizedBox(height: 40),

                // Nút Login Google
                LoginButton(
                  icon: FontAwesomeIcons.google,
                  text: 'Continue with Google',
                  color: Colors.red,
                  onPressed: () {
                    // TODO: Thêm logic đăng nhập Google
                    print("Login with Google");
                  },
                ),
                const SizedBox(height: 15),

                // Nút Login Facebook
                LoginButton(
                  icon: FontAwesomeIcons.facebookF,
                  text: 'Continue with Facebook',
                  color: Colors.blue,
                  onPressed: () {
                    // TODO: Thêm logic đăng nhập Facebook
                    print("Login with Facebook");
                  },
                ),
                const SizedBox(height: 15),

                // Nút Login Apple
                LoginButton(
                  icon: FontAwesomeIcons.apple,
                  text: 'Continue with Apple',
                  color: Colors.black,
                  onPressed: () {
                    // TODO: Thêm logic đăng nhập Apple
                    print("Login with Apple");
                  },
                ),

                const SizedBox(height: 50),

                // Dòng chữ đăng ký
                TextButton(
                  onPressed: () {
                    // TODO: Điều hướng đến màn hình đăng ký
                  },
                  child: const Text(
                    'Don’t have an account? Sign Up',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget nút login
class LoginButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const LoginButton({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        // primary: Colors.white,
        // onPrimary: color,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      icon: Icon(icon, color: color, size: 20),
      label: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
    );
  }
}
