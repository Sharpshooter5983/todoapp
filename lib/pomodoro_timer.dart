import 'package:flutter/material.dart';
import 'pomodoro_service.dart';

class PomodoroTimer extends StatefulWidget {
  final PomodoroService pomodoroService;

  PomodoroTimer({required this.pomodoroService});

  @override
  _PomodoroTimerState createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
      ),
      body: Center(
        child: StreamBuilder<int>(
          stream: widget.pomodoroService.timerStream,
          initialData: 25 * 60,
          builder: (context, snapshot) {
            int seconds = snapshot.data ?? 0;
            String timerDisplay = '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
            
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.pomodoroService.isBreak ? 'Break Time' : 'Focus Time',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  timerDisplay,
                  style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: widget.pomodoroService.isActive ? widget.pomodoroService.stopTimer : widget.pomodoroService.startTimer,
                      child: Text(widget.pomodoroService.isActive ? 'Stop' : 'Start'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.pomodoroService.isActive ? Colors.red : Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: widget.pomodoroService.resetTimer,
                      child: Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}