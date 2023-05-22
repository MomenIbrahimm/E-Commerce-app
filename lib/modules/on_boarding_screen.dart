import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_app/modules/login_screen/login_screen.dart';
import 'package:shop_app/share/components/components.dart';
import 'package:shop_app/share/network/remote/cach_helper.dart';
import 'package:shop_app/share/style/const.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../model/on_board_model.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<OnBoardModel> boardList = [
    OnBoardModel('assets/1.json', 'See the product',
        'Lorem ipsum dolor sit armet, consectetur adipiscing elit.Sed eget libero feugiat, faucibus libero id, scelerisque quam'),
    OnBoardModel('assets/2.json', 'And see the details',
        'Lorem ipsum dolor sit armet, consectetur adipiscing elit.Sed eget libero feugiat, faucibus libero id, scelerisque quam'),
    OnBoardModel('assets/3.json', 'Buy it if suitable for you',
        'Lorem ipsum dolor sit armet, consectetur adipiscing elit.Sed eget libero feugiat, faucibus libero id, scelerisque quam'),
  ];

  var pageController = PageController();
  bool isLast = false;
  void onSubmit() {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value) {
        navigateToAndFinish(context, LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white38,
      ),
      body: PageView.builder(
        controller: pageController,
        onPageChanged: (index) {
          if (index == boardList.length - 1) {
            setState(() {
              isLast = true;
            });
          } else {
            isLast = false;
          }
        },
        itemBuilder: (context, index) =>
            buildBoardItem(boardList[index], context),
        itemCount: boardList.length,
      ),
    );
  }

  Widget buildBoardItem(OnBoardModel model, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
            child: Text(
          model.title,
          style: Theme.of(context).textTheme.bodyLarge,
        )),

        Expanded(child: Lottie.asset(model.image)),
        const SizedBox(
          height: 20.0,
        ),
        Center(
          child: SmoothPageIndicator(
              controller: pageController,
              count: boardList.length,
              effect: WormEffect(
                  dotHeight: 10.0,
                  dotWidth: 20.0,
                  radius: 20,
                  spacing: 5.0,
                  activeDotColor: defaultColor)),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            model.decription,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        if (isLast)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Theme.of(context).primaryColor,
                ),
                child: MaterialButton(
                  onPressed: () {
                    if (isLast) {
                      onSubmit();
                    }
                  },
                  child: const Text(
                    'Get Started',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ),
            ),
          ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                TextButton(
                    onPressed: () {
                      onSubmit();
                    },
                    child: const Text(
                      'skip',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    onPressed: () {
                        pageController.nextPage(
                            duration: const Duration(milliseconds: 750),
                            curve: Curves.fastOutSlowIn);
                    },
                    child: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}
