// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';

class CustomSliverAppBar extends StatelessWidget {
  final double? appBarToolbarheight;
  final double? appBarCollapsedHeight;
  final double? expandedHeight; //Used
  final bool isPinned; //Used
  final bool canStretch; //Used
  final bool isFloating;
  final Color appBarColor; //Used
  final Widget? expandedSliverSpaceBackground; //Used
  final Widget? leadingWidget;
  final VoidCallback? leadingTapAction;
  final bool customizeLeadingWidget;
  final Color? leadingIconColor;
  final IconData? customLeadingIcon;
  final bool? isLeadingAnIcon;
  final bool showLeadingIconOrWidget;
  final bool? titleCentered;
  final bool? isTitleText;
  final Widget? titleWidget;
  final String? title; //Used
  final double? titleFontSize; //Used
  final FontWeight? titleFontWeight; //Used
  final Color? titleFontColor;
  final List<Widget>? actions; //Used
  final PreferredSizeWidget? sliverBottom; //Used

  const CustomSliverAppBar({
    Key? key,
    this.appBarToolbarheight,
    this.appBarCollapsedHeight,
    this.expandedHeight,
    required this.isPinned,
    required this.canStretch,
    required this.isFloating,
    required this.appBarColor,
    this.expandedSliverSpaceBackground,
    this.leadingWidget,
    this.leadingTapAction,
    required this.customizeLeadingWidget,
    this.leadingIconColor,
    this.customLeadingIcon,
    this.isLeadingAnIcon,
    required this.showLeadingIconOrWidget,
    this.titleCentered = false,
    this.isTitleText = false,
    this.titleWidget,
    this.title,
    this.titleFontSize,
    this.titleFontWeight,
    this.titleFontColor,
    this.actions,
    this.sliverBottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: appBarToolbarheight ?? kToolbarHeight,
        collapsedHeight: appBarCollapsedHeight,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: showLeadingIconOrWidget,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        expandedHeight: expandedHeight,
        backgroundColor: appBarColor,
        elevation: 0.0,
        titleSpacing: 0,
        centerTitle: titleCentered,
        title: isTitleText == true
            ? Text(
                title ?? "",
                style: TextStyle(
                  fontSize: titleFontSize ?? 22.sp,
                  color: titleFontColor ?? Palette.blackColor,
                  fontWeight: titleFontWeight,
                ),
              )
            : titleWidget,
        actions: actions ?? const [SizedBox.shrink()],
        pinned: isPinned,
        stretch: canStretch,
        floating: isFloating,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: expandedSliverSpaceBackground ??
              Container(
                height: expandedHeight,
              ),
          stretchModes: const [
            StretchMode.blurBackground,
            StretchMode.zoomBackground,
          ],
        ),
        bottom: sliverBottom,
        leadingWidth: titleCentered == false ? 60 : null,
        leading: showLeadingIconOrWidget
            ? customizeLeadingWidget
                ? isLeadingAnIcon ?? true
                    ? IconButton(
                        onPressed: () => leadingTapAction!(),
                        icon: Icon(
                          customLeadingIcon ?? Icons.close,
                          color: leadingIconColor ?? Palette.blackColor,
                        ))
                    : GestureDetector(
                        onTap: leadingTapAction ?? () {}, child: leadingWidget)
                : null
            : null);
  }
}
