import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vinews_news_reader/features/onboard/onboarding_contents.dart';
import 'package:vinews_news_reader/features/onboard/widgets/circle_progress_bar.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class OnboardScreenLayoutWidget extends StatefulWidget {
  final Color? backgroundColor;
  final Color? circularProgressForegroundColor;
  final Color screenProgressIconColor;
  final TextStyle? skipTextStyle;
  final IconData screenProgressIcon;
  final Function()? onTapSkipButton;

  const OnboardScreenLayoutWidget({
    Key? key,
    this.onTapSkipButton,
    this.backgroundColor,
    this.screenProgressIconColor = Colors.white,
    this.circularProgressForegroundColor,
    this.skipTextStyle = const TextStyle(fontSize: 20),
    this.screenProgressIcon = Icons.arrow_right,
  }) : super(key: key);

  @override
  OnboardScreenLayoutWidgetState createState() =>
      OnboardScreenLayoutWidgetState();
}

class OnboardScreenLayoutWidgetState extends State<OnboardScreenLayoutWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: PageView(
          physics: const ClampingScrollPhysics(),
          controller: _pageController,
          children: List.generate(pageContents.length, (index) {
            return _buildPage(index);
          }),
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    return Container(
      color: widget.backgroundColor ?? Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Padding(
          padding: 30.0.padA,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Skip Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: widget.onTapSkipButton,
                    child: Text('Skip', style: widget.skipTextStyle),
                  ),
                ],
              ),
              // Page Layout
              SvgPicture.asset(
                pageContents[index].imagePath,
                height: 340.h,
                width: 340.h,
                fit: BoxFit.cover,
              ),
              pageContents[index].title.txtStyled(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w800,
                    color: Pallete.appButtonColor,
                    textAlign: TextAlign.center,
                  ),
              pageContents[index].description.txtStyled(
                    fontSize: 19.5.sp,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w400,
                    color: Pallete.blackColor,
                  ),
              // Page Button Position
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _customProgress(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customProgress() {
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
            value: ((_currentPage + 1) * 1.0 / pageContents.length),
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
              _currentPage != pageContents.length - 1
                  ? _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    )
                  : widget.onTapSkipButton!();
            },
            icon: Icon(widget.screenProgressIcon,
                color: widget.screenProgressIconColor, size: 19),
            iconSize: 15,
          ),
        ),
      ],
    );
  }
}
