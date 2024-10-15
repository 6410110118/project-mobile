import 'package:flutter/material.dart';

class SuccessPopup extends StatelessWidget {
  final String message;

  const SuccessPopup({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), 
      ),
      title: const Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Color.fromARGB(255, 80, 107, 151),
            size: 32, 
          ),
          SizedBox(width: 10),
          Text(
            'Success',
            style: TextStyle(fontWeight: FontWeight.bold), 
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          const SizedBox(height: 10), 
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.black54), 
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 69, 116, 181), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), 
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
