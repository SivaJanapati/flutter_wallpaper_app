import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import "package:http/http.dart" as http;
import 'package:wallpaper_app/fullscreen.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({super.key});

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List images = [];
  int page = 0;

  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  fetchApi() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
              "DYPst9oPPEbCDwwAYMj1FQfymrF91abVuucmxojMn4Mi9paUgNiGWEHg"
        }).then((value) {
      Map result = jsonDecode(value.body);

      setState(() {
        images = result['photos'];
      });
    });
  }

  _loadMoreImages() async {
    setState(() {
      page = page + 1;
    });

    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();

    await http.get(Uri.parse(url), headers: {
      'Authorization':
          "DYPst9oPPEbCDwwAYMj1FQfymrF91abVuucmxojMn4Mi9paUgNiGWEHg"
    }).then((value) {
      Map result = jsonDecode(value.body);

      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: GridView.builder(
                  itemCount: images.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 2,
                      crossAxisCount: 3,
                      childAspectRatio: 2 / 3,
                      mainAxisSpacing: 2),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreen(
                          imageUrl: images[index]['src']['portrait'],
                        )));
                      },
                      child: Container(
                        color: Colors.white,
                        child: Image.network(
                          images[index]['src']['tiny'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
            ),
          ),
          InkWell(
            onTap: () {
              _loadMoreImages();
            },
            child: Container(
              height: 60,
              width: double.infinity,
              color: Colors.black,
              child: Center(
                child: const Text(
                  "Load More",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}





//DYPst9oPPEbCDwwAYMj1FQfymrF91abVuucmxojMn4Mi9paUgNiGWEHg