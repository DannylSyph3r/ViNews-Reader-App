import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/features/bookmarks/controllers/bookmarks_controllers.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_Palette.dart';
import 'package:vinews_news_reader/utils/keyboard_utils.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';
import 'package:vinews_news_reader/widgets/vinews_search_text_fields.dart';

class BookmarksSearchView extends ConsumerStatefulWidget {
  const BookmarksSearchView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookmarksSearchViewState();
}

class _BookmarksSearchViewState extends ConsumerState<BookmarksSearchView> {
  final _bookmarksSearchFieldController = TextEditingController();
  final ValueNotifier<bool> _isTextFieldEmpty = true.notifier;

  // Dispose Explore Search Bar Controller
  @override
  void dispose() {
    _bookmarksSearchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> bookmarksSearchHistoryList =
        ref.watch(bookmarksSearchHistoryProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 90.h,
        backgroundColor: Palette.blackColor,
        // The search area here
        title: ViNewsSearchTextField(
          textfieldHeight: 65.h,
          controller: _bookmarksSearchFieldController,
          hintText: "What do you want to search for?",
          obscureText: false,
          onChanged: (value) {
            // Update the ValueNotifier when the text changes
            _isTextFieldEmpty.value = value.isEmpty;
          },
          onEditingComplete: () {
            final searchQuery = _bookmarksSearchFieldController.text.trim();
            if (searchQuery.isNotEmpty) {
              dropKeyboard();
              context.pushNamed(
                ViNewsAppRouteConstants.userBookmarksSearchResultsRouteName,
                pathParameters: {
                  "searchedWord": searchQuery,
                },
              );
              if (!bookmarksSearchHistoryList.contains(searchQuery)) {
                Future.delayed(500.milliseconds, () {
                  ref
                      .read(bookmarksSearchHistoryProvider.notifier)
                      .addToBookmarksHistory(searchQuery);
                });
              } else {}
            } else {
              // Handle the case when the search field is empty
            }
          },
          suffixIcon: _isTextFieldEmpty.sync(
            builder: (context, isEmpty, child) {
              return isEmpty
                  ? const SizedBox
                      .shrink() // Hide the suffix icon if the text is empty
                  : IconButton(
                      icon: PhosphorIcons.bold.x.iconslide(size: 20.sp),
                      onPressed: () {
                        _bookmarksSearchFieldController.clear();
                        // Update the ValueNotifier when the text is cleared
                        _isTextFieldEmpty.value = true;
                      },
                    );
            },
          ),
          onIconTap: () {
            _bookmarksSearchFieldController.clear();
            // Update the ValueNotifier when the text is cleared via the icon
            _isTextFieldEmpty.value = true;
          },
          prefixIcon: PhosphorIcons.regular.magnifyingGlass.iconslide(
            size: 26.sp,
            color: Palette.blackColor,
          ),
        ),
      ),
      body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ViNewsAppImagesPath.appBackgroundImage,
              ),
              opacity: 0.15,
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
                child: Padding(
              padding: 25.0.padA,
              child: Column(
                children: [
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: 5.padV,
                      itemCount: bookmarksSearchHistoryList.length > 5
                          ? 5
                          : bookmarksSearchHistoryList
                              .length, // Limit to 5 items
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: 10.padV,
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 15.w),
                                decoration: BoxDecoration(
                                    color: Palette.whiteColor.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(15.r)),
                                child: GestureDetector(
                                  onTap: () {
                                    dropKeyboard();
                                    context.pushNamed(
                                        ViNewsAppRouteConstants
                                            .userBookmarksSearchResultsRouteName,
                                        pathParameters: {
                                          "searchedWord":
                                              bookmarksSearchHistoryList[index]
                                        });
                                  },
                                  child: Row(
                                    children: [
                                      PhosphorIcons.bold.clockCounterClockwise
                                          .iconslide(
                                              size: 25.sp,
                                              color: Palette.blackColor),
                                      10.sbW,
                                      Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 200.w),
                                        child: bookmarksSearchHistoryList[index]
                                            .txtStyled(
                                                fontSize: 16.sp,
                                                textOverflow:
                                                    TextOverflow.ellipsis),
                                      ),
                                      const Spacer(),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              _bookmarksSearchFieldController
                                                      .text =
                                                  bookmarksSearchHistoryList[
                                                      index];
                                              _isTextFieldEmpty.value = false;
                                            },
                                            icon: PhosphorIcons
                                                .bold.arrowUpRight
                                                .iconslide(
                                                    size: 25.sp,
                                                    color: Palette.blackColor),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              ref
                                                  .read(
                                                      bookmarksSearchHistoryProvider
                                                          .notifier)
                                                  .removeFromBookmarksHistory(
                                                      bookmarksSearchHistoryList[
                                                          index]);
                                            },
                                            icon: PhosphorIcons.bold.x
                                                .iconslide(
                                                    size: 25.sp,
                                                    color: Palette.blackColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )));
                      }),
                ],
              ),
            )),
          )),
    );
  }
}
