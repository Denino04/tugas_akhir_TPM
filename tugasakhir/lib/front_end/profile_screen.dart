import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugasakhir/login_folder/register_screen.dart';


class ProfilePage extends StatelessWidget {
  final String username;

  ProfilePage({required this.username});

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              // Use Image.asset to display an image from assets/images folder
              backgroundImage: AssetImage('assets/images/nino.jpeg'),
            ),
            SizedBox(height: 20),
            Text(
              'Username: $username',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
