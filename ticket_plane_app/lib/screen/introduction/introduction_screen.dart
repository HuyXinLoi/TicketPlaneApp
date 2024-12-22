import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(BuildContext context) {
    context.go('/nav'); // Điều hướng đến trang login
  }

  Widget _buildImage(String assetName, [double width = 300]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 13.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
      bodyAlignment: Alignment.bottomCenter,
      imageAlignment: Alignment.bottomCenter,
      bodyFlex: 2,
      imageFlex: 4,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Chào mừng bạn đến với AirTravel",
          body:
              "Ứng dụng đặt vé máy bay dễ dàng, tiện lợi và nhanh chóng. Hãy sẵn sàng cho những chuyến đi đáng nhớ cùng chúng tôi!",
          image: _buildImage('images/intro1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Quản lý hành trình dễ dàng",
          body:
              "Xem thông tin vé, quản lý hành trình và nhận thông báo chuyến bay ngay trong ứng dụng.",
          image: _buildImage('images/intro2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Giá vé cạnh tranh",
          body:
              "Chúng tôi luôn cung cấp giá vé ưu đãi nhất để bạn có thể bay xa hơn mà không lo về chi phí.",
          image: _buildImage('images/intro3.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text(
        'Skip',
        style: TextStyle(color: Color.fromARGB(255, 14, 68, 216)),
      ),
      next: const Icon(Icons.arrow_forward, color: Colors.lightBlue),
      done: const Text('Done',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color.fromARGB(255, 45, 89, 235),
        activeColor: Colors.lightBlue,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
