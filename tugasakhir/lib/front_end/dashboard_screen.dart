import 'package:flutter/material.dart';
import 'package:tugasakhir/login_folder/register_screen.dart';
import 'package:tugasakhir/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'favorite_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> _animeDataList = [];
  bool _isLoading = false;
  Set<int> _favoriteAnimeIds = Set<int>();

  @override
  void initState() {
    super.initState();
    _loadFavoriteAnimeIds();
  }

  Future<void> _loadFavoriteAnimeIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteIds = prefs.getStringList('favoriteAnimeIds');
    if (favoriteIds != null) {
      setState(() {
        _favoriteAnimeIds = favoriteIds.map((id) => int.parse(id)).toSet();
      });
    }
  }

  Future<void> _toggleFavorite(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_favoriteAnimeIds.contains(id)) {
      setState(() {
        _favoriteAnimeIds.remove(id);
      });
    } else {
      setState(() {
        _favoriteAnimeIds.add(id);
      });
    }
    await prefs.setStringList('favoriteAnimeIds', _favoriteAnimeIds.map((id) => id.toString()).toList());
  }

  Future<void> _fetchAnimeData(int id) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await apiService.fetchAnimeDetails(id);
      setState(() {
        _animeDataList.add(data);
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
            content: Text('Failed to load anime details: $e'),
          );
        },
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => FavoriteScreen(favoriteAnimeIds: _favoriteAnimeIds)));
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter Anime ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                int? id = int.tryParse(_controller.text);
                if (id != null) {
                  _fetchAnimeData(id);
                }
              },
              child: Text('Fetch Anime Details'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _animeDataList.length,
                      itemBuilder: (context, index) {
                        final animeData = _animeDataList[index];
                        final isFavorite = _favoriteAnimeIds.contains(animeData['mal_id']);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  animeData['title'] ?? 'No title',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : null,
                                  ),
                                  onPressed: () => _toggleFavorite(animeData['mal_id']),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            animeData['images'] != null
                                ? Image.network(animeData['images'])
                                : SizedBox(),
                            Divider(), // Add a divider between each anime data
                          ],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
