import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'paymentDetails.dart';

class BankPaymentScreen extends StatefulWidget {
  const BankPaymentScreen({super.key});

  @override
  State<BankPaymentScreen> createState() => _BankPaymentScreenState();
}

class _BankPaymentScreenState extends State<BankPaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController refController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController amountBirrController = TextEditingController();

  File? proofImage;
  String? selectedBank;

  final List<Map<String, String>> banks = const [
    {
      "name": "Commercial Bank of Ethiopia",
      "logo": "assets/images/CBE.jpeg",
      "account": "10000123456789",
      "receiver": "Mehaz Exam",
      "contact": "0912345678"
    },
    {
      "name": "Telebirr",
      "logo": "assets/images/telebirr.png",
      "account": "0991268877",
      "receiver": "Berihu Gebrewahd",
      "contact": "Telegram: mehaz exam"
    },
    {
      "name": "Wegagen Bank",
      "logo": "assets/images/Wogagen_Bank.png",
      "account": "20000123456789",
      "receiver": "Mehaz Exam",
      "contact": "0933445566"
    },
    {
      "name": "Awash Bank",
      "logo": "assets/images/Awash.png",
      "account": "30000123456789",
      "receiver": "Mehaz Exam",
      "contact": "0922334455"
    },
    {
      "name": "Lion International Bank",
      "logo": "assets/images/Anbessa.png",
      "account": "40000123456789",
      "receiver": "Mehaz Exam",
      "contact": "0955667788"
    },
    {
      "name": "Bank of Abyssinia",
      "logo": "assets/images/Abyssinia.png",
      "account": "50000123456789",
      "receiver": "Mehaz Exam",
      "contact": "0966778899"
    },
  ];

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        proofImage = File(picked.path);
      });
    }
  }

  Future<void> submitPayment() async {
    if (!_formKey.currentState!.validate() || proofImage == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Incomplete Information"),
          content: const Text("Please select a bank, provide proof and reference."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    final uri = Uri.parse("http://192.168.1.4:5000/api/payments/submit");
    var request = http.MultipartRequest("POST", uri);

    request.fields['bank'] = selectedBank!;
    request.fields['name'] = nameController.text;
    request.fields['phone'] = phoneController.text;
    request.fields['reference'] = refController.text;
    request.fields['amount'] = amountBirrController.text;
    request.files.add(await http.MultipartFile.fromPath(
      "screenshot",
      proofImage!.path,
    ));
    final response = await request.send();
    final responseBody = await response.stream.bytesToString(); // get response body as string
    final data = jsonDecode(responseBody); // parse JSON
    if (response.statusCode == 200 || response.statusCode == 201) {
      final message = data['msg'] ?? "Payment submitted successfully";
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Submitted"),
          content:  Text("${message}, give us minutes for approval."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      final errorMessage = data['msg'] ?? "Something went wrong";
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title:    Text("Error"),
          content:  Text("Error: ${errorMessage}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manual Payment")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BANK CARDS ---
            const Text(
              "Choose Bank / Payment Method",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 250, // flexible height for GridView
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: banks.length,
                itemBuilder: (context, index) {
                  final bank = banks[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedBank = bank["name"];
                      });
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PaymentDetailsScreen(bank: bank),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: selectedBank == bank["name"]
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            bank["logo"]!,
                            height: 50,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            bank["name"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            if (selectedBank != null)
              Text(
                "Payment Form for $selectedBank",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

            const SizedBox(height: 20),

            // --- PAYMENT FORM ---
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Full Name"),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Full Name is empty' : null,
                  ),
                  const SizedBox(height: 10),
                TextFormField(
  controller: phoneController,
  keyboardType: TextInputType.phone,
  decoration: const InputDecoration(
    labelText: "Phone Number",
    hintText: "0991268877", // put here inside InputDecoration
  ),
  validator: (value) =>
      value == null || value.isEmpty ? 'Phone Number is empty' : null,
),

                  const SizedBox(height: 10),
                  TextFormField(
                    controller: refController,
                    decoration: const InputDecoration(
                        labelText: "Transaction Reference / Description"),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Transaction Reference is empty'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: amountBirrController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Amount (ETB / Birr)"),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter the fee amount';
                      final amount = double.tryParse(value);
                      if (amount == null || amount < 250) {
                        return 'Amount must be at least 250 ETB';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedBank,
                    decoration: InputDecoration(
                      labelText: "Select Bank",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    items: banks.map((bank) {
                      return DropdownMenuItem(
                        value: bank["name"],
                        child: Text(bank["name"]!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBank = value;
                      });
                    },
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please select a bank' : null,
                  ),
                  const SizedBox(height: 20),
                  if (proofImage != null)
                    Image.file(proofImage!, height: 150, fit: BoxFit.cover),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: pickImage,
                    icon: const Icon(Icons.camera),
                    label: const Text("Upload Screenshot"),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: submitPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 3,
                      ),
                      child: const Text("Submit"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
