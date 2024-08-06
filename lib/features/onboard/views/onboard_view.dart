import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/features/onboard/widgets/onboard_screen_layout_widget.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';

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
    // Custom Widget Implementation
    return OnboardScreenLayoutWidget(
      onTapSkipButton: () {
        context.pushReplacementNamed(ViNewsAppRouteConstants.authIntializer);
      },
      backgroundColor: Palette.greyColor,
      screenProgressIcon: PhosphorIconsBold.caretRight,
      ultimateScreenIcon: PhosphorIconsBold.caretDoubleRight,
      circularProgressForegroundColor: Palette.blackColor,
      skipTextStyle: TextStyle(fontSize: 19.5.sp, color: Palette.blackColor),
    );
  }
}
