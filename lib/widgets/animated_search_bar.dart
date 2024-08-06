import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/core/providers/app_providers.dart';
import 'package:vinews_news_reader/features/bookmarks/controllers/bookmarks_controllers.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/utils/keyboard_utils.dart';
import 'package:vinews_news_reader/utils/size_constraints_defs.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class AnimatedSearchField extends ConsumerStatefulWidget {
  final TextEditingController textFieldController;
  final FocusNode fieldFocusNode;
  final bool overlayActive;
  final void Function(String)? onChanged;
  final Function()? onEditingComplete;
  final void Function()? onSuffixIconTap;
  const AnimatedSearchField(
      {super.key,
      this.onSuffixIconTap,
      this.onEditingComplete,
      this.onChanged,
      required this.overlayActive,
      required this.fieldFocusNode,
      required this.textFieldController});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AnimatedSearchFieldState();
}

class _AnimatedSearchFieldState extends ConsumerState<AnimatedSearchField>
    with SingleTickerProviderStateMixin {
  late AnimationController _con;
  final ValueNotifier<bool> inactiveExpansion = true.notifier;

  @override
  void initState() {
    super.initState();
    _con = AnimationController(
      vsync: this,
      duration: 400.milliseconds,
    );
  }

  @override
  void dispose() {
    inactiveExpansion.dispose();
    _con.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return inactiveExpansion.sync(
      builder: (BuildContext context, bool expansionTrigger, Widget? child) {
        return AnimatedContainer(
          duration: 400.milliseconds,
          height: 55.h,
          width: expansionTrigger ? 50.w : width(context),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: expansionTrigger
                ? Palette.whiteColor.withOpacity(0.0)
                : Palette.whiteColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: 400.milliseconds,
                top: 6.0,
                right: 7.0,
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  opacity: expansionTrigger ? 0.0 : 1.0,
                  duration: 250.milliseconds,
                  child: Container(
                    padding: 6.0.padA,
                    decoration: BoxDecoration(
                      color: Palette.whiteColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: AnimatedBuilder(
                      builder: (context, widget) {
                        return Transform.rotate(
                          angle: _con.value * 2.0 * pi,
                          child: widget,
                        );
                      },
                      animation: _con,
                      child: PhosphorIconsBold.x
                          .iconslide(
                            size: 18.sp,
                            color: Palette.blackColor,
                          )
                          .inkTap(
                              splashColor:
                                  Palette.darkerGreyColor.withOpacity(0.2),
                              onTap: widget.onSuffixIconTap),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: 400.milliseconds,
                left: expansionTrigger ? 20.0 : 40.0,
                curve: Curves.easeOut,
                top: 11.0,
                child: AnimatedOpacity(
                  opacity: expansionTrigger ? 0.0 : 1.0,
                  duration: 250.milliseconds,
                  child: SizedBox(
                    height: 25.h,
                    width: 280.w,
                    child: TextField(
                      focusNode: widget.fieldFocusNode,
                      controller: widget.textFieldController,
                      onChanged: widget.onChanged,
                      onEditingComplete: widget.onEditingComplete,
                      cursorRadius: Radius.circular(10.r),
                      cursorWidth: 2.0,
                      cursorColor: Palette.blackColor,
                      decoration: InputDecoration(
                        contentPadding: 3.0.padV,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Search Bookmarks...',
                        labelStyle: TextStyle(
                          color: Palette.blackColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Material(
                color: Palette.whiteColor.withOpacity(0.0),
                borderRadius: BorderRadius.circular(30.r),
                child: IconButton(
                  splashRadius: 10.r,
                  icon: PhosphorIconsBold.magnifyingGlass.iconslide(
                      color: expansionTrigger
                          ? Palette.whiteColor
                          : Palette.blackColor),
                  onPressed: widget.overlayActive
                  ? (){}
                  : () {
                    inactiveExpansion.value = !inactiveExpansion.value;
                    if (expansionTrigger) {
                      _con.reverse();
                    } else {
                      _con.forward();
                    }
                    ref
                        .read(bookmarksQueryStringProvider.notifier)
                        .updateQueryString("");
                    ref
                        .read(animatedBarOpenProvider.notifier)
                        .update((state) => !state);
                    dropKeyboard();
                    widget.textFieldController.clear();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
