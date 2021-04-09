import 'package:flutter/material.dart';
import 'package:kbc_quiz/provider/screen_state.dart';
import 'package:kbc_quiz/util/play_audio.dart';
import 'package:provider/provider.dart';

AnimationController _animationController;
AnimationController get animcontrollervalue => _animationController;


class CountDownTimer extends StatefulWidget {
  const CountDownTimer({
    Key key,
    int secondsRemaining,
    this.countDownTimerStyle,
    this.whenTimeExpires,
    this.countDownFormatter,
  })  : secondsRemaining = secondsRemaining,
        super(key: key);

  final int secondsRemaining;
  final Function whenTimeExpires;
  final Function countDownFormatter;
  final TextStyle countDownTimerStyle;

  State createState() => new _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  //AnimationController _animationController;
  Duration duration;
  bool countDownTimerStarted = false;


  String get timerDisplayString {
    Duration duration = _animationController.duration * _animationController.value;
    if(duration.inSeconds < 11 && !countDownTimerStarted) {
      PlayAudio().countDown();
      countDownTimerStarted = true;
    } else if(duration.inSeconds > 11 && countDownTimerStarted) {
      countDownTimerStarted = false;
    }



    return widget.countDownFormatter != null
        ? widget.countDownFormatter(duration.inSeconds)
        : _formatHHMMSS(duration.inSeconds);
  }

  @override
  void initState() {
    super.initState();
    duration = new Duration(seconds: widget.secondsRemaining);
    _animationController = new AnimationController(
      vsync: this,
      duration: duration,
    );
    _animationController.reverse(from: widget.secondsRemaining.toDouble());
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        widget.whenTimeExpires();
      }
    });
  }

  @override
  void didUpdateWidget(CountDownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.secondsRemaining != oldWidget.secondsRemaining) {
      setState(() {
        duration = new Duration(seconds: widget.secondsRemaining);
        _animationController.dispose();
        _animationController = new AnimationController(
          vsync: this,
          duration: duration,
        );
        _animationController.reverse(from: widget.secondsRemaining.toDouble());
        _animationController.addStatusListener((status) {
          if (status == AnimationStatus.completed ||
              status == AnimationStatus.dismissed) {
            widget.whenTimeExpires();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenState state = Provider.of<ScreenState>(context);
    return Center(
            child: AnimatedBuilder(
                animation: _animationController,
                builder: (_, Widget child) {
                  return AnimatedOpacity(
                    duration: Duration(milliseconds: 2500),
                    opacity: state.isVisible ? 1.0 : 0.0,
                    child: Text(
                      timerDisplayString,
                      style: widget.countDownTimerStyle,
                    ),
                  );
                }),
            );
  }

  String _formatHHMMSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


}
