import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calibration_page.dart';
import 'ruler.dart';

void main() {
  runApp(RulerApp());
}

class RulerApp extends StatelessWidget {
  const RulerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? pixelsPerCm;
  double horizontalPosition = 100.0;  // 横向线条Y位置
  double verticalPosition = 100.0;    // 纵向线条X位置
  final double circleRadius = 20.0;

  @override
  void initState() {
    super.initState();
    _loadCalibration();
  }
  // 新增重置校准方法
  void _resetCalibration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('pixelsPerCm');
    _loadCalibration();
  }
  void _loadCalibration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pixelsPerCm = prefs.getDouble('pixelsPerCm');
    });
    if (pixelsPerCm == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CalibrationPage()),
      ).then((_) => _loadCalibration());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (pixelsPerCm == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final screenSize = MediaQuery.of(context).size;
    final horizontalCm = (horizontalPosition / pixelsPerCm!).toStringAsFixed(1);
    final verticalCm = (verticalPosition / pixelsPerCm!).toStringAsFixed(1);

    return Scaffold(
      body: Stack(
        children: [
          // 水平刻度尺
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HorizontalRuler(pixelsPerCm: pixelsPerCm!),
          ),

          // 垂直刻度尺
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: VerticalRuler(pixelsPerCm: pixelsPerCm!),
          ),

          // 垂直测量线
          Positioned(
            left: verticalPosition,
            top: 0,
            bottom: 0,
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ],
              ),
            ),
          ),

          // 水平测量线
          Positioned(
            top: horizontalPosition,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ],
              ),
            ),
          ),

          // 控制圆圈
          Positioned(
            left: verticalPosition - circleRadius,
            top: horizontalPosition - circleRadius,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  verticalPosition += details.delta.dx;
                  horizontalPosition += details.delta.dy;
                  verticalPosition = verticalPosition.clamp(0, screenSize.width);
                  horizontalPosition = horizontalPosition.clamp(0, screenSize.height);
                });
              },
              child: Container(
                width: circleRadius * 2,
                height: circleRadius * 2,
                decoration: BoxDecoration(
                  color: Colors.amber.shade400,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      verticalCm,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      horizontalCm,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16.0,
            bottom: 16.0,
            child: ElevatedButton.icon(
              onPressed: _resetCalibration,
              label: Text('重新校准', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}