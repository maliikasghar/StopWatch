import 'package:flutter/material.dart';

class StopwatchApp extends StatefulWidget {
  const StopwatchApp({super.key});

  @override
  State<StopwatchApp> createState() => _StopwatchAppState();
}

class _StopwatchAppState extends State<StopwatchApp> {
  late Stopwatch _stopwatch;
  late String _displayTime;
  late final Ticker _ticker;
  String _startStopButtonText = "Start";

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _displayTime = "00:00:00";
    _ticker = Ticker((elapsed) => setState(() => _updateDisplayTime()));
  }

  void _updateDisplayTime() {
    final minutes = _stopwatch.elapsed.inMinutes % 60;
    final seconds = _stopwatch.elapsed.inSeconds % 60;
    final milliseconds = (_stopwatch.elapsed.inMilliseconds % 1000) ~/ 10;

    _displayTime =
    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}:${milliseconds.toString().padLeft(2, '0')}';
  }

  void _startStop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _startStopButtonText = "Start";
    } else {
      _stopwatch.start();
      _ticker.start();
      _startStopButtonText = "Stop";
    }
    setState(() {});
  }

  void _reset() {
    _stopwatch.reset();
    _displayTime = "00:00:00";
    _startStopButtonText = "Start"; // Reset button text to "Start"
    setState(() {});
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Stopwatch',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 5,
            wordSpacing: 5,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: Colors.grey),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _displayTime,
                    style: const TextStyle(
                      fontSize: 75,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(3.0, 3.0),
                          blurRadius: 5,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildButton(_startStopButtonText, _startStop),
                  _buildButton("Reset", _reset),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Developed by Muhammad Asghar',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w100,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 200,
      height: 70,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w100,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class Ticker {
  final Function(Duration) callback;
  late final Duration _duration;

  Ticker(this.callback) : _duration = const Duration(milliseconds: 10);

  void start() {
    Future.doWhile(() async {
      await Future.delayed(_duration);
      callback(_duration);
      return true;
    });
  }

  void dispose() {}
}
