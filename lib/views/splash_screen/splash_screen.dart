import 'package:abdullah_diary/widgets/navbar/navbar.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with SingleTickerProviderStateMixin{
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 5),
    vsync: this,
  )..repeat();
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const NavBar())));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(color: Colors.yellow),
        child: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, child) {
                return Transform.scale(
                  scale: _controller.value * 1.0 * math.pi,
                  child: child,
                );
              },
              child: Container(
                color: Colors.transparent,
                height: 200,
                width: 200,
                child: Center(
                  child: Text("Company logo")
                  // Image(
                  //   image: const AssetImage('assets/logo.png'),
                  //   height: MediaQuery.of(context).size.height / 4,
                  //   width: MediaQuery.of(context).size.width / 4,
                  // ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}