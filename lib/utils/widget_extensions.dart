import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//Image Assets extension for cleaner code
extension ImageAssetExtension on String {
  Widget imageAsset({
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) {
    return Image.asset(
      this,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }
}

//Sized box extension (num) for cleaner code coupled with "flutter_screenutils" package
extension WidgetExtensionss on num {
  Widget get sbH => SizedBox(
        height: h,
      );

  Widget get sbW => SizedBox(
        width: w,
      );
  
  //Padding extension for cleaner code (num)
  EdgeInsetsGeometry get padV => EdgeInsets.symmetric(vertical: h);

  EdgeInsetsGeometry get padH => EdgeInsets.symmetric(horizontal: w);
}

//Sized box extension (double) for cleaner code coupled with "flutter_screenutils" package
extension WidgetExtensions on double {
  Widget get sbH => SizedBox(
        height: h,
      );

  Widget get sbW => SizedBox(
        width: w,
      );
  
  //Padding extension for cleaner code (num)
  
  EdgeInsetsGeometry get padA => EdgeInsets.all(this);

  EdgeInsetsGeometry get padV => EdgeInsets.symmetric(vertical: h);

  EdgeInsetsGeometry get padH => EdgeInsets.symmetric(horizontal: w);
  
}

//BoxDecoration extension for cleaner code
extension BoxDecorationExtensions on BoxDecoration {
  BoxDecoration withBorderRadius(BorderRadius borderRadius) {
    return copyWith(borderRadius: borderRadius);
  }

  BoxDecoration withShape(BoxShape shape) {
    return copyWith(shape: shape);
  }

  BoxDecoration withColor(Color color) {
    return copyWith(color: color);
  }
}

extension InkWellExtension on Widget {
  Widget onTap(VoidCallback onTapCallback) {
    return InkWell(
      onTap: onTapCallback,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: this, // 'this' refers to the Widget that the extension is called on
    );
  }
}

//Text Extensions
extension StyledTextExtension on String {
  Text txtStyled({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? textOverflow,
    TextDecoration? textDecoration,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontSize: fontSize ?? 14,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: textDecoration,
      ),
    );
  }
}

extension CustomIcon on IconData {
  Widget iconslide({double? size, Color? color}) {
    return Icon(
      this, 
      size: size, 
      color: color);
  }
}

extension EdgeInsetsExtension on EdgeInsets {
  EdgeInsetsGeometry padSpec({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: ScreenUtil().setWidth(left.toInt()),
      top: ScreenUtil().setHeight(top.toInt()),
      right: ScreenUtil().setWidth(right.toInt()),
      bottom: ScreenUtil().setHeight(bottom.toInt()),
    );
  }
}

// Duration Extension
extension DurationExtension on int {
  Duration get milliseconds => Duration(milliseconds: this);
  Duration get seconds => Duration(seconds: this);
  Duration get minutes => Duration(minutes: this);
  Duration get hours => Duration(hours: this);
  Duration get days => Duration(days: this);
}


// Create a value notifier directly from an assigned value.
extension ValueNotifierExtension<T> on T {
  ValueNotifier<T> get notifier {
    return ValueNotifier<T>(this);
  }
}

// Value Listenable Builder Extension
extension ValueNotifierBuilderExtension<T> on ValueNotifier<T> {
  Widget sync({
    required Widget Function(BuildContext context, T value, Widget? child)
        builder,
  }) {
    return ValueListenableBuilder<T>(
      valueListenable: this,
      builder: builder,
    );
  }
}

