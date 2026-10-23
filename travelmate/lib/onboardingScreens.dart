import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelmate/main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool _isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _isLastPage = (index == 3); // Update this to 3 for the fourth page
          });
        },
        children: <Widget>[
          buildPage(
            image: 'assets/onboarding1.png',
            title: 'Welcome to TravelMate',
            description: 'The best app to rent host houses around the world.',
          ),
          buildPage(
            image: 'assets/onboarding2.png',
            title: 'Search',
            description: 'Discover a world of accommodations tailored to your preferences with our intuitive search feature.',
          ),
          buildPage(
            image: 'assets/onboarding3.png',
            title: 'Chat',
            description: 'Connect with hosts and fellow travelers effortlessly through our real-time messaging system.',
          ),
          buildPage(
            image: 'assets/onboarding4.png',
            title: 'Book',
            description: 'Book your dream accommodation with confidence and ease, right from the palm of your hand.',
          ),
        ],
      ),
      bottomSheet: _isLastPage
          ? Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Color.fromARGB(255, 255, 146, 99), 
                        minimumSize: const Size(150, 50), 
                      ),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setBool('showOnboarding', false);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => MyApp()),
                        );
                      },
                      child: const Text(
                        'Get Started',
                        style: TextStyle(fontSize: 24, color: Colors.white), 
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), 
                ],
              ),
            )
          : Container(
              height: 80,
              color: Colors.white, 
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => _controller.jumpToPage(3),
                    child: const Text('SKIP', style: TextStyle(color: Color.fromARGB(255, 255, 146, 99))),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: 4, 
                      effect: const WormEffect(
                        spacing: 16,
                        dotWidth: 8, 
                        dotHeight: 8, 
                        dotColor: Colors.grey,
                        activeDotColor: Color.fromARGB(255, 255, 146, 99), 
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
                    child: const Text('NEXT', style: TextStyle(color: Color.fromARGB(255, 255, 146, 99))),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildPage({required String image, required String title, required String description}) {
    return SingleChildScrollView( // Wrap the content in SingleChildScrollView
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Align content to the start
          children: <Widget>[
            const SizedBox(height: 60), // Add margin to the top
            Image.asset(image, width: double.infinity),
            const SizedBox(height: 64), // Adjust spacing as needed
            Text(
              title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              description,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
