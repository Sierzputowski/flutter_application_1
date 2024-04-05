import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StaggeredAnimationDemo(),
    );
  }
}

class StaggeredAnimationDemo extends StatefulWidget {
  const StaggeredAnimationDemo({super.key});

  @override
  _StaggeredAnimationDemoState createState() => _StaggeredAnimationDemoState();
}

class _StaggeredAnimationDemoState extends State<StaggeredAnimationDemo> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late AudioCache _audioCache;
  late AnimationController _tweenController;
  late Animation<double> _tweenAnimation;

  bool _isMusicPlaying = false;

  @override
  void initState() {
    super.initState();

    _audioCache = AudioCache();
    _audioCache.prefix = 'assets/sound/';
    _audioCache.load('egg_shake_sound.mp3'); // Preload the sound

    _tweenController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _tweenAnimation = Tween<double>(begin: 150.0, end: 200.0).animate(_tweenController);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Total animation duration
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _tweenController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut), // Staggered start for fade animation
      ),
    );


    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut), // Staggered start for slide animation
      ),
    );

    _controller.repeat(reverse: true); // Start the animation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"), // Your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Image.asset(
                          'assets/easter_egg.png',
                          width: 150,
                          height: 200,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: const Text(
                          'Happy Easter',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          AnimatedBuilder(
              animation: _tweenAnimation,
              builder: (context, child) {
                return Column (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!_isMusicPlaying) {
                          _audioCache.loop('egg_shake_sound.mp3');
                          _isMusicPlaying = true;
                        }
                        else {
                          _audioCache.play('18_thunder_02.wav');
                        }
                      },
                      child: Image.asset(
                        'assets/easter_egg_2.png',
                        width: _tweenAnimation.value,
                        height: _tweenAnimation.value * 1.33,
                      ),
                    ),
                    const Text(
                          'Click me!',
                          style: TextStyle(fontSize: 20),
                    )
                  ]
                );
              },
            )
        ]),
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
