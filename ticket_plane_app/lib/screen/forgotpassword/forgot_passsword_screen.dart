import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ticket_plane_app/screen/forgotpassword/bloc/forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quên Mật Khẩu'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/login');
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            Flushbar(
              message: 'Đã Gửi Email Khôi Phục Mật Khẩu. Vui Lòng Kiểm Tra!',
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
            context.go('/login');
          } else if (state is ForgotPasswordFailure) {
            Flushbar(
              message: state.error,
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTitle(),
                        const SizedBox(height: 40),
                        _buildEmailField(),
                        const SizedBox(height: 30),
                        _buildSubmitButton(),
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
    return const Text(
      'Quên Mật Khẩu',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
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
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      builder: (context, state) {
        if (state is ForgotPasswordLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<ForgotPasswordBloc>().add(
                    ForgotPasswordEmailSubmitted(email: _emailController.text),
                  );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.purple,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Gửi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
