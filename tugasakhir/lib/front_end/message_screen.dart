import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugasakhir/login_folder/register_screen.dart';


class MessageScreen extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Saran: Menurut saya, akan lebih baik jika jadwal perkuliahan lebih padat dan terstruktur. Mengisi kekosongan dan libur yang ada dengan lebih banyak materi atau proyek praktis akan membantu memaksimalkan waktu pembelajaran.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Saran: Saya merekomendasikan agar deadline tugas ditetapkan pada tengah malam daripada pagi hari. Ini akan memberikan fleksibilitas bagi mahasiswa untuk mengatur waktu mereka dengan lebih baik, terutama bagi mereka yang memiliki jadwal yang padat di siang hari.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Kesan: Saya menyukai materi yang diajarkan dalam mata kuliah ini. Hal ini membuat saya tertarik dan termotivasi untuk belajar lebih banyak tentang teknologi dan pemrograman mobile.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Kesan: Meskipun ada beberapa kekosongan dan libur, saya tetap merasa puas dengan pengalaman pembelajaran saya. Namun, saya percaya bahwa peningkatan pada pengaturan jadwal dan penyeimbangan antara teori dan praktik akan membuat mata kuliah ini menjadi lebih efektif.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Dengan mengimplementasikan saran-saran tersebut, saya yakin pengalaman pembelajaran dalam mata kuliah Teknologi dan Pemrograman Mobile dapat menjadi lebih optimal dan bermanfaat bagi semua mahasiswa. Terima kasih atas perhatiannya.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
