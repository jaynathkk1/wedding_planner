import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding_planner/screens/login_screen.dart';

import '../models/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      title: "Plan Your Dream Wedding",
      description: "Organize every detail of your special day with our comprehensive planning tools. From venues to vendors, we've got you covered.",
      image: "assets/images/wedding_planner.png",
    ),
    OnboardingModel(
      title: "Manage Your Budget",
      description: "Keep track of expenses and stay within budget. Our smart budgeting tools help you allocate funds wisely for your big day.",
      image: "assets/images/indian_couple.jpg",
    ),
    OnboardingModel(
      title: "Coordinate with Vendors",
      description: "Connect with trusted wedding vendors in your area. Read reviews, compare prices, and book services all in one place.",
      image: "assets/images/event_discussing_plan.jpg",
    ),
    OnboardingModel(
      title: "Create Your Timeline",
      description: "Build a detailed timeline for your wedding day. Share it with your wedding party and vendors to ensure everything runs smoothly.",
      image: "assets/images/timeline.jpg",
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Preload all onboarding images safely here after context is available
    for (var page in onboardingPages) {
      precacheImage(AssetImage(page.image), context);
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: IntroductionScreen(
          pages: onboardingPages.map((page) => _buildPageViewModel(page)).toList(),
          onDone: _completeOnboarding,
          onSkip: _completeOnboarding,
          showSkipButton: true,
          skip: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            ),
            child: const Text(
              'Skip',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          next: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 24,
            ),
          ),
          done: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE91E63).withOpacity(0.4),
                  spreadRadius: 0,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FittedBox(
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          dotsDecorator: DotsDecorator(
            size: const Size.square(8.0),
            activeSize: const Size(24.0, 8.0),
            activeColor: Colors.white,
            color: Colors.white.withOpacity(0.4),
            spacing: const EdgeInsets.symmetric(horizontal: 4.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          globalBackgroundColor: Colors.transparent,
          curve: Curves.easeInOutCubic,
          animationDuration: 350,
        ),
      ),
    );
  }

  PageViewModel _buildPageViewModel(OnboardingModel page) {
    return PageViewModel(
      title: "",
      body: "",
      image: _buildBackgroundContent(page),
      decoration: const PageDecoration(
        pageColor: Colors.transparent,
        imagePadding: EdgeInsets.zero,
        contentMargin: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        bodyPadding: EdgeInsets.zero,
        imageAlignment: Alignment.center,
        fullScreen: true, // This ensures full screen coverage
      ),
    );
  }

  Widget _buildBackgroundContent(OnboardingModel page) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  page.image,
                  fit: BoxFit.fitHeight,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFFB6C1),
                            Color(0xFFE91E63),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.favorite,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Enhanced gradient overlay for better text readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.4, 0.7, 1.0],
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),

              // Content overlay with better positioning
              Positioned(
                bottom: 140, // Adjusted space for navigation controls
                left: 24,
                right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      page.title,
                      style: const TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      page.description,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        height: 1.5,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
