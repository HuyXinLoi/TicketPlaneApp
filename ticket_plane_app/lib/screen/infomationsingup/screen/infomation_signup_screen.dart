import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ticket_plane_app/screen/infomationsingup/bloc/infomation_signup_bloc.dart';
import 'package:ticket_plane_app/screen/infomationsingup/data/user_info_repository.dart';

class UserInfoScreen extends StatelessWidget {
  final String userId;
  const UserInfoScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserInfoBloc(
        userInfoRepository: UserInfoRepository(),
        userId: userId,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Information'),
        ),
        body: BlocListener<UserInfoBloc, UserInfoState>(
          listener: (context, state) {
            if (state.status == UserInfoStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User information saved successfully!'),
                ),
              );
              context.go('/nav');
            } else if (state.status == UserInfoStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.errorMessage}'),
                ),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 32),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.name,
          decoration: const InputDecoration(labelText: 'Name'),
          onChanged: (value) {
            context.read<UserInfoBloc>().add(UserInfoNameChanged(name: value));
          },
        );
      },
    );
  }

  Widget _buildPhoneNumberField() {
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.phoneNumber,
          decoration: const InputDecoration(labelText: 'Phone Number'),
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            context
                .read<UserInfoBloc>()
                .add(UserInfoPhoneNumberChanged(phoneNumber: value));
          },
        );
      },
    );
  }

  Widget _buildAddressField() {
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.address,
          decoration: const InputDecoration(labelText: 'Address'),
          onChanged: (value) {
            context
                .read<UserInfoBloc>()
                .add(UserInfoAddressChanged(address: value));
          },
        );
      },
    );
  }

  Widget _buildGenderField() {
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        return DropdownButtonFormField<String>(
          value: state.gender.isNotEmpty ? state.gender : null,
          decoration: const InputDecoration(labelText: 'Gender'),
          items: const [
            DropdownMenuItem(value: 'Male', child: Text('Male')),
            DropdownMenuItem(value: 'Female', child: Text('Female')),
            DropdownMenuItem(value: 'Other', child: Text('Other')),
          ],
          onChanged: (value) {
            context
                .read<UserInfoBloc>()
                .add(UserInfoGenderChanged(gender: value!));
          },
        );
      },
    );
  }

  Widget _buildPassportField() {
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.passport,
          decoration: const InputDecoration(labelText: 'Passport'),
          onChanged: (value) {
            context
                .read<UserInfoBloc>()
                .add(UserInfoPassportChanged(passport: value));
          },
        );
      },
    );
  }

  Widget _buildDateOfBirthField() {
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        return InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: state.dateOfBirth,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null) {
              context
                  .read<UserInfoBloc>()
                  .add(UserInfoDateOfBirthChanged(dateOfBirth: selectedDate));
            }
          },
          child: InputDecorator(
            decoration: const InputDecoration(labelText: 'Date of Birth'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('dd/MM/yyyy').format(state.dateOfBirth)),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
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
          child: state.status == UserInfoStatus.loading
              ? const CircularProgressIndicator()
              : const Text('Submit'),
        );
      },
    );
  }
}
