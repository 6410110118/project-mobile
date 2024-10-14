import 'package:flutter/material.dart';

class SuccessPopup extends StatelessWidget {
  final String message;

  const SuccessPopup({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // ปรับขอบให้โค้งมน
      ),
      title: Row(
        children: const [
          Icon(
            Icons.check_circle,
            color: Color.fromARGB(255, 80, 107, 151),
            size: 32, // ขนาดไอคอนที่หัวข้อ
          ),
          SizedBox(width: 10),
          Text(
            'Success',
            style: TextStyle(fontWeight: FontWeight.bold), // ปรับฟอนต์ให้เป็นตัวหนา
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min, // ทำให้สูงพอดีกับเนื้อหา
        children: [
          const SizedBox(height: 10), // ช่องว่างก่อนข้อความหลัก
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.black54), // ปรับสีและขนาดข้อความ
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 69, 116, 181), // พื้นหลังสีเขียวให้เข้ากับไอคอน
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // ปรับขอบปุ่มให้โค้งมน
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
