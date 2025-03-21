import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalibrationPage extends StatefulWidget {
  const CalibrationPage({super.key});

  @override
  _CalibrationPageState createState() => _CalibrationPageState();
}

class _CalibrationPageState extends State<CalibrationPage> {
  double _width = 100.0;

  void _saveCalibration() async {
    const double actualWidth = 8.56;
    double pixelsPerCm = _width / actualWidth;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('pixelsPerCm', pixelsPerCm);

    Navigator.pop(context);
  }

  // 新增关于对话框
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('关于'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAboutItem('版本', '1.0.0'),
                _buildAboutItem('开发者', '7123studio'),
                _buildAboutItem('联系方式', 's7123@foxmail.com'),
                SizedBox(height: 16),
                Text('使用的开源项目:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                _buildLicenseItem('Flutter', 'BSD License'),
                _buildLicenseItem('shared_preferences', 'BSD License'),
                SizedBox(height: 16),
                Text('本应用遵循各开源项目的许可协议',
                    style: TextStyle(fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('关闭'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAboutItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            TextSpan(
                text: '$title: ',
                style: TextStyle(fontWeight: FontWeight.w500)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildLicenseItem(String library, String license) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color: Colors.blue)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(library,
                    style: TextStyle(fontWeight: FontWeight.w500)),
                Text(license,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('校准'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '请将身份证或银行卡等标准卡片放在屏幕上，调整框的宽度以匹配其实际宽度（8.56 cm）',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Container(
              width: _width,
              height: 54.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 20),
            Slider(
              value: _width,
              min: 50,
              max: 600,
              divisions: 250,
              label: _width.round().toString(),
              onChanged: (value) {
                setState(() {
                  _width = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveCalibration,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text('确认校准'),
            ),
          ],
        ),
      ),
    );
  }
}