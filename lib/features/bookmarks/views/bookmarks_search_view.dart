import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';
import 'package:vinews_news_reader/widgets/vinews_search_text_fields.dart';

class BookmarksSearchView extends ConsumerStatefulWidget {
  const BookmarksSearchView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookmarksSearchViewState();
}

class _BookmarksSearchViewState extends ConsumerState<BookmarksSearchView> {
  final _bookmarkSearchFieldController = TextEditingController();

  // Dispose Explore Search Bar Controller
  @override
  void dispose() {
    _bookmarkSearchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 90.h,
          backgroundColor: Pallete.blackColor,
          // The search area here
          title: Hero(
            tag: 'bookmarksSearchHeroTag',
            child: ViNewsSearchTextField(
                textfieldHeight: 65.h,
                controller: _bookmarkSearchFieldController,
                hintText: "What article are you looking for?",
                obscureText: false,
                autoFocus: true,
                suffixIcon: PhosphorIcons.regular.x.iconslide(size: 20.sp),
                prefixIcon: PhosphorIcons.regular.magnifyingGlass
                    .iconslide(size: 26.sp, color: Pallete.blackColor)),
          )),
      body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/background.png",
              ),
              opacity: 0.15,
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
                child: Padding(
              padding: 25.0.padA,
              child: const Column(
                children: [],
              ),
            )),
          )),
    );
  }
}
