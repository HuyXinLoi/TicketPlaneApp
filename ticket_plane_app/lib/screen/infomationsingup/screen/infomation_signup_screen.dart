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
  @override
  void initState() {
    // TODO: implement initState
    context.read<UserInfoBloc>().add(UserInfoLoading());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserInfoBloc(
        userInfoRepository: UserInfoRepository(),
        userId: widget.userId,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Information',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User information saved successfully!',
                        style: TextStyle(color: Colors.black)),
                    backgroundColor: Colors.greenAccent,
                  ),
                );
                context.go('/nav');
              } else if (state.status == UserInfoStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.errorMessage}',
                        style: const TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //  _buildTitle(),
                      // const SizedBox(height: 32),
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
      ),
    );
  }

  // Widget _buildTitle() {
  Widget _buildNameField() {
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 25.0, bottom: 5.0, top: 8.0),
              child: Text(
                'Name',
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
                // labelText: 'Name',
                // labelStyle: const TextStyle(color: Colors.black),
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
                'Phone Number',
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
                // labelText: 'Phone Number',
                // labelStyle: const TextStyle(color: Colors.black),
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
                'Address',
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
                // labelText: 'Address',
                // labelStyle: const TextStyle(color: Colors.black),
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
                'Gender',
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
                // labelText: 'Gender',
                // labelStyle: const TextStyle(color: Colors.black),
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
                    child: Text('Male', style: TextStyle(color: Colors.black))),
                DropdownMenuItem(
                    value: 'Female',
                    child:
                        Text('Female', style: TextStyle(color: Colors.black))),
                DropdownMenuItem(
                    value: 'Other',
                    child:
                        Text('Other', style: TextStyle(color: Colors.black))),
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
                'Passport',
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
                // labelText: 'Passport',
                // labelStyle: const TextStyle(color: Colors.black),
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
                'Date of Birth',
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
                  // labelText: 'Date of Birth',
                  // labelStyle: const TextStyle(color: Colors.black),
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
          child: state.status == UserInfoStatus.loading
              ? const CircularProgressIndicator()
              : const Text(
                  'Submit',
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
