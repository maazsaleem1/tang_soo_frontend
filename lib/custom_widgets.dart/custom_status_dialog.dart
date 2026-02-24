import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';

Future<void> showCustomStatusDialog({
  required BuildContext context,
  required String message,
  String iconPath = "assets/images/tickicon.svg",
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Container(
          width: 1.sw,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE9E9E9)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(iconPath, width: 56.w, height: 56.w),
              14.verticalSpace,
              styledText(
                message,
                TextType.font16600,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    },
  );
}
