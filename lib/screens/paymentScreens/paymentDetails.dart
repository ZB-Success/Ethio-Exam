import 'package:flutter/material.dart';

class PaymentDetailsScreen extends StatelessWidget {
  final Map<String, String> bank;

  const PaymentDetailsScreen({super.key, required this.bank});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bank["name"]!),
        backgroundColor: Colors.teal,
      ),
      body: Card(
          margin: const EdgeInsets.all(16),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    bank["logo"]!,
                    height: 60,
                  ),
                ),
                const SizedBox(height: 20),
                _buildRow(Icons.account_balance, "Account:", bank["account"]!),
                const SizedBox(height: 10),
                _buildRow(Icons.person, "Receiver:", bank["receiver"]!),
                const SizedBox(height: 10),
                _buildRow(Icons.phone, "Contact:", bank["contact"]!),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.teal),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              children: [
                TextSpan(
                    text: "$label ",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
