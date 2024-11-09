import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_player/core/api_service.dart';
import 'package:music_player/core/models/search_model.dart';
import 'package:music_player/music_player.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<SearchModel> _suggestions =
      []; // Assuming MyModel is the model used in ApiService
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.isNotEmpty) {
        _fetchSuggestions(query);
      } else {
        setState(() => _suggestions = []);
      }
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    try {
      final results = await ApiService().searchSongs(query);
      setState(() {
        _suggestions = results;
      });
    } catch (e) {
      print("Error fetching suggestions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Music")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search for music',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final song = _suggestions[index];
                  return ListTile(
                    minVerticalPadding: 10,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 5,
                    ),
                    title: Text(song.name),
                    subtitle: Text(
                      maxLines: 1,
                      song.album?.name ?? "NA",
                    ),
                    leading: Image.network(
                      (song.thumbnails.isNotEmpty
                          ? song.thumbnails.length > 1
                              ? song.thumbnails[1].url ?? ""
                              : song.thumbnails[0].url ?? ""
                          : "https://static-00.iconduck.com/assets.00/no-image-icon-512x512-lfoanl0w.png"),
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MusicPlayer(
                            music: song,
                          ),
                        ),
                      );
                    },
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
