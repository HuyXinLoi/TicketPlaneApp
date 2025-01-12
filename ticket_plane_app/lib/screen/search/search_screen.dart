import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ticket_plane_app/screen/search/bloc/search_bloc.dart';
import 'package:ticket_plane_app/screen/search/bloc/search_event.dart';
import 'package:ticket_plane_app/screen/search/bloc/search_state.dart';
import 'package:ticket_plane_app/screen/search/data/flight.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _selectedDiemDi;
  String? _selectedDiemDen;
  DateTime _selectedDate = DateTime.now();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(LoadLocations());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tìm kiếm chuyến bay',
          style: TextStyle(color: Colors.white), // Màu chữ trắng
        ),
        backgroundColor: const Color(0xFF19509e), // Màu nền xanh dương đậm
        // Loại bỏ icon search
      ),
      backgroundColor: const Color(0xFFEEEEEE), // Màu nền nhạt
      body: BlocListener<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state.status == SearchStatus.initial ||
              state.status == SearchStatus.loading) {
            const Center(child: CircularProgressIndicator());
          } else if (state.status == SearchStatus.error) {
            Flushbar(
              message:
                  state.errorMessage ?? 'Không tìm thấy chuyến bay phù hợp.',
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
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<SearchBloc>().add(LoadLocations());
        },
        backgroundColor: const Color(0xFF19509e),
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildDropdownFormField(
                labelText: 'Từ',
                value: _selectedDiemDi,
                items: state.locations,
                onChanged: (value) => setState(() => _selectedDiemDi = value),
              ),
              const SizedBox(height: 16),
              _buildDropdownFormField(
                labelText: 'Đến',
                value: _selectedDiemDen,
                items: state.locations,
                onChanged: (value) => setState(() => _selectedDiemDen = value),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8), // Bo tròn góc
                    border: Border.all(
                        color: Colors.grey.shade400), // Viền xám nhạt
                  ),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Ngày đi',
                      labelStyle: const TextStyle(
                          color: Color(0xFF19509e)), // Màu chữ xanh
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none, // Ẩn border mặc định
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF19509e), // Màu icon xanh dương đậm
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_dateFormat.format(_selectedDate)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_selectedDiemDi != null && _selectedDiemDen != null) {
                    context.read<SearchBloc>().add(SearchFlights(
                          diemDi: _selectedDiemDi!,
                          diemDen: _selectedDiemDen!,
                          ngayDi: _selectedDate,
                        ));
                  } else {
                    Flushbar(
                      message: state.errorMessage ??
                          'Vui lòng chọn điểm đi và điểm đến.',
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
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF19509e), // Màu nút xanh dương đậm
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Bo tròn góc nút
                  ),
                ),
                child: const Text(
                  'Tìm kiếm',
                  style: TextStyle(
                      fontSize: 18, color: Colors.white), // Màu chữ trắng
                ),
              ),
              const SizedBox(height: 20),
              // if (state.flights.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: state.flights.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  itemBuilder: (context, index) {
                    Flight flight = state.flights[index];
                    return Container(
                      color:
                          const Color(0xFFFAFAFA), // Màu nền nhạt cho ListTile
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          '${flight.tenChuyenBay} - ${flight.diemDi} đến ${flight.diemDen}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          'Khởi hành: ${_dateFormat.format(flight.thoiGianDi.toDate())}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey, // Màu xám cho thông tin phụ
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdownFormField({
    required String labelText,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // Bo tròn góc
        border: Border.all(color: Colors.grey.shade400), // Viền xám nhạt
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Color(0xFF19509e)), // Màu chữ xanh
          border: InputBorder.none, // Ẩn border mặc định
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        value: value,
        isExpanded: true,
        items: items
            .map((location) => DropdownMenuItem(
                  value: location,
                  child: Text(location),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
