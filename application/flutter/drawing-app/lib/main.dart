import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<Offset>> lines = [];
  List<Offset> currentLine = [];
  List<List<Offset>> redoStack = [];
  final GlobalKey repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                RenderBox box = context.findRenderObject() as RenderBox;
                Offset point = box.globalToLocal(details.globalPosition);
                setState(() {
                  currentLine = [point];
                  redoStack.clear(); // Bersihkan redo saat mulai garis baru
                });
              },
              onPanUpdate: (details) {
                RenderBox box = context.findRenderObject() as RenderBox;
                Offset point = box.globalToLocal(details.globalPosition);
                setState(() {
                  currentLine.add(point);
                });
              },
              onPanEnd: (details) {
                setState(() {
                  lines.add(currentLine);
                  currentLine = [];
                });
              },
              child: RepaintBoundary(
                key: repaintKey,
                child: Stack(
                  children: [
                    // Layer Gambar Asli
                    Positioned.fill(
                      child: Image.asset(
                        'assets/sample-1.jpeg',
                        fit: BoxFit.cover,
                      )
                    ),

                    // Layer Overlay
                    Positioned.fill(
                      child: Container(
                        color: Colors.white.withOpacity(0.5), // Bisa ubah ke warna dan transparansi lain
                      ),
                    ),

                    // Layer Canvas
                    Positioned.fill(
                      child: CustomPaint(
                        painter: DrawingPainter(lines, currentLine),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ===== Tombol2 =====
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: undo,
                  icon: const Icon(Icons.undo),
                  label: const Text("Undo"),
                ),
                ElevatedButton.icon(
                  onPressed: redo,
                  icon: const Icon(Icons.redo),
                  label: const Text("Redo"),
                ),
                ElevatedButton.icon(
                  onPressed: clear,
                  icon: const Icon(Icons.clear),
                  label: const Text("Clear"),
                ),
                ElevatedButton.icon(
                  onPressed: exportImage,
                  icon: const Icon(Icons.download),
                  label: const Text("Export"),
                ),
              ],
            ),
          )
        ]
      ),
    );
  }

  void undo() {
    if (lines.isNotEmpty) {
      setState(() {
        redoStack.add(lines.removeLast());
      });
    }
  }

  void redo() {
    if (redoStack.isNotEmpty) {
      setState(() {
        lines.add(redoStack.removeLast());
      });
    }
  }

  void clear() {
    setState(() {
      lines.clear();
      redoStack.clear();
    });
  }

  Future<void> exportImage() async {
    try {
      RenderRepaintBoundary boundary =
      repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes != null) {
        // Kirim ke server atau simpan ke database
        print(pngBytes);
        print("Berhasil export gambar: ${pngBytes.lengthInBytes} bytes");
      }
    } catch (e) {
      print("Gagal export: $e");
    }
  }
}

class DrawingPainter extends CustomPainter {
  final List<List<Offset>> lines;
  final List<Offset> currentLine;

  DrawingPainter(this.lines, this.currentLine);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (var line in lines) {
      _drawLine(canvas, line, paint);
    }
    _drawLine(canvas, currentLine, paint);
  }

  void _drawLine(Canvas canvas, List<Offset> points, Paint paint) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
