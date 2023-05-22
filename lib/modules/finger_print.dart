import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try{
      return await _auth.canCheckBiometrics;
    }on PlatformException catch(e){
      print(e.toString());
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      return await _auth.authenticate(
          localizedReason: 'Please authenticate to show account balance',
          options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: true,
          ));
    } on PlatformException catch (e) {
      print(e.toString());
      return false;
    }
  }
}
