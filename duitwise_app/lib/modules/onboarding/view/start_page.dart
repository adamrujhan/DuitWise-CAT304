import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideInDo;
  late Animation<Offset> _slideInIt;
  late Animation<Offset> _slideInWise;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slideInDo = Tween<Offset>(
      begin: const Offset(-0.3, 0), // start slightly below
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideInIt = Tween<Offset>(
      begin: const Offset(0.3, 0), // start slightly below
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideInWise = Tween<Offset>(
      begin: const Offset(0, 0.3), // start slightly below
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward(); // Start animation when page loads
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              Column(
                children: [
                  Padding(
                    // offset the word to the left
                    padding: EdgeInsets.only(right: 50),
                    child: SlideTransition(
                      position: _slideInDo,
                      child: Text(
                        "DO",
                        style: TextStyle(
                          fontSize: 70,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    // offset the word to the right
                    padding: EdgeInsets.only(left: 120),
                    child: SlideTransition(
                      position: _slideInIt,
                      child: Text(
                        "IT",
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SlideTransition(
                    position: _slideInWise,
                    child: Text(
                      "WISE",
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      context.push('/signin');
                    },
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
