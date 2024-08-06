import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/utils/banner_util.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

// News Article View

class NewsArticleReadView extends ConsumerStatefulWidget {
  final String articleImage;
  final String articleSource;
  final String articleTitle;
  final String articleAuthor;
  final String articlePublicationDate;
  final String articleContent;
  final String heroTag;

  const NewsArticleReadView(
      {super.key,
      required this.articleImage,
      required this.articleSource,
      required this.articleTitle,
      required this.articleAuthor,
      required this.articlePublicationDate,
      required this.articleContent,
      required this.heroTag});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewsArticleReadViewState();
}

class _NewsArticleReadViewState extends ConsumerState<NewsArticleReadView> {
  final ValueNotifier<bool> likeIconChangeNotifer = false.notifier;
  final ValueNotifier<bool> bookmarkIconChangeNotifer = false.notifier;

  @override
  void dispose() {
    likeIconChangeNotifer.dispose();
    bookmarkIconChangeNotifer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        thickness: 6,
        radius: Radius.circular(12.r),
        // Nested Scrollview for slivers (innerBoxIsScrolled) controls action buttonz and title visibility
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                leading: PhosphorIconsBold.arrowLeft
                    .iconslide(size: 28.sp, color: Palette.whiteColor)
                    .inkTap(onTap: () => context.pop()),
                toolbarHeight: 90.h,
                stretch: true,
                backgroundColor: Palette.blackColor,
                elevation: 0,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft:
                        Radius.circular(30.r), // Adjust the radius as needed
                    bottomRight:
                        Radius.circular(30.r), // Adjust the radius as needed
                  ),
                ),
                // collapsedHeight: 90.h, //AppBar height
                actions: [
                  Visibility(
                    visible: innerBoxIsScrolled, // Do not show when scrolled
                    maintainState:
                        true, // Preserve the state of the child widget
                    maintainAnimation: true, // Preserve animations
                    maintainSize: true, // Preserve size and layout
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: innerBoxIsScrolled
                          ? 1
                          : 0, // Fade in when not scrolled
                      child: Padding(
                        padding: const EdgeInsets.only().padSpec(right: 30),
                        child: Row(
                          children: [
                            likeIconChangeNotifer.sync(
                                builder: (context, isIconTapped, child) {
                              return GestureDetector(
                                  onTap: () => likeIconChangeNotifer.value =
                                      !likeIconChangeNotifer.value,
                                  child: isIconTapped
                                      ? PhosphorIconsFill.heartStraight
                                          .iconslide(
                                              size: 30.sp,
                                              color: Palette.redColor)
                                      : PhosphorIconsRegular.heartStraight
                                          .iconslide(
                                              size: 30.sp,
                                              color: Palette.whiteColor));
                            }),
                            15.sbW,
                            bookmarkIconChangeNotifer.sync(
                                builder: (context, isIconTapped, child) {
                              return GestureDetector(
                                onTap: () {
                                  bookmarkIconChangeNotifer.value =
                                      !bookmarkIconChangeNotifer.value;
                                  showBookmarkToast(
                                      context, "Added to Bookmarks");
                                },
                                child: isIconTapped
                                    ? PhosphorIconsFill.bookmarksSimple
                                        .iconslide(
                                            size: 30.sp,
                                            color: Palette.greenColor)
                                    : PhosphorIconsRegular.bookmarksSimple
                                        .iconslide(
                                            size: 30.sp,
                                            color: Palette.whiteColor),
                              );
                            }),
                            15.sbW,
                            PhosphorIconsRegular.share.iconslide(
                                size: 30.sp, color: Palette.whiteColor)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
                expandedHeight: 400.h,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // double top = constraints.biggest.height;
                    return FlexibleSpaceBar(
                      titlePadding: EdgeInsets.symmetric(
                          horizontal: 65.w, vertical: 30.h),
                      title: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: innerBoxIsScrolled ? 1 : 0,
                          // top == MediaQuery.of(context).padding.top + 90.h
                          //     ? 0
                          //     : 1.0,
                          child: SizedBox(
                            width: 170.w,
                            child: widget.articleSource.txtStyled(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                textOverflow: TextOverflow.ellipsis),
                          )),
                      stretchModes: const [StretchMode.blurBackground],
                      centerTitle: false,
                      // News Article Image
                      background: Hero(
                          tag: widget.heroTag,
                          child: CachedNetworkImage(
                            key: UniqueKey(),
                            imageUrl: widget.articleImage,
                            fit: BoxFit.cover,
                          )),
                    );
                  },
                ),
                pinned: true,
              ),
            ];
          },
          body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ViNewsAppImagesPath.appBackgroundImage),
                opacity: 0.15,
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
                physics: const BouncingScrollPhysics(),
                // Content Column holder
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      30.sbH,
                      // Article Title
                      Padding(
                        padding: 25.padH,
                        child: widget.articleTitle.txtStyled(
                            fontSize: 30.sp, fontWeight: FontWeight.w800),
                      ),
                      30.sbH,
                      // Article Credentials, Author, Date Posted, Article read time.
                      Padding(
                        padding: 25.padH,
                        child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      PhosphorIconsRegular.notePencil
                                          .iconslide(size: 19.sp),
                                      5.sbW,
                                      SizedBox(
                                        width: 300.w,
                                        child: "Author: ${widget.articleAuthor}"
                                            .txtStyled(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w600,
                                                textOverflow:
                                                    TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                  7.sbH,
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      PhosphorIconsRegular.paperPlaneTilt
                                          .iconslide(size: 19.sp),
                                      5.sbW,
                                      "Posted: ${widget.articlePublicationDate}"
                                          .txtStyled(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w500),
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                      ),
                      30.sbH,
                      Padding(
                        padding: 25.padH,
                        child: const Divider(
                          color: Palette.blackColor,
                          thickness: 1,
                        ),
                      ),
                      30.sbH,
                      // Article Content
                      Padding(
                        padding: 25.padH,
                        child: widget.articleContent
                            .txtStyled(fontSize: 18.sp),
                      ),
                      500.sbH
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
