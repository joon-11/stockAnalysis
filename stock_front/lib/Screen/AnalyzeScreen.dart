import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';
import 'StockDetailScreen.dart'; // Import the DetailScreen

class AnalyzeScreen extends StatefulWidget {
  final String stockCode; // 주식 코드 필드 추가

  const AnalyzeScreen({Key? key, required this.stockCode}) : super(key: key); // 생성자 수정

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  final List<String> files = [
    '연구원 보고서',
    '기술분석가 보고서',
    '금융분석가 보고서',
    '종합의견',
  ];

  bool isLoading = true; // Loading 상태 변수 추가
  late String research_Task;
  late String technical_analysis_Task;
  late String financial_analysis_Task;
  late String investment_recommendation;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final fetchedData = await ApiController().getStock(widget.stockCode);
    research_Task = fetchedData["tasks_output"][0]["raw"];
    technical_analysis_Task = fetchedData["tasks_output"][1]["raw"];
    financial_analysis_Task = fetchedData["tasks_output"][2]["raw"];
    investment_recommendation = fetchedData["tasks_output"][3]["raw"];

    setState(() {
      isLoading = false; // Set loading to false after data is fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주식 분석 보고서', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading // Check if loading
            ? Center(
          child: CircularProgressIndicator(), // Show loading indicator
        )
            : ListView.separated(
          itemCount: files.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                leading: const Icon(
                  Icons.description,
                  color: Colors.blueAccent,
                  size: 30,
                ),
                title: Text(
                  files[index],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to the detail screen and pass the relevant data
                  String content;
                  switch (index) {
                    case 0:
                      content = research_Task;
                      break;
                    case 1:
                      content = technical_analysis_Task;
                      break;
                    case 2:
                      content = financial_analysis_Task;
                      break;
                    case 3:
                      content = investment_recommendation;
                      break;
                    default:
                      content = '';
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        title: files[index],
                        content: content,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
