import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ticket_plane_app/screen/infomationsingup/bloc/infomation_signup_bloc.dart';
import 'package:ticket_plane_app/screen/infomationsingup/data/user_info_repository.dart';

class UserInfoScreen extends StatefulWidget {
  final String userId;
  const UserInfoScreen({super.key, required this.userId});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông Tin Cá Nhân',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
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
        child: BlocListener<UserInfoBloc, UserInfoState>(
          listener: (context, state) {
            if (state.status == UserInfoStatus.success) {
              Flushbar(
                message: 'Đăng Ký Thành Công!',
                margin: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(8),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
                flushbarPosition: FlushbarPosition.TOP,
                icon: const Icon(
                  Icons.error,
                  size: 28,
                  color: Colors.white,
                ),
              ).show(context).then((_) {
                context.go('/nav');
              });
            } else if (state.status == UserInfoStatus.failure) {
              Flushbar(
                message: state.errorMessage,
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
              SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildNameField(),
                      const SizedBox(height: 16),
                      _buildPhoneNumberField(),
                      const SizedBox(height: 16),
                      _buildAddressField(),
                      const SizedBox(height: 16),
                      _buildGenderField(),
                      const SizedBox(height: 16),
                      _buildPassportField(),
                      const SizedBox(height: 16),
                      _buildDateOfBirthField(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: _buildSubmitButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 25.0, bottom: 5.0, top: 8.0),
              child: Text(
                'Tên',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextFormField(
              initialValue: state.name,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                context
                    .read<UserInfoBloc>()
                    .add(UserInfoNameChanged(name: value));
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPhoneNumberField() {
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 25.0, bottom: 5.0, top: 8.0),
              child: Text(
                'Số Điện Thoại',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextFormField(
              initialValue: state.phoneNumber,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                context
                    .read<UserInfoBloc>()
                    .add(UserInfoPhoneNumberChanged(phoneNumber: value));
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddressField() {
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 25.0, bottom: 5.0, top: 8.0),
              child: Text(
                'Địa Chỉ',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextFormField(
              initialValue: state.address,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                context
                    .read<UserInfoBloc>()
                    .add(UserInfoAddressChanged(address: value));
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildGenderField() {
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 25.0, bottom: 5.0, top: 8.0),
              child: Text(
                'Giới Tính',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            DropdownButtonFormField<String>(
              value: state.gender.isNotEmpty ? state.gender : null,
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.people, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(
                    value: 'Male',
                    child: Text('Nam', style: TextStyle(color: Colors.black))),
                DropdownMenuItem(
                    value: 'Female',
                    child: Text('Nữ', style: TextStyle(color: Colors.black))),
                DropdownMenuItem(
                    value: 'Other',
                    child: Text('Khác', style: TextStyle(color: Colors.black))),
              ],
              onChanged: (value) {
                context
                    .read<UserInfoBloc>()
                    .add(UserInfoGenderChanged(gender: value!));
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPassportField() {
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 25.0, bottom: 5.0, top: 8.0),
              child: Text(
                'Hộ Chiếu',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextFormField(
              initialValue: state.passport,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.book, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                context
                    .read<UserInfoBloc>()
                    .add(UserInfoPassportChanged(passport: value));
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateOfBirthField() {
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 25.0, bottom: 5.0, top: 8.0),
              child: Text(
                'Ngày Sinh',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            InkWell(
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: state.dateOfBirth,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  context.read<UserInfoBloc>().add(
                      UserInfoDateOfBirthChanged(dateOfBirth: selectedDate));
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.calendar_today, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd/MM/yyyy').format(state.dateOfBirth),
                        style: const TextStyle(color: Colors.black)),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.status == UserInfoStatus.loading
              ? null
              : () {
                  context.read<UserInfoBloc>().add(UserInfoSubmitted());
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.purple,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: state.status == UserInfoStatus.loading ||
                  state.status == UserInfoStatus.success
              ? const CircularProgressIndicator()
              : const Text(
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
}
