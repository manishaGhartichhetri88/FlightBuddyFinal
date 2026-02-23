import 'package:flutter/material.dart';
import 'package:flightbuddy/core/models/flight_model.dart';

class PaymentScreen extends StatefulWidget {
  final Flight flight;
  final List<String> selectedSeats;
  final String travelClass;
  final double totalPrice;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String? passport;
  final String? dob;
  final String? nationality;

  const PaymentScreen({
    super.key,
    required this.flight,
    required this.selectedSeats,
    required this.travelClass,
    required this.totalPrice,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    this.passport,
    this.dob,
    this.nationality,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final Color primary = const Color(0xFF1565C0);
  String _selectedPaymentMethod = 'esewa';
  late TextEditingController _cardNumberController;
  late TextEditingController _cardHolderController;
  late TextEditingController _expiryController;
  late TextEditingController _cvvController;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController();
    _cardHolderController = TextEditingController();
    _expiryController = TextEditingController();
    _cvvController = TextEditingController();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _processPayment() {
    // when using card-based methods, ensure fields are filled
    final cardMethods = ['debit', 'credit', 'visa'];
    if (cardMethods.contains(_selectedPaymentMethod)) {
      if (_cardNumberController.text.isEmpty ||
          _cardHolderController.text.isEmpty ||
          _expiryController.text.isEmpty ||
          _cvvController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all card details')),
        );
        return;
      }
    }

    setState(() {
      _isProcessing = true;
    });

    final paymentMethodLabel = _labelForMethod(_selectedPaymentMethod);
    final Map<String, String> details = {};

    if (cardMethods.contains(_selectedPaymentMethod)) {
      details['Card Number'] = _cardNumberController.text;
      details['Card Holder'] = _cardHolderController.text;
    }

    // Simulate processing delay then go to review page
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushNamed(
        context,
        '/review_payment',
        arguments: {
          'flight': widget.flight,
          'selectedSeats': widget.selectedSeats,
          'travelClass': widget.travelClass,
          'totalPrice': widget.totalPrice,
          'userName': widget.userName,
          'userEmail': widget.userEmail,
          'userPhone': widget.userPhone,
          'passport': widget.passport,
          'dob': widget.dob,
          'nationality': widget.nationality,
          'paymentMethod': paymentMethodLabel,
          'paymentDetails': details,
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price Summary
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Summary',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Passenger:'),
                        Text(widget.userName),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Flight:'),
                        Text('${widget.flight.airlineCode} - ${widget.flight.departureTime}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Seats:'),
                        Text(widget.selectedSeats.join(', ')),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Rs. ${widget.totalPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Payment Method Selection
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // expand available payment methods
            _buildPaymentMethodOption('esewa', 'eSewa', Icons.payment),
            _buildPaymentMethodOption('bank', 'Bank Transfer', Icons.account_balance),
            _buildPaymentMethodOption('debit', 'Debit Card', Icons.credit_card),
            _buildPaymentMethodOption('credit', 'Credit Card', Icons.credit_card),
            _buildPaymentMethodOption('visa', 'Visa', Icons.credit_card),
            _buildPaymentMethodOption('khalti', 'Khalti', Icons.wallet),
            _buildPaymentMethodOption('qr', 'QR Payment', Icons.qr_code),

            const SizedBox(height: 24),

            // Card Details (shown only for card-based payments)
            if (['debit', 'credit', 'visa'].contains(_selectedPaymentMethod)) ...[
              const Text(
                'Card Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  hintText: '1234 5678 9012 3456',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _cardHolderController,
                decoration: InputDecoration(
                  labelText: 'Card Holder Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _expiryController,
                      decoration: InputDecoration(
                        labelText: 'MM/YY',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _cvvController,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],

            // If QR selected show a simple placeholder
            if (_selectedPaymentMethod == 'qr') ...[
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const Icon(Icons.qr_code, size: 120, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text('Scan this QR code with your banking app'),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
            // Process Payment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Pay Rs. ${widget.totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 12),
            Center(
              child: Text(
                'Your payment is secure and encrypted',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption(
    String value,
    String label,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPaymentMethod = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: _selectedPaymentMethod == value ? primary : Colors.grey.shade300,
              width: _selectedPaymentMethod == value ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: _selectedPaymentMethod == value
                ? primary.withOpacity(0.1)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: _selectedPaymentMethod == value ? primary : Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: _selectedPaymentMethod == value
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: _selectedPaymentMethod == value ? primary : Colors.black,
                ),
              ),
              const Spacer(),
              Radio<String>(
                value: value,
                groupValue: _selectedPaymentMethod,
                onChanged: (val) {
                  setState(() {
                    _selectedPaymentMethod = val!;
                  });
                },
                activeColor: primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _labelForMethod(String method) {
    switch (method) {
      case 'esewa':
        return 'eSewa';
      case 'bank':
        return 'Bank Transfer';
      case 'debit':
        return 'Debit Card';
      case 'credit':
        return 'Credit Card';
      case 'visa':
        return 'Visa';
      case 'khalti':
        return 'Khalti';
      case 'qr':
        return 'QR Payment';
      default:
        return method;
    }
  }
}
