import 'package:diabeat/network/handler.dart' as handler;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

Future<(bool, dynamic)> logIn({
  required String email,
  required String password,
}) {
  return handler.post(
    '/token/',
    data: {'username_or_email': email, 'password': password},
    auth: false,
  );
}

Future<(bool, dynamic)> register({
  required String email,
  required String username,
  required String password,
}) {
  return handler.post(
    '/register/',
    data: {'email': email, 'username': username, 'password': password},
    auth: false,
  );
}

Future<(bool, dynamic)> postRecord({
  required double glucose,
  double? carbohydrate,
  double? exercise,
  double? insulin,
}) {
  return handler.post(
    '/records/',
    data: {
      'blood_glucose': glucose,
      'carbohydrate_intake': carbohydrate,
      'exercise_duration': exercise,
      'insulin_injection': insulin,
    },
  );
}

Future<(bool, dynamic)> getRecords() {
  return handler.get('/records/');
}

Future<(bool, dynamic)> predictCarbs({required XFile xFile}) async {
  final mime = xFile.mimeType;
  final contentType = mime == null ? null : DioMediaType.parse(mime);

  final formData = FormData.fromMap({
    'image': MultipartFile.fromStream(
      xFile.openRead,
      await xFile.length(),
      filename: xFile.name,
      contentType: contentType,
    ),
  });

  return handler.post('/predict/', data: formData);
}

Future<(bool, dynamic)> predictDiabetes({
  required String gender,
  required int age,
  required double bmi,
  required bool hypertension,
  required bool heartDisease,
  required String smokingHistory,
  required double glucose,
  required double hba1c,
}) {
  return handler.post(
    '/predictform/',
    data: {
      'gender': gender,
      'age': age,
      'bmi': bmi,
      'hypertension': hypertension,
      'heart_disease': heartDisease,
      'smoking_history': smokingHistory,
      'HbA1c_level': hba1c,
      'blood_glucose_level': glucose,
    },
  );
}

Future<(bool, dynamic)> consult() {
  return handler.get('/chat/', timeout: false);
}
