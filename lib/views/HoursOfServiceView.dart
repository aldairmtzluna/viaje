import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HoursOfServiceView extends StatefulWidget {
  @override
  _HoursOfServiceViewState createState() => _HoursOfServiceViewState();
}

class _HoursOfServiceViewState extends State<HoursOfServiceView> {
  Timer? _timer;
  DateTime _startTime = DateTime.now();
  Duration _elapsedTime = Duration.zero;
  bool _isPaused = false;
  Duration _pausedDuration = Duration.zero;

  // Variable to store the pause state in SharedPreferences
  SharedPreferences? _prefs;
  static const String _prefsKey = 'timerPaused';

  @override
  void initState() {
    super.initState();
    _loadPrefs(); // Load SharedPreferences when the view initializes
    _startTimer();
  }

  // Load SharedPreferences data
  Future<void> _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _isPaused = _prefs?.getBool(_prefsKey) ?? false; // Use null-aware operator
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      if (!_isPaused) {
        setState(() {
          _elapsedTime = DateTime.now().difference(_startTime) - _pausedDuration;
        });
      }
      // Check if it's 12:00 AM Mexico City time to reset timer
      DateTime now = DateTime.now().toLocal();
      if (now.hour == 0 && now.minute == 0 && now.second == 0 && now.timeZoneName == 'CST') {
        _startTime = DateTime.now();
        _elapsedTime = Duration.zero;
        _pausedDuration = Duration.zero;
      }
    });
  }

  void _togglePause() async {
    if (_isPaused) {
      _pausedDuration += DateTime.now().difference(_pausedTime);
    } else {
      _pausedTime = DateTime.now();
    }
    setState(() {
      _isPaused = !_isPaused;
    });
    _prefs?.setBool(_prefsKey, _isPaused); // Use null-aware operator
  }

  DateTime _pausedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double progress = _elapsedTime.inSeconds / (24 * 60 * 60); // Progress as a fraction of 24 hours

    return WillPopScope(
      onWillPop: () async {
        _togglePause(); // Save pause state before leaving the view
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFEF4136),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                strokeWidth: 10,
              ),
              SizedBox(height: 20),
              Text(
                '${_elapsedTime.inHours}:${(_elapsedTime.inMinutes % 60).toString().padLeft(2, '0')}:${(_elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 48),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                    onPressed: _togglePause,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HoursOfServiceView(),
  ));
}
