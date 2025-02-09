import 'package:flutter/material.dart';
import 'dart:ui_web';
import 'dart:html' as html;
import 'package:js/js.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// Application itself.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const HomePage());
  }
}

// var service = JsInteropService();

/// [Widget] displaying the home page consisting of an image the the buttons.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State of a [HomePage].
///
class _HomePageState extends State<HomePage> {
  TextEditingController imageTextController = TextEditingController();
  String imageUrl = "";
  bool isContextMenuOpen = false;
  OverlayEntry? overlayEntry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: buildHtmlImage(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Image URL'),
                    controller: imageTextController,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    loadImage();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child: Icon(Icons.arrow_forward),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showContextMenu(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildHtmlImage() {
    if (imageUrl.isEmpty) {
      return const SizedBox();
    }
    final viewId = 'html-image-${DateTime.now().microsecondsSinceEpoch}';
    platformViewRegistry.registerViewFactory(viewId, (int viewId) {
      final img = html.ImageElement();
      img.src = imageUrl;
      img.style.width = '100%';
      img.style.height = '100%';
      img.style.objectFit = 'cover';
      img.onDoubleClick.listen((event) {
        _toggleFullScreen();
      });
      return img;
    });
    return HtmlElementView(
      viewType: viewId,
      key: ValueKey(imageUrl),
    );
  }

  void loadImage() {
    setState(() {
      imageUrl = imageTextController.text;
    });
  }

  void showContextMenu(BuildContext context) {
    if (isContextMenuOpen) return;
    overlayEntry = OverlayEntry(
        builder: (context) => Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    closeMenu();
                  },
                  child: Container(
                    color: Colors.black54,
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 80,
                  child: Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: [
                        popupMenuItem("Enter FullScreen", () {
                          closeMenu();
                          _enterFullScreen();
                        }),
                        popupMenuItem("Exit FullScreen", () {
                          closeMenu();
                          _exitFullScreen();
                        })
                      ],
                    ),
                  ),
                )
              ],
            ));

    Overlay.of(context).insert(overlayEntry!);
    setState(() {
      isContextMenuOpen = true;
    });
  }

  popupMenuItem(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void closeMenu() {
    overlayEntry?.remove();
    setState(() {
      isContextMenuOpen = false;
    });
  }
}

@JS()
external _toggleFullScreen();

@JS()
external _enterFullScreen();

@JS()
external _exitFullScreen();