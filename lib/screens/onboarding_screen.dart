import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:quickshop_final/navigation/app_router.dart';
import 'package:quickshop_final/services/api/shared_pref_service.dart';

import '../services/shared_pref_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to QuickShop',
      description: 'The fastest way to shop online with simplicity in mind.',
      image: '🛍️',
      color: Color(0xFF7C3AED),
    ),
    OnboardingPage(
      title: 'Easy Browsing',
      description: 'Find products quickly with our intuitive search and filters.',
      image: '🔍',
      color: Color(0xFFEC4899),
    ),
    OnboardingPage(
      title: 'Secure Checkout',
      description: 'Safe and fast checkout process for your peace of mind.',
      image: '💳',
      color: Color(0xFF10B981),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPageWidget(page: _pages[index]);
            },
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: _pages.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: _pages[_currentPage].color,
                  dotColor: Colors.grey.shade300,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 10,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_currentPage < _pages.length - 1) {
                    _controller.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    await SharedPrefService.setFirstLaunch(false);
                    Navigator.pushReplacementNamed(context, AppRouter.login);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _pages[_currentPage].color,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String image;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(
                page.image,
                style: TextStyle(fontSize: 80),
              ),
            ),
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              page.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              page.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}