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
}) {
  switch (type) {
    case TextType.xlarge:
      fontSize = 24;
      fontWeight = FontWeight.w600;
      break;
    case TextType.font20700:
      fontSize = 20;
      fontWeight = FontWeight.w700;
      break;
    case TextType.large:
      fontSize = 17;
      fontWeight = FontWeight.w500;
      break;
    case TextType.font18:
      fontSize = 18;
      fontWeight = FontWeight.w600;
      break;
    case TextType.font15500:
      fontSize = 15;
      fontWeight = FontWeight.w500;
      break;
    case TextType.font16400:
      fontSize = 16;
      fontWeight = FontWeight.w400;
      break;
    case TextType.font16500:
      fontSize = 16;
      fontWeight = FontWeight.w500;
      break;
    case TextType.font16600:
      fontSize = 16;
      fontWeight = FontWeight.w600;
      break;
    case TextType.font16700:
      fontSize = 16;
      fontWeight = FontWeight.w600;
      break;
    case TextType.minifont16600hard:
      fontSize = 14;
      fontWeight = FontWeight.w700;
      break;
    case TextType.font14400:
      fontSize = 14;
      fontWeight = FontWeight.w400;
      break;
    case TextType.font14500:
      fontSize = 14;
      fontWeight = FontWeight.w500;
      break;
    case TextType.font14600:
      fontSize = 14;
      fontWeight = FontWeight.w600;
      break;
    case TextType.font14300:
      fontSize = 14;
      fontWeight = FontWeight.w300;
      break;
    case TextType.minismall:
      fontSize = 12;
      fontWeight = FontWeight.w500;
      break;
    case TextType.font12400:
      fontSize = 12;
      fontWeight = FontWeight.w400;
      break;
    case TextType.font12700:
      fontSize = 12;
      fontWeight = FontWeight.w700;
      break;
    case TextType.font10:
      fontSize = 10;
      fontWeight = FontWeight.w400;
      break;
  }

  final textStyle = GoogleFonts.inter(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    decoration: textDecoration ?? TextDecoration.none,
    decorationColor: textDecorationColor ?? Colors.transparent,
  );

  return Text(text, style: textStyle, textAlign: textAlign, overflow: overflow);
}
