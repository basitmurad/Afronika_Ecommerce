import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReturnScreen extends StatefulWidget {
  const ReturnScreen({super.key});

  @override
  State<ReturnScreen> createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
  int? _selectedOption;
  final TextEditingController _feedbackController = TextEditingController();

  final List<String> options = [
    "Wrong item received",
    "Item damaged or defective",
    "Item not as described",
    "Changed my mind",
    "Other reason"
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Return Item'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, weight: 5),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select reason for Return",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              // Product card
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: CupertinoColors.systemGrey5,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        image: const DecorationImage(
                          image: AssetImage("assets/40.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Sony WH-CH520 Headphones",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text("\$132.00", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                            "Order #12345687",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Radio options
              Column(
                children: options.asMap().entries.map((entry) {
                  int index = entry.key;
                  String option = entry.value;

                  return Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Colors.grey,
                      radioTheme: RadioThemeData(
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                              (states) => states.contains(MaterialState.selected)
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                    ),
                    child: RadioListTile<int>(
                      value: index,
                      groupValue: _selectedOption,
                      onChanged: (int? value) => setState(() => _selectedOption = value),
                      title: Text(option, style: const TextStyle(fontSize: 14)),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Feedback TextField
              const Text(
                "Additional Details",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _feedbackController,
                maxLines: 5,
                maxLength: 200,
                decoration: InputDecoration(
                  hintText: "Tell us more about your return reason...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.all(12),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide some details';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle submit
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Submit Return Request",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 10,),

            ],
          ),
        ),
      ),
    );
  }
}