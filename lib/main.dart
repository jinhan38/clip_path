import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  double startWidth = 0;
  double startHeight = 0;
  double updateValue = 0;
  late Size size;
  bool initValue = false;
  double waterDropOpacity = 1.0;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    if (!initValue && size.width > 0) {
      startWidth = size.width * 0.5;
      startHeight = 400 * 0.8;
      updateValue = startHeight;
      initValue = true;
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            child: Stack(
              children: [
                _backgroundWidget(),
                Positioned(
                  left: startWidth - 15,
                  top: updateValue,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: waterDropOpacity,
                    child: ClipPath(
                      clipper: WaterDropClipPath(),
                      child: Container(
                        width: 30,
                        height: 20,
                        color: Colors.purpleAccent,
                      ),
                    ),
                  ),
                ),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ElevatedButton(
                        onPressed: () async {
                          double startValue = 500 - startHeight - 10;
                          bool waterDropAnim = false;

                          for (int i = 0; i <= startValue * 0.3; i++) {
                            await Future.delayed(
                                    const Duration(milliseconds: 2))
                                .then((value) {});
                            setState(() {
                              updateValue += 3;
                            });

                            if (i > startValue * 0.2 && !waterDropAnim) {
                              waterDropOpacity = 0;
                              waterDropAnim = true;
                              _controller.forward();
                              Future.delayed(const Duration(milliseconds: 400))
                                  .then((value) {
                                _controller.value = 0;
                                setState(() {
                                  updateValue = startHeight;
                                  waterDropOpacity = 1;
                                });
                              });
                            }
                          }
                        },
                        child: Text("버튼"))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _backgroundWidget() {
    return Column(
      children: [
        ClipPath(
          clipper: CustomClipPath(),
          child: Container(
            alignment: Alignment.center,
            color: Colors.red,
            height: 400,
            width: double.infinity,
            child: const Text(
              'Water Drop',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
        ScaleTransition(
          scale: _animation,
          child: SizedBox(
            width: 200,
            height: 200,
            child: CustomPaint(
              painter: OvalPainter(),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
      w * 0.3,
      h * 0.5,
      w * 0.45,
      h * 0.75,
    );
    path.quadraticBezierTo(
      w * 0.5,
      h * 0.8,
      w * 0.55,
      h * 0.75,
    );
    path.quadraticBezierTo(
      w * 0.7,
      h * 0.5,
      w,
      h,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class WaterDropClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();
    path.moveTo(w * 0.5, 0);
    path.quadraticBezierTo(
      0,
      h * 0.75,
      w * 0.45,
      h * 0.98,
    );

    path.quadraticBezierTo(
      w * 0.5,
      h,
      w * 0.55,
      h * 0.98,
    );

    path.quadraticBezierTo(
      w,
      h * 0.75,
      w * 0.5,
      0,
    );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class OvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const angle = -math.pi / 4;
    Color paintColor = Colors.purpleAccent;
    Paint circlePaint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.save();
    // canvas.translate(0, size.height * 0.5);
    canvas.translate(size.width * 0.5, size.height * 0.5);
    // canvas.rotate(angle);
    // canvas.drawOval(Rect.fromLTRB(0, 0, size.width, size.height), circlePaint);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset.zero, width: size.width, height: size.height * 0.5),
        circlePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Color paintColor = Colors.purpleAccent.withOpacity(0.2);
    Paint circlePaint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(size.width * 0.5, size.height * 0.5);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset.zero, width: size.width, height: size.height * 0.5),
        circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class WaveStrokePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Color paintColor = Colors.purple;
    Paint circlePaint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.save();
    canvas.translate(size.width * 0.5, size.height * 0.5);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset.zero, width: size.width, height: size.height * 0.5),
        circlePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(0xffaa44aa)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.5), size.width * 0.5, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
