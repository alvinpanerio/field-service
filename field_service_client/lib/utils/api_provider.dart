import 'package:dio/dio.dart';

class ApiProvider {
  final Dio dio = Dio();

  Future _get(String url) async {
    try {
      dio.options.extra['withCredentials'] = true;
      final response = await dio.get(
        url,
      );
      print(response);
    } catch (err) {
      return;
    }
  }

  Future _post(String url, [Map<String, dynamic>? data]) async {
    try {
      dio.options.extra['withCredentials'] = true;
      final response = await dio.post(
        url,
        data: data,
      );
      print(response);
    } catch (err) {
      return;
    }
  }

  void login(String email, String password) {
    _post(
      "http://localhost:5000/login",
      {
        'email': email,
        'password': password,
      },
    );
  }

  void getCookies() {
    _get(
      "http://localhost:5000/sessionss",
    );
  }
}
