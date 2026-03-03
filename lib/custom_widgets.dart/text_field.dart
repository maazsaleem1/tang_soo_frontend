import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class AppInput extends StatelessWidget {
  const AppInput({
    required this.placeHolder,
    this.error = '',
    this.label = '',
    this.keyboardType,
    this.controller,
    this.showPasswordIcon = false,
    this.onTap,
    this.obscureText = false,
    this.isAutoValidate = false,
    this.validator,
    this.enabled,
    this.horizontalMargin = 0,
    this.bottomMargin = 20,
    this.verticalPadding = 10,
    this.maxLines = 1,
    this.maxLenght = 100,
    this.prefixIcon,
    this.postfixIcon,
    this.onChanged,
    this.onEnventSumbit,
    this.textarea = true,
    this.backColor = AppColors.whiteColor,
    this.inputWidth,
    this.fontsize = 14,
    this.readonly = false,
    this.isCounterText = false,
    this.isAutoFocus = false,
    this.borderradius = 100,
    this.enabledborderradius = 100,
    this.errorborderradius = 100,
    this.focusedErrorBorder = 100,
    this.borderColor = AppColors.bordercolour,
    this.hinttylecolor = AppColors.hintstylecolour,
    this.focusnode,
    super.key,
  });

  final String placeHolder;
  final String? label;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final bool? showPasswordIcon;
  final VoidCallback? onTap;
  final bool? obscureText;
  final bool readonly;
  final bool isAutoValidate;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onEnventSumbit;
  final bool? enabled;
  final double? horizontalMargin;
  final double? fontsize;
  final double? bottomMargin;
  final double? verticalPadding;
  final double? borderradius;
  final double? enabledborderradius;
  final double? errorborderradius;
  final double? focusedErrorBorder;
  final double? inputWidth;
  final int? maxLines;
  final int? maxLenght;
  final Widget? prefixIcon;
  final Widget? postfixIcon;
  final String error;
  final bool textarea;
  final Color? backColor;
  final bool isCounterText;
  final bool isAutoFocus;
  final Color? borderColor;
  final Color? hinttylecolor;
  final FocusNode? focusnode;

  @override
  Widget build(BuildContext context) {
    final customInputDecoration = InputDecoration(
      prefixIcon: prefixIcon,
      counterText: isCounterText ? null : '',
      filled: true,
      fillColor: backColor,
      hintText: placeHolder,
      iconColor: const Color(0xFFD4DDE5),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: verticalPadding!,
      ),
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor!),
        borderRadius: BorderRadius.circular(borderradius!.r),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor!),
        borderRadius: BorderRadius.circular(enabledborderradius!.r),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(errorborderradius!.r),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(focusedErrorBorder!.r),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.r),
      ),
      hintStyle: GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 13.sp,
        color: hinttylecolor,
      ),

      suffixIcon:
          showPasswordIcon!
              ? InkWell(
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5.sp, 5.sp, 2.sp, 5.sp),
                  child:
                      obscureText!
                          ? const Icon(
                            Icons.remove_red_eye_outlined,
                            color: AppColors.hintstylecolour,
                          )
                          : const Icon(
                            FontAwesomeIcons.eyeSlash,
                            size: 18,
                            color: AppColors.hintstylecolour,
                          ),
                ),
              )
              : postfixIcon,
      errorText: error.isEmpty ? null : error,
      errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
      counterStyle: TextStyle(fontSize: 12.sp, color: Colors.white),
    );

    return Container(
      width: inputWidth,
      margin: EdgeInsets.fromLTRB(
        horizontalMargin!,
        0,
        horizontalMargin!,
        bottomMargin!,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label! == '')
            Container()
          else
            Container(
              margin: const EdgeInsets.only(left: 0),
              child: styledText(label!, TextType.font16500),
            ),
          8.verticalSpace,
          TextFormField(
            readOnly: readonly,
            onFieldSubmitted: onEnventSumbit,
            autofocus: isAutoFocus,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w300,
              fontSize: 14.sp,
              color: AppColors.appbarTitleColor,
            ),
            keyboardType: keyboardType,
            controller: controller,
            onChanged: onChanged,
            decoration: customInputDecoration,
            obscureText: obscureText!,
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            enabled: enabled,
            maxLines: maxLines,
            maxLength: maxLenght,
            focusNode: focusnode,
          ),
        ],
      ),
    );
  }
}
