import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';
import 'package:tang_soo_karate/res/svgsicon.dart';

class _PaymentEntry {
  final String title;
  final String amount;
  final String date;

  const _PaymentEntry({
    required this.title,
    required this.amount,
    required this.date,
  });
}

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  static const List<_PaymentEntry> _entries = [
    _PaymentEntry(
      title: "White Belt",
      amount: "\$4.99",
      date: "01 Feb 2026",
    ),
    _PaymentEntry(
      title: "Yellow Belt",
      amount: "\$5.99",
      date: "01 Feb 2026",
    ),
  ];

  static const Color _mutedGrey = Color(0xFF8A8A8A);
  static const Color _successGreen = Color(0xFF3CB471);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundcolour,
        surfaceTintColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Get.back(),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: SvgPicture.asset(SvgIcons.backicon, fit: BoxFit.scaleDown),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: styledText(
                  "Settings",
                  TextType.font14500,
                  color: const Color(0xFF6E6E6E),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              styledText(
                "Your Payment History",
                TextType.font20700,
                color: AppColors.appbarTitleColor,
              ),
              22.verticalSpace,
              ..._buildList(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildList() {
    final out = <Widget>[];
    for (var i = 0; i < _entries.length; i++) {
      final e = _entries[i];
      out.add(_paymentTile(e));
      if (i < _entries.length - 1) {
        out.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Divider(
              height: 1,
              thickness: 1,
              color: const Color(0xFFE5E5E5),
            ),
          ),
        );
      }
    }
    return out;
  }

  Widget _paymentTile(_PaymentEntry e) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              styledText(
                e.title,
                TextType.minifont16600hard,
                color: AppColors.appbarTitleColor,
              ),
              8.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  styledText(
                    "Price: ",
                    TextType.font14500,
                    color: _mutedGrey,
                  ),
                  styledText(
                    e.amount,
                    TextType.font14500,
                    color: AppColors.buttoncolour,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              6.verticalSpace,
              styledText(
                "Date: ${e.date}",
                TextType.font12400,
                color: _mutedGrey,
              ),
            ],
          ),
        ),
        12.horizontalSpace,
        Container(
          width: 26.w,
          height: 26.w,
          decoration: BoxDecoration(
            color: _successGreen,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 18.sp,
          ),
        ),
      ],
    );
  }
}
