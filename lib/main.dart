import 'package:flutter/material.dart';
import 'package:frontend/view/login/login_page.dart';
import 'package:frontend/view/screens/dashboard_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();

  // Get the token from SharedPreferences
  String? token = pref.getString('token');

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({Key? key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Server Task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: (token != null && !JwtDecoder.isExpired(token!))
          ? DashboardPage(token: token!)
          : LoginPage(),
    );
  }
}
