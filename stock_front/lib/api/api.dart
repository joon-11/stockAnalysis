import 'dart:convert';
import 'package:http/http.dart' as http; // 1단계

class ApiController {
  Future<Map<String, dynamic>> getStock(String name) async {
    String serverUrl = 'http://10.0.2.2:5000/stock?name=$name';

    try {
      // GET 요청
      final response = await http.get(Uri.parse(serverUrl));
      // 응답 처리
      if (response.statusCode == 200) {
        // JSON 데이터 가져오기
        Map<String, dynamic> data = jsonDecode(response.body);
        print(data);
        return data;
      } else {
        return {"서버 응답 오류:": response.statusCode};
      }
    } catch (e) {
      return {"에러:": e};
    }
  }
}
