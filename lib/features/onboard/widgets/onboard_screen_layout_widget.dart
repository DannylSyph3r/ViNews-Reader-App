import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vinews_news_reader/features/onboard/views/onboarding_contents.dart';
import 'package:vinews_news_reader/features/onboard/widgets/circle_progress_bar.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/widgets/frosted_glass_box.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class OnboardScreenLayoutWidget extends StatefulWidget {
  final Color? backgroundColor;
  final Color? circularProgressForegroundColor;
  final Color screenProgressIconColor;
  final TextStyle? skipTextStyle;
  final IconData screenProgressIcon;
  final IconData ultimateScreenIcon;
  final void Function() onTapSkipButton;

  const OnboardScreenLayoutWidget({
    Key? key,
    required this.onTapSkipButton,
    this.backgroundColor,
    this.screenProgressIconColor = Colors.white,
    this.circularProgressForegroundColor,
    this.skipTextStyle = const TextStyle(fontSize: 20),
    this.screenProgressIcon = Icons.arrow_right,
    this.ultimateScreenIcon = Icons.arrow_right,
  }) : super(key: key);

  @override
  OnboardScreenLayoutWidgetState createState() =>
      OnboardScreenLayoutWidgetState();
}

class OnboardScreenLayoutWidgetState extends State<OnboardScreenLayoutWidget> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPage = 0.notifier;
  final ValueNotifier<bool> isOverlayVisible = false.notifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.backgroundColor ?? Theme.of(context).colorScheme.background,
      body: Stack(children: [
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _currentPage.sync(
                builder: (BuildContext context, int currentPageValue, child) {
                  return PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      _currentPage.value =
                          page; // Update the current page value
                    },
                    children: List.generate(pageContents.length, (index) {
                      return SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Your page content here, using currentPageValue to customize based on the current index
                            Padding(
                              padding: 25.0.padA,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      isOverlayVisible.value = true;
                                      Future.delayed(1.seconds, () {
                                        widget
                                            .onTapSkipButton(); // Call the function by adding ()
                                      });
                                    },
                                    child: Text('Skip',
                                        style: widget.skipTextStyle),
                                  ),
                                ],
                              ),
                            ),
                            // Page Layout
                            Padding(
                                padding: 25.0.padH,
                                child: SvgPicture.asset(
                                  pageContents[index].imagePath,
                                  height: 340.h,
                                  width: 340.h,
                                  fit: BoxFit.cover,
                                ).animate().fadeIn(delay: 150.ms).slideX()),
                            Padding(
                                padding: 25.0.padH,
                                child: pageContents[index]
                                    .title
                                    .txtStyled(
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w800,
                                      color: Palette.blackColor,
                                      textAlign: TextAlign.center,
                                    )
                                    .animate()
                                    .fadeIn(delay: 250.ms)
                                    .slideX()),
                            Padding(
                                padding: 25.0.padH,
                                child: pageContents[index]
                                    .description
                                    .txtStyled(
                                        fontSize: 19.5.sp,
                                        textAlign: TextAlign.center,
                                        fontWeight: FontWeight.w400,
                                        color: Palette.blackColor,
                                        maxLines: 5,
                                        textOverflow: TextOverflow.ellipsis)
                                    .animate()
                                    .fadeIn(delay: 350.ms)
                                    .slideX()),
                          ],
                        ),
                      );
                    }),
                  );
                },
              )),
              Padding(
                padding: 25.0.padA,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _customProgress(),
                  ],
                ),
              ),
            ],
          ),
        ),
        isOverlayVisible.sync(
          builder: (context, isVisible, child) {
            return Visibility(
              visible: isVisible,
              child: Positioned.fill(
                child: FrostedGlassBox(
                  theWidth: MediaQuery.of(context).size.width,
                  theHeight: MediaQuery.of(context).size.height,
                  theChild: SpinKitFadingCircle(
                    color: Palette.blackColor.withOpacity(0.3),
                  ),
                ),
              ),
            );
          },
        )
      ]),
    );
  }

  Widget _customProgress() {
    return _currentPage.sync(
      builder: (context, currentPageValue, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircleProgressBar(
                backgroundColor: Colors.white,
                foregroundColor: widget.circularProgressForegroundColor ??
                    Theme.of(context).primaryColor,
                value: ((currentPageValue + 1) * 1.0 / pageContents.length),
              ),
            ),
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (widget.circularProgressForegroundColor ??
                        Theme.of(context).primaryColor)
                    .withOpacity(0.7),
              ),
              child: IconButton(
                onPressed: () {
                  if (currentPageValue != pageContents.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  } else {
                    isOverlayVisible.value = true;
                    Future.delayed(1.seconds, () {
                      context.pushReplacementNamed(
                          ViNewsAppRouteConstants.authIntializer);
                    });
                  }
                },
                icon: currentPageValue != pageContents.length - 1
                    ? Icon(widget.screenProgressIcon,
                        color: widget.screenProgressIconColor, size: 19)
                    : Icon(widget.ultimateScreenIcon,
                        color: widget.screenProgressIconColor, size: 19),
                iconSize: 15,
              ),
            ),
          ],
        );
      },
    );
  }
}
