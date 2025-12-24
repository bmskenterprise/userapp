import 'dart:async';
//import 'package:bmsk_userapp/Toast.dart';
//import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

class CircleFillWidget extends StatefulWidget {
  final double size;
  final Color backgroundColor;
  final Color fillColor;
  final Duration fillDuration;
  final Function doTask;
  /*final GlobalKey<FormState> formKey;*/

  const CircleFillWidget({
    super.key,
    /*required this.formKey,*/
    required this.doTask,
    this.size = 100.0,
    this.backgroundColor = Colors.white,
    this.fillColor = Colors.blue,
    this.fillDuration = const Duration(
      milliseconds: 600,
    ) /*required GlobalKey<FormState> formKey,,*/
  });

  @override
  State<CircleFillWidget> createState() => _CircleFillWidgetState();
}

class _CircleFillWidgetState extends State<CircleFillWidget> with SingleTickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _controller;
  // bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.fillDuration,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }


  @override
  void dispose() {
    _controller.dispose();_timer?.cancel();
    super.dispose();
  }

  /*void _startFill() {
    setState(() {
      _isPressed = true;
    });
    _controller.forward(from: 0.0);
  }
  void _stopFill() {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
  }
  void doTask() {
    print("Task Executed!");
    // আপনার মূল কাজ এখানে করুন
  }
  void cancelTask() {
    print("Task Canceled!");
    // এখানে আপনি cancel এর কাজ করতে পারেন
  }*/



  void _startTimer(BuildContext context) async {
    /*if (widget.formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('${ApiConstants.baseUrl}/validate'),
          body: {'pin': pin},
        );
        if (response.statusCode == 200) {
          if (response.body.matched) {*/
            _controller.forward(from: 0.0);
            _timer = Timer(Duration(milliseconds: 600), () {
              if (_timer != null && _timer!.isActive){ _timer!.cancel();
              widget.doTask(context);}
            });
          /*} else {
            Toast({'message':'invalid pin', 'success':false});
          }
        }
      } catch (e) {
        Toast({'message':'error', 'success':false});
      }
    }*/
  }

  void _cancelTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /*onLongPressStart: (_) => _startFill(),
      onLongPressEnd: (_) => _stopFill(),
      onLongPressCancel: () => _stopFill(),*/
      onTapDown: (_) => _startTimer(context),
      onTapUp: (_) => _cancelTimer(),
      onTapCancel: () => _cancelTimer(),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.backgroundColor,
          border: Border.all(color: widget.fillColor, width: 2.0),
        ),
        child: Center(
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: CircleFillPainter(
              progress: _controller.value,
              fillColor: widget.fillColor,
            ),
          ),
        ),
      ),
    );
  }
}

class CircleFillPainter extends CustomPainter {
  final double progress;
  final Color fillColor;

  CircleFillPainter({required this.progress, required this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * progress;

    final paint =
        Paint()
          ..color = fillColor
          ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CircleFillPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.fillColor != fillColor;
  }
}

// Example usage:
/*class CircleFillDemo extends StatelessWidget {
  const CircleFillDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Circle Fill Animation'),
      ),
      body: Center(
        child: CircleFillWidget(
          size: 150.0,
          backgroundColor: Colors.white,
          fillColor: Colors.purple,
          fillDuration: const Duration(milliseconds: 1500),
        ),
      ),
    );
  }
}*/
