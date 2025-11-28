import 'dart:async';
import 'package:diabeat/core/session.dart' as session;
import 'package:diabeat/keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

final _dio = Dio(
  BaseOptions(
    baseUrl: 'https://api.rayliu0712.uk/api',
    connectTimeout: const Duration(seconds: 1),
    sendTimeout: const Duration(seconds: 3),
    receiveTimeout: const Duration(seconds: 3),
    validateStatus: (status) => true,
  ),
);

bool _isLocked = false;

late Completer<void> _refreshCompleter;

Future<(bool, dynamic)> get(
  String path, {
  bool auth = true,
  bool timeout = true,
}) {
  final options = Options(method: 'GET');
  if (!timeout) {
    options.receiveTimeout = null;
  }

  return _handle(path, data: null, options: options, auth: auth);
}

Future<(bool, dynamic)> post(
  String path, {
  Object? data,
  bool auth = true,
  bool timeout = true,
}) {
  final options = Options(method: 'POST');
  if (!timeout) {
    options.receiveTimeout = null;
  }

  return _handle(path, data: data, options: options, auth: auth);
}

Future<(bool, dynamic)> _handle(
  String path, {
  required Object? data,
  required Options options,
  required bool auth,
}) async {
  if (auth) {
    if (_isLocked) {
      // wait for unlock
      await _refreshCompleter.future;
    }
    options.headers = {'Authorization': 'Bearer ${session.access}'};
  }

  try {
    final res = await _dio.request(path, data: data, options: options);

    if (res.is2xx) {
      return (true, res.data);
    }

    if (res.is401) {
      await _lockAndRefresh();
      options.headers!['Authorization'] = 'Bearer ${session.access}';
      final retryRes = await _dio.request(path, data: data, options: options);
      return (retryRes.is2xx, retryRes.data);
    }

    return (false, res.data);
  } on DioException catch (e) {
    showDialog(
      context: globalContext,
      builder: (context) {
        return AlertDialog(title: Text(e.type.name));
      },
    );

    return (false, null);
  }
}

Future<void> _lockAndRefresh() async {
  _isLocked = true;
  _refreshCompleter = Completer();

  try {
    final res = await _dio.post(
      '/token/refresh/',
      data: {'refresh_token': session.refresh},
    );
    final data = res.data;

    await session.logInAndWrite(
      pUsername: data['username'],
      pAccess: data['access'],
      pRefresh: data['refresh'],
    );

    _isLocked = false;
    _refreshCompleter.complete();
  } catch (e) {
    _isLocked = false;
    _refreshCompleter.completeError(e);
    rethrow;
  }
}

extension _ResponseExt on Response {
  bool get is2xx =>
      statusCode != null && 200 <= statusCode! && statusCode! < 300;

  bool get is401 => statusCode == 401;
}
