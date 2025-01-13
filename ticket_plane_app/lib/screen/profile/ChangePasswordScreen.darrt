import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_bloc.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_event.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileChangePasswordSuccess) {
          setState(() {
            _isLoading = false;
          });

          _oldPasswordController.clear();
          _newPasswordController.clear();
          _confirmNewPasswordController.clear();
          context.read<ProfileBloc>().add(LogoutButtonPressed());
          context.go('/login');
        } else if (state is ProfileChangePasswordFailure) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is ProfileIncorrectOldPassword) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Mật khẩu cũ không khớp. Vui lòng thử lại."),
              backgroundColor: Colors.orange,
            ),
          );
        } else if (state is ProfileChangePasswordLoading) {
          setState(() {
            _isLoading = true;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đổi mật khẩu'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _oldPasswordController,
                obscureText: _obscureOldPassword,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: 'Mật khẩu cũ',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureOldPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureOldPassword = !_obscureOldPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: 'Mật khẩu mới',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNewPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _confirmNewPasswordController,
                obscureText: _obscureConfirmPassword,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: 'Xác nhận mật khẩu mới',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        final oldPassword = _oldPasswordController.text.trim();
                        final newPassword = _newPasswordController.text.trim();
                        final confirmNewPassword =
                            _confirmNewPasswordController.text.trim();

                        if (oldPassword.isEmpty ||
                            newPassword.isEmpty ||
                            confirmNewPassword.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Vui lòng điền đầy đủ thông tin.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        context.read<ProfileBloc>().add(
                              ChangePasswordPressed(
                                oldPassword: oldPassword,
                                newPassword: newPassword,
                                confirmNewPassword: confirmNewPassword,
                              ),
                            );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('Đổi mật khẩu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
