import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

enum TextType {
  xlarge,
  large,
  font16600,
  font16700,
  minifont16600hard,
  font14400,
  font14500,
  minismall,
  font18,
  font15500,
  font16400,
  font14300,
  font12400,
  font10,
  font16500,
  font12700,
  font14600,
  font20700,
}

Text styledText(
  String text,
  TextType type, {
  Color color = AppColors.appbarTitleColor,
  TextAlign textAlign = TextAlign.start,
  TextOverflow? overflow,
  FontWeight? fontWeight,
  double? fontSize,
  TextDecoration? textDecoration,
  Color? textDecorationColor,
  int? maxLines,
}) {
  late double resolvedFontSize;
  late FontWeight resolvedFontWeight;
  switch (type) {
    case TextType.xlarge:
      resolvedFontSize = 24;
      resolvedFontWeight = FontWeight.w600;
      break;
    case TextType.font20700:
      resolvedFontSize = 20;
      resolvedFontWeight = FontWeight.w700;
      break;
    case TextType.large:
      resolvedFontSize = 17;
      resolvedFontWeight = FontWeight.w500;
      break;
    case TextType.font18:
      resolvedFontSize = 18;
      resolvedFontWeight = FontWeight.w600;
      break;
    case TextType.font15500:
      resolvedFontSize = 15;
      resolvedFontWeight = FontWeight.w500;
      break;
    case TextType.font16400:
      resolvedFontSize = 16;
      resolvedFontWeight = FontWeight.w400;
      break;
    case TextType.font16500:
      resolvedFontSize = 16;
      resolvedFontWeight = FontWeight.w500;
      break;
    case TextType.font16600:
      resolvedFontSize = 16;
      resolvedFontWeight = FontWeight.w600;
      break;
    case TextType.font16700:
      resolvedFontSize = 16;
      resolvedFontWeight = FontWeight.w600;
      break;
    case TextType.minifont16600hard:
      resolvedFontSize = 14;
      resolvedFontWeight = FontWeight.w700;
      break;
    case TextType.font14400:
      resolvedFontSize = 14;
      resolvedFontWeight = FontWeight.w400;
      break;
    case TextType.font14500:
      resolvedFontSize = 14;
      resolvedFontWeight = FontWeight.w500;
      break;
    case TextType.font14600:
      resolvedFontSize = 14;
      resolvedFontWeight = FontWeight.w600;
      break;
    case TextType.font14300:
      resolvedFontSize = 14;
      resolvedFontWeight = FontWeight.w300;
      break;
    case TextType.minismall:
      resolvedFontSize = 12;
      resolvedFontWeight = FontWeight.w500;
      break;
    case TextType.font12400:
      resolvedFontSize = 12;
      resolvedFontWeight = FontWeight.w400;
      break;
    case TextType.font12700:
      resolvedFontSize = 12;
      resolvedFontWeight = FontWeight.w700;
      break;
    case TextType.font10:
      resolvedFontSize = 10;
      resolvedFontWeight = FontWeight.w400;
      break;
  }
  if (fontSize != null) resolvedFontSize = fontSize;
  if (fontWeight != null) resolvedFontWeight = fontWeight;

  final textStyle = GoogleFonts.inter(
    fontSize: resolvedFontSize,
    fontWeight: resolvedFontWeight,
    color: color,
    decoration: textDecoration ?? TextDecoration.none,
    decorationColor: textDecorationColor ?? Colors.transparent,
  );

  return Text(
    text,
    style: textStyle,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
  );
}
