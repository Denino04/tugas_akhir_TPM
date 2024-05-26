import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugasakhir/login_folder/home_screen.dart';
import 'package:tugasakhir/login_folder/register_screen.dart'; // Import the registration screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  const secureStorage = FlutterSecureStorage();
  var encryptionKey = await secureStorage.read(key: 'encryptionKey');
  if (encryptionKey == null) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(key: 'encryptionKey', value: key.join(','));
    encryptionKey = key.join(',');
  }
  final encryptionKeyBytes = encryptionKey.split(',').map((e) => int.parse(e)).toList();

  await Hive.openBox('users', encryptionCipher: HiveAesCipher(encryptionKeyBytes));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('username');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50],
        appBarTheme: AppBarTheme(
          color: Colors.blue,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data == true) {
            return HomeScreen();
          } else {
            return RegisterScreen(); // Display the registration screen
          }
        },
      ),
    );
  }
}
