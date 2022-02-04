import 'package:flutter/material.dart';
import 'package:flutter_onboard/flutter_onboard.dart';

class IntroSlider extends StatefulWidget {
  const IntroSlider({ Key? key }) : super(key: key);

  @override
  _IntroSliderState createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: OnBoard(
        pageController: _pageController,
        // Either Provide onSkip Callback or skipButton Widget to handle skip state
        onSkip: () {
          // print('skipped');
        },
        // Either Provide onDone Callback or nextButton Widget to handle done state
        onDone: () {
          // print('done tapped');
        },
        onBoardData: onBoardData,
        titleStyles: const TextStyle(
          color: Colors.purple,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.15,
        ),
        descriptionStyles: TextStyle(
          fontSize: 16,
          color: Colors.brown.shade300,
        ),
        pageIndicatorStyle: const PageIndicatorStyle(
          width: 100,
          inactiveColor: Colors.purpleAccent,
          activeColor: Colors.purple,
          inactiveSize: Size(8, 8),
          activeSize: Size(12, 12),
        ),
        // Either Provide onSkip Callback or skipButton Widget to handle skip state
        skipButton: TextButton(
          onPressed: () {
            // print('skipButton pressed');
          },
          child: const Text(
            "Skip",
            style: TextStyle(color: Colors.purpleAccent),
          ),
        ),
        // Either Provide onDone Callback or nextButton Widget to handle done state
        nextButton: OnBoardConsumer(
          builder: (context, ref, child) {
            final state = ref.watch(onBoardStateProvider);
            return InkWell(
              onTap: () => _onNextTap(state),
              child: Container(
                width: 230,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.purpleAccent],
                  ),
                ),
                child: Text(
                  state.isLastPage ? "Done" : "Next",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  void _onNextTap(OnBoardState onBoardState) {
    if (!onBoardState.isLastPage) {
      _pageController.animateToPage(
        onBoardState.page + 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutSine,
      );
    } else {
      //print("nextButton pressed");
    }
  }
}

final List<OnBoardModel> onBoardData = [
  const OnBoardModel(
    title: "Profile View",
    description: "View the profiles of the added contacts",
    imgUrl: "assets/images/profile_is.png",
  ),
  const OnBoardModel(
    title: "Add Contacts",
    description:
        "Easily add the new contacts by scanning the QR code",
    imgUrl: 'assets/images/contact_is.png',
  ),
  const OnBoardModel(
    title: "Track Direction",
    description:
        "With the help of the geolocation, can easily contact the person at his/her orgranisation's location",
    imgUrl: 'assets/images/direction_is.png',
  ),
  const OnBoardModel(
    title: "Share Profile",
    description:
        "Can share the QR of your profile in order to add person",
    imgUrl: 'assets/images/share_is.png',
  ),
];