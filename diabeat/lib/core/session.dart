import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _safe = const FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

String? _username;
String? _access;
String? _refresh;

String get username => _username!;
String get access => _access!;
String get refresh => _refresh!;

Future<bool> initAndRead() async {
  final pUsername = await _safe.read(key: 'username');
  final pAccess = await _safe.read(key: 'access');
  final pRefresh = await _safe.read(key: 'refresh');

  if (pUsername == null || pAccess == null || pRefresh == null) {
    return false;
  }

  _username = pUsername;
  _access = pAccess;
  _refresh = pRefresh;
  return true;
}

Future<void> logInAndWrite({
  required String pUsername,
  required String pAccess,
  required String pRefresh,
}) async {
  _username = pUsername;
  _access = pAccess;
  _refresh = pRefresh;

  await _safe.write(key: 'username', value: pUsername);
  await _safe.write(key: 'access', value: pAccess);
  await _safe.write(key: 'refresh', value: pRefresh);
}

Future<void> logOutAndDelete() {
  _username = null;
  _access = null;
  _refresh = null;

  return _safe.deleteAll();
}
