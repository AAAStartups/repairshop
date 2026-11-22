import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0, 0.5)),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003A26),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo container
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoScale.value,
                  child: Opacity(
                    opacity: _logoOpacity.value,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDB000),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEDB000).withValues(alpha: 0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'QF',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF003A26),
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Brand text
            AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return SlideTransition(
                  position: _textSlide,
                  child: Opacity(
                    opacity: _textOpacity.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  const Text(
                    'QuickFix',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your Device, Our Priority',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.65),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _textController,
        builder: (context, child) => Opacity(
          opacity: _textOpacity.value,
          child: child,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Center(
            child: Text(
              'Powered by QuickFix Technologies',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
