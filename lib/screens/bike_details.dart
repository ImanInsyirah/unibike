//bike_details.dart
import 'package:flutter/material.dart';
import 'booking_detail_page.dart';
import 'package:intl/intl.dart';

class BikeDetails extends StatefulWidget {
  final String selectedDuration;
  final String bikeName;
  final String bikeImageUrl;

  const BikeDetails({
    Key? key, 
  required this.selectedDuration,
  required this.bikeName,
  required this.bikeImageUrl,
  }) : super(key: key);

  @override
  State<BikeDetails> createState() => _BikeDetailsState();
}

class _BikeDetailsState extends State<BikeDetails> {
  int? selectedValue;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  //base pricing constants
  final double hourlyRate = 3.0;
  final double dailyRate = 5.0;
  final double weeklyRate = 10.0;

  // Calculate base price based on duration
  double _calculateBasePrice() {
    if (selectedValue == null) return 0.0;
    
    switch (widget.selectedDuration) {
      case 'By Hour':
        return hourlyRate * selectedValue!;
      case 'By Day':
        return dailyRate * selectedValue!;
      case 'By Week':
        return weeklyRate * selectedValue!;
      default:
        return 0.0;
    }
  }

  void _handleDropdownChange(int? value) {
    setState(() {
      selectedValue = value;
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // Get duration type for passing to next screen
  String _getDurationType() {
    switch (widget.selectedDuration) {
      case 'By Hour':
        return 'hour';
      case 'By Day':
        return 'day';
      case 'By Week':
        return 'week';
      default:
        return '';
    }
  }

  void _handleNext() {
    if (selectedValue == null || selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select duration, date, and time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
      // Format date and time for next screen
    String formattedDate = DateFormat('MMM dd, yyyy').format(selectedDate!);
    String formattedTime = selectedTime!.format(context);
    String bookingId = 'B${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingDetailScreen(
          selectedDate: formattedDate,
          selectedTime: formattedTime,
          duration: _getDurationType(),
          durationValue: selectedValue!,
          basePrice: _calculateBasePrice(),
          bikeId: widget.bikeName,  
          bookingId: bookingId,
          bikeImageUrl: widget.bikeImageUrl, 
        ),
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Date & Time',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate != null
                              ? DateFormat('MMM dd, yyyy').format(selectedDate!)
                              : 'Select Date',
                          style: TextStyle(
                            color: selectedDate != null
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                        ),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: _selectTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedTime != null
                              ? selectedTime!.format(context)
                              : 'Select Time',
                          style: TextStyle(
                            color: selectedTime != null
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                        ),
                        const Icon(Icons.access_time, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(int start, int end, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose $unit:',
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<int>(
              value: selectedValue,
              isExpanded: true,
              underline: Container(),
              items: List.generate(
                end - start + 1,
                (index) => DropdownMenuItem<int>(
                  value: start + index,
                  child: Text('${start + index} $unit${(start + index) > 1 ? 's' : ''}'),
                ),
              ),
              onChanged: _handleDropdownChange,
              hint: Text('Select number of $unit${end > 1 ? 's' : ''}'),
            ),
          ),
        ],
      ),
    );
  }


  Widget _getDurationDropdown() {
    switch (widget.selectedDuration) {
      case 'By Hour':
        return _buildDropdown(1, 4, 'hour');
      case 'By Day':
        return _buildDropdown(1, 6, 'day');
      case 'By Week':
        return _buildDropdown(1, 3, 'week');
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          constraints: const BoxConstraints(maxWidth: 480),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 27, 0, 119),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 30,
                    color: Colors.black,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 16),
                  Image.network(
                    widget.bikeImageUrl,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, StackTrace){
                      return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.bike_scooter, size: 40),
                    );
                    },
                  ),
                  Padding(
                  padding: const EdgeInsets.only(left: 34, top: 33),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.bikeName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                        ),
                        SizedBox(height: 33),
                        Text(
                          'BOOKING TIME',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _getDurationDropdown(),
                  const SizedBox(height: 24),
                  _buildDateTimePicker(),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 31),
                    child: GestureDetector(
                      onTap: _handleNext,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF41E465),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}