import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    this.onPress,
    this.backgroundColor = AppColors.buttoncolour,
    this.buttonLoader = false,
    this.textColor = Colors.white,
    this.horizontalMargin = 0,
    this.texthorizontalMargin = 20,
    this.verticalMargin = 18,
    this.height = 52,
    this.minWidth = 390.0, // Set the minimum width
    this.borderColor,
    super.key,
    this.fontsize = 16,
    this.loadersize = 20.0,
    this.textalignment = TextAlign.center,
    this.fontweight = FontWeight.w600,
    this.loadercolour = Colors.white,
    this.widthifyouneedthebuttontextinstart,
  });

  final VoidCallback? onPress;
  final String text;
  final TextAlign textalignment;
  final Color? backgroundColor;
  final Color? textColor;
  final bool? buttonLoader;
  final double? horizontalMargin;
  final double? widthifyouneedthebuttontextinstart;
  final double? texthorizontalMargin;
  final double? verticalMargin;
  final double height;
  final double minWidth; // Minimum width property
  final Color? borderColor;
  final int fontsize;
  final FontWeight fontweight;
  final Color loadercolour;
  final double loadersize;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin!),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: backgroundColor,
              backgroundColor: backgroundColor,
              disabledForegroundColor: textColor,
              foregroundColor: textColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: borderColor ?? Colors.transparent),
                borderRadius: BorderRadius.circular(100.r),
              ),
              textStyle: GoogleFonts.inter(
                color: textColor!,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              padding: EdgeInsets.zero,
              elevation: 0,
              minimumSize: Size(minWidth == 0 ? 0 : minWidth, height),
              maximumSize: Size(double.infinity, height),
              splashFactory: NoSplash.splashFactory,
              overlayColor: Colors.transparent,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
            ),

            onPressed: buttonLoader! ? null : onPress,
            child: SizedBox(
              height: height,
              child: Center(
                child:
                    buttonLoader!
                        ? SpinKitFadingCircle(
                          color: loadercolour,
                          size: loadersize,
                        )
                        : Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: texthorizontalMargin!,
                          ),
                          child: styledText(
                            text,
                            TextType.font16500,
                            color: textColor!,
                          ),
                        ),
              ),
            ),
          );
        },
      ),
    );
  }
}
