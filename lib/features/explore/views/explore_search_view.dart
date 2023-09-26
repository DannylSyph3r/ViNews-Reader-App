import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/features/explore/controllers/explore_controllers.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/keyboard_utils.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';
import 'package:vinews_news_reader/widgets/vinews_search_text_fields.dart';

class ExploreScreenSearchView extends ConsumerStatefulWidget {
  const ExploreScreenSearchView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExploreScreenSearchViewState();
}

class _ExploreScreenSearchViewState
    extends ConsumerState<ExploreScreenSearchView> {
  final _exploreSearchFieldController = TextEditingController();
  final ValueNotifier<bool> _isTextFieldEmpty = true.notifier;

  // Dispose Explore Search Bar Controller
  @override
  void dispose() {
    _exploreSearchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> exploreSearchHistoryList =
        ref.watch(exploreSearchHistoryProvider);
    final String queryString = ref.watch(queryStringProvider);
    final List<String> filteredList = exploreSearchHistoryList
        .where((item) => item.toLowerCase().contains(queryString.toLowerCase()))
        .toList();
    return WillPopScope(
      onWillPop: () async {
        await Future.delayed(200.milliseconds, () {
          ref.read(queryStringProvider.notifier).updateQueryString("");
        });
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90.h,
          backgroundColor: Pallete.blackColor,
          // The search area here
          title: ViNewsSearchTextField(
            textfieldHeight: 65.h,
            controller: _exploreSearchFieldController,
            hintText: "What do you want to search for?",
            obscureText: false,
            onChanged: (value) {
              // Update the ValueNotifier when the text changes
              _isTextFieldEmpty.value = value.isEmpty;
              final String searchQuery = value.trim();
              ref
                  .read(queryStringProvider.notifier)
                  .updateQueryString(searchQuery);
            },
            onEditingComplete: () {
              if (queryString.isNotEmpty) {
                dropKeyboard();
                context.pushNamed(
                  ViNewsAppRouteConstants.userExploreSearchResultsRouteName,
                  pathParameters: {
                    "searchedWord": queryString,
                  },
                );
                if (!exploreSearchHistoryList.contains(queryString)) {
                  Future.delayed(500.milliseconds, () {
                    ref
                        .read(exploreSearchHistoryProvider.notifier)
                        .addToExploreHistory(queryString);
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
                          _exploreSearchFieldController.clear();
                          // Update the ValueNotifier when the text is cleared
                          _isTextFieldEmpty.value = true;
                          ref
                              .read(queryStringProvider.notifier)
                              .updateQueryString("");
                        },
                      );
              },
            ),
            onIconTap: () {
              _exploreSearchFieldController.clear();
              // Update the ValueNotifier when the text is cleared via the icon
              _isTextFieldEmpty.value = true;
            },
            prefixIcon: PhosphorIcons.regular.magnifyingGlass.iconslide(
              size: 26.sp,
              color: Pallete.blackColor,
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
            child: GestureDetector(
              onTap: () => dropKeyboard(),
              child: SingleChildScrollView(
                child: Center(
                    child: Padding(
                  padding: 25.0.padA,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: 5.padV,
                      itemCount: filteredList.length > 5
                          ? 5
                          : filteredList.length, // Limit to 5 items
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: 10.padV,
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 15.w),
                                decoration: BoxDecoration(
                                    color:
                                        Pallete.whiteColor.withOpacity(0.3),
                                    borderRadius:
                                        BorderRadius.circular(15.r)),
                                child: GestureDetector(
                                  onTap: () {
                                    dropKeyboard();
                                    context.pushNamed(
                                        ViNewsAppRouteConstants
                                            .userExploreSearchResultsRouteName,
                                        pathParameters: {
                                          "searchedWord": filteredList[index]
                                        });
                                  },
                                  child: Row(
                                    children: [
                                      PhosphorIcons.bold.clockCounterClockwise
                                          .iconslide(
                                              size: 25.sp,
                                              color: Pallete.blackColor),
                                      10.sbW,
                                      Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 200.w),
                                        child: filteredList[index].txtStyled(
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
                                              _exploreSearchFieldController
                                                  .text = filteredList[index];
                                              _isTextFieldEmpty.value = false;
                                              ref
                                                  .read(queryStringProvider
                                                      .notifier)
                                                  .updateQueryString(
                                                      filteredList[index]);
                                            },
                                            icon: PhosphorIcons
                                                .bold.arrowUpRight
                                                .iconslide(
                                                    size: 25.sp,
                                                    color:
                                                        Pallete.blackColor),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              final itemToDelete =
                                                  filteredList[index];
                                              ref
                                                  .read(
                                                      exploreSearchHistoryProvider
                                                          .notifier)
                                                  .removeFromExploreHistory(
                                                      itemToDelete);
                                            },
                                            icon: PhosphorIcons.bold.x
                                                .iconslide(
                                                    size: 25.sp,
                                                    color:
                                                        Pallete.blackColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )));
                      }),
                )),
              ),
            )),
      ),
    );
  }
}
