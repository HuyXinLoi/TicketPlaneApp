import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_bloc.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_event.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_state.dart';

class UpdateProfileScreen extends StatefulWidget {
  final VoidCallback? onUpdate;

  const UpdateProfileScreen({Key? key, this.onUpdate}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _nameController = TextEditingController();
  final _passportController = TextEditingController();
  final _imageController = TextEditingController(); // Controller for image URL
  DateTime _selectedDate = DateTime.now();
  String _selectedGender = '';

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileBloc>().state;
    if (state is ProfileLoaded) {
      _phoneController.text = state.userData['phoneNumber'] ?? '';
      _addressController.text = state.userData['address'] ?? '';
      _nameController.text = state.userData['name'] ?? '';
      _passportController.text = state.userData['passport'] ?? '';
      _selectedDate = (state.userData['dateOfBirth'] as Timestamp).toDate();
      _selectedGender = state.userData['gender'] ?? '';
      _imageController.text = state.userData['urlImage'] ?? ''; // Initialize image URL
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    _nameController.dispose();
    _passportController.dispose();
    _imageController.dispose(); // Dispose image controller
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Giới Tính',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: _selectedGender.isNotEmpty ? _selectedGender : null,
          decoration: const InputDecoration(
            labelText: 'Giới tính',
            prefixIcon: Icon(Icons.people),
          ),
          items: const [
            DropdownMenuItem(value: 'Male', child: Text('Nam')),
            DropdownMenuItem(value: 'Female', child: Text('Nữ')),
            DropdownMenuItem(value: 'Other', child: Text('Khác')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedGender = value!;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng chọn giới tính';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final bloc = context.read<ProfileBloc>();

      // Add UpdateProfile event
      bloc.add(UpdateProfile(
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        dateOfBirth: _selectedDate,
        name: _nameController.text,
        passport: _passportController.text,
        gender: _selectedGender,
        imageUrl: _imageController.text, // Add image URL to UpdateProfile event
      ));

      // Clear cache (optional, if you want to force reload)
      bloc.add(const ClearProfileCache());

      // Emit loading state
      bloc.emit(ProfileLoading());

      // Wait for a short duration to show loading indicator
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ProfileUpdateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          // No need for a listener for ProfileLoaded here anymore
        },
        builder: (context, state) {
          // Only show loading indicator when it's explicitly in loading state
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show form in all other cases
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Họ và tên',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập họ và tên';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Image URL Field
                    TextFormField(
                      controller: _imageController,
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                        prefixIcon: Icon(Icons.image),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an image URL';
                        }
                        // You can add more validation for URL format here
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Passport Field
                    TextFormField(
                      controller: _passportController,
                      decoration: const InputDecoration(
                        labelText: 'Passport',
                        prefixIcon: Icon(Icons.book),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập Passport';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone Number Field
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập số điện thoại';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Address Field
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        prefixIcon: Icon(Icons.home),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập địa chỉ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Date of Birth Field
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          prefixIcon: const Icon(Icons.calendar_today),
                          suffixIcon: const Icon(Icons.arrow_drop_down),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(_selectedDate),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Gender Field
                    _buildGenderField(),
                    const SizedBox(height: 16),

                    // Update Button
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 100),
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Cập nhật thông tin',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}