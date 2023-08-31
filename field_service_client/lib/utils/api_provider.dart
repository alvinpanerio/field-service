import 'package:requests/requests.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiProvider {
  Future get(String res) async {
    final response = await Requests.get(
      "${dotenv.env['API_URL']}" "$res",
      bodyEncoding: RequestBodyEncoding.JSON,
    );

    print(response.json());

    if (response.statusCode == 200) {
      return response.json();
    } else {
      return response.throwForStatus();
    }
  }

  Future post(String res, [Map<String, dynamic>? data]) async {
    final response = await Requests.post(
      "${dotenv.env['API_URL']}" "$res",
      body: data,
      bodyEncoding: RequestBodyEncoding.JSON,
    );

    print(response.json());

    if (response.statusCode == 200) {
      return response.json();
    } else {
      return HTTPException("Unauthorized", response);
    }
  }

  Future getAllTasks() async {
    final rawResponse = await get(
      "/all-tasks",
    );

    final response = rawResponse;

    return response;
  }

  Future getMyTasks() async {
    final rawResponse = await get(
      "/my-tasks",
    );

    final response = rawResponse;

    return response;
  }

  Future getTask(String id) async {
    final rawResponse = await get(
      "/task?id=$id",
    );

    final response = rawResponse;

    return response;
  }

  Future getWorksheet(String id) async {
    final rawResponse = await get(
      "/worksheet?id=$id",
    );

    final response = rawResponse;

    return response;
  }

  Future setWorksheet(
    String id,
    String name,
    List<dynamic> manufacturer,
    List<dynamic> model,
    String serialNo,
    String interventionType,
    String description,
    bool isChecked,
    String date,
    String signature,
    List<dynamic> pictures,
  ) async {
    final rawResponse = await post(
      "/update-worksheet?id=$id",
      {
        'name': name,
        'manufacturer': manufacturer,
        'model': model,
        'serial_no': serialNo,
        'intervention_type': interventionType,
        'description': description,
        'is_checked': isChecked,
        'date': date,
        'signature': signature,
        'pictures': pictures,
      },
    );

    final response = rawResponse;

    return response;
  }

  Future createWorksheet(
    String id,
    String name,
    List<dynamic> manufacturer,
    List<dynamic> model,
    String serialNo,
    String interventionType,
    String description,
    bool? isChecked,
    String date,
    String signature,
    List<dynamic> pictures,
  ) async {
    final rawResponse = await post(
      "/create-worksheet?id=$id",
      {
        'name': name,
        'manufacturer': manufacturer,
        'model': model,
        'serial_no': serialNo,
        'intervention_type': interventionType,
        'description': description,
        'is_checked': isChecked,
        'date': date,
        'signature': signature,
        'pictures': pictures,
      },
    );

    final response = rawResponse;

    return response;
  }

  Future getModels() async {
    final rawResponse = await get(
      "/models",
    );

    final response = rawResponse;

    return response;
  }
}
