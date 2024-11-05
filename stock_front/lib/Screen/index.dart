import 'package:edu_kiosk/Screen/AnalyzeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final TextEditingController _controller = TextEditingController(); // TextEditingController 추가

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주식 분석', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        '주식코드를 입력하세요',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _controller, // TextEditingController 사용
                        decoration: InputDecoration(
                          hintText: '예: 005930',
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // 입력된 주식 코드를 가져옵니다.
                          String stockCode = _controller.text;
                          // AnalyzeScreen으로 주식 코드 전달
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnalyzeScreen(stockCode: stockCode), // 주식 코드를 매개변수로 전달
                            ),
                          );
                        },
                        child: const Text('검색', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
