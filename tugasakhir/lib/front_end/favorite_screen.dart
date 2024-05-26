import 'package:flutter/material.dart';
import 'package:tugasakhir/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugasakhir/login_folder/register_screen.dart';



class FavoriteScreen extends StatefulWidget {
  final Set<int> favoriteAnimeIds;

  FavoriteScreen({required this.favoriteAnimeIds});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> _favoriteAnimeDataList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchFavoriteAnimeDetails();
  }

  Future<void> _fetchFavoriteAnimeDetails() async {
    setState(() {
      _isLoading = true;
    });

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

    try {
      for (int id in widget.favoriteAnimeIds) {
        final data = await apiService.fetchAnimeDetails(id);
        setState(() {
          _favoriteAnimeDataList.add(data);
        });
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Failed to load favorite anime details: $e'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? CircularProgressIndicator()
            : _favoriteAnimeDataList.isEmpty
                ? Center(child: Text('No favorite anime yet'))
                : ListView.builder(
                    itemCount: _favoriteAnimeDataList.length,
                    itemBuilder: (context, index) {
                      final animeData = _favoriteAnimeDataList[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            animeData['title'] ?? 'No title',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          animeData['images'] != null
                              ? Image.network(animeData['images'])
                              : SizedBox(),
                          SizedBox(height: 10),
                          Text(animeData['synopsis'] ?? 'No synopsis'),
                          SizedBox(height: 10),
                          Text('URL: ${animeData['url'] ?? 'No URL'}'),
                          SizedBox(height: 10),
                          Text('Broadcast: ${animeData['broadcast'] ?? 'No broadcast info'}'),
                          Divider(),
                        ],
                      );
                    },
                  ),
      ),
    );
  }
}
