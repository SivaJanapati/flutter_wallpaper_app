import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class FullScreen extends StatefulWidget {
  final String imageUrl;

  const FullScreen({super.key, required this.imageUrl});

  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  Future<void> setWallpaper() async {
    int location = WallpaperManager.HOME_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
    bool result =
        await WallpaperManager.setWallpaperFromFile(file.path, location);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: [
          Expanded(
            child: Container(
              child: Image.network(widget.imageUrl),
            ),
          ),
          InkWell(
            onTap: () {
              setWallpaper();
            },
            child: Container(
              height: 60,
              width: double.infinity,
              color: Colors.black,
              child: Center(
                child: const Text(
                  "Set Wallpaper",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
