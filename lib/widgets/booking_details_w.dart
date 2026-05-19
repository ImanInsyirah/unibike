//booking_details_w.dart
// booking_time_widget.dart
import 'package:flutter/material.dart';

class BookingTimeWidget extends StatelessWidget {
  final String selectedDate;
  final String selectedTime;
  final String duration;
  final int durationValue;

  const BookingTimeWidget({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
    required this.duration,
    required this.durationValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCCCCCC)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 20),
              const SizedBox(width: 10),
              Text(
                selectedDate,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time, size: 20),
              const SizedBox(width: 10),
              Text(
                selectedTime,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.timer, size: 20),
              const SizedBox(width: 10),
              Text(
                '$durationValue $duration${durationValue > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PriceDetailWidget extends StatelessWidget {
  final double basePrice;
  final double? discountAmount;

  const PriceDetailWidget({
    Key? key,
    required this.basePrice,
    this.discountAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = basePrice - (discountAmount ?? 0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCCCCCC)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 15),
          _buildPriceRow('Price', basePrice),
          if (discountAmount != null)
            _buildPriceRow('Discount', -discountAmount!),
          const Divider(height: 20, thickness: 1),
          _buildPriceRow('Total', total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'Inter',
            ),
          ),
          Text(
            '\RM${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

// payment_method_widget.dart
// First, modify the PaymentMethodWidget to expose the selected method
class PaymentMethodWidget extends StatefulWidget {
  final Function(String?) onPaymentMethodSelected;

  const PaymentMethodWidget({
    Key? key,
    required this.onPaymentMethodSelected,
  }) : super(key: key);

  @override
  State<PaymentMethodWidget> createState() => _PaymentMethodWidgetState();
}

class _PaymentMethodWidgetState extends State<PaymentMethodWidget> {
  String? selectedMethod;

  final List<Map<String, String>> paymentMethods = [
    {'name': 'Online Banking', 'icon': '🏦'},
    {'name': 'Cash', 'icon': '💵'},
    {'name': 'QR Code', 'icon': ''},
  ];

 void _selectPaymentMethod(String? method) {
    setState(() {
      selectedMethod = method;
    });
    widget.onPaymentMethodSelected(method);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCCCCCC)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 15),
          ...paymentMethods.map((method) => _buildPaymentOption(method)),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(Map<String, String> method) {
    final bool isSelected = selectedMethod == method['name'];
    
    return GestureDetector(
      onTap: () => _selectPaymentMethod(method['name']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFF41E465) : const Color(0xFFCCCCCC),
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? const Color(0xFFE8FFF0) : Colors.white,
        ),
        child: Row(
          children: [
            if (method['icon']!.isNotEmpty) 
              Text(
                method['icon']!,
                style: const TextStyle(fontSize: 20),
              ),
            const SizedBox(width: 10),
            Text(
              method['name']!,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Inter',
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF41E465),
              ),
          ],
        ),
      ),
    );
  }
}