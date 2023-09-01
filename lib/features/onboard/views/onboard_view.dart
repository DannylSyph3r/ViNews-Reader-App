import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/features/onboard/onboarding_contents.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/frosted_glass_box.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

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
            return Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(pageContents[indexer].image),
                      fit: BoxFit.cover)),
              child: FrostedGlassBox(
                theHeight: MediaQuery.of(context).size.height,
                theWidth: MediaQuery.of(context).size.width,
                theChild: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 450.h,
                        decoration: BoxDecoration(
                            color: Pallete.greyColor.withOpacity(0.55),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 42),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Your onboarding content here
                                pageContents[indexer].title.txtStyled(
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Pallete.appButtonColor,
                                    textAlign: TextAlign.center),
                                16.sbH,
                                pageContents[indexer].description.txtStyled(
                                    fontSize: 18.sp,
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.w400,
                                    color: Pallete.blackColor),
                                70.sbH,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          if (pageIndex ==
                                              pageContents.length - 1) {
                                            context.goNamed(
                                                ViNewsAppRouteConstants
                                                    .authIntializer);
                                          }
                                          _onboardPageController.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              curve: Curves.easeInToLinear);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Pallete.appButtonColor,
                                          fixedSize: Size(75.h, 75.h),
                                          shape: const CircleBorder(),
                                        ),
                                        child: pageIndex == pageContents.length - 1
                                          ? PhosphorIcons.bold.caretDoubleRight
                                            .iconslide()
                                          : PhosphorIcons.bold.caretRight
                                            .iconslide()),
                                        
                                  ],
                                ),
                                10.sbH,
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
