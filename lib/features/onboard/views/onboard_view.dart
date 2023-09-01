import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vinews_news_reader/features/onboard/onboarding_contents.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/vinews_icons.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';
import 'package:vinews_news_reader/widgets/vinews_icon_buttons_icons.dart';

class OnboardView extends ConsumerStatefulWidget {
  const OnboardView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OnboardViewState();
}

class _OnboardViewState extends ConsumerState<OnboardView> {
  int pageIndex = 0;
  late PageController _onboardPageController;

  @override
  void initState() {
    super.initState();
    _onboardPageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _onboardPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          controller: _onboardPageController,
          itemCount: pageContents.length,
          onPageChanged: (int index) {
            setState(() {
              pageIndex = index;
            });
          },
          itemBuilder: (context, indexer) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only()
                        .padSpec(left: 40, top: 40, right: 40, bottom: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity, // Set the width of the box
                          height: 370.h, // Set the height of the box
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(20), // Apply border radius
                            child: Image.asset(
                              pageContents[indexer]
                                  .image, // Replace with your image path
                              fit: BoxFit.cover, // Adjust the fit as needed
                            ),
                          ),
                        ),
                        20.sbH,
                        // Your onboarding content here
                        pageContents[indexer].title.txtStyled(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w800,
                            color: Pallete.appButtonColor,
                            textAlign: TextAlign.center),
                        25.sbH,
                        // pageContents[indexer].description.txtStyled(
                        //     fontSize: 18.sp,
                        //     textAlign: TextAlign.center,
                        //     fontWeight: FontWeight.w400,
                        //     color: Pallete.onboardDescTxtColor),
                        50.sbH,
                        ViNewsAppIconButton(
                          onButtonPress: () {
                            if (pageIndex == pageContents.length - 1) {
                              context.goNamed(
                                  ViNewsAppRouteConstants.authIntializer);
                            }
                            _onboardPageController.nextPage(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInToLinear);
                          },
                          buttonPlaceholderText:
                              pageIndex == pageContents.length - 1
                                  ? "Explore"
                                  : "Continue",
                          suffixIcon: ViNewsIcons.onboardButtonIcon,
                          isEnabled: true,
                        ),
                        20.sbH,
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
