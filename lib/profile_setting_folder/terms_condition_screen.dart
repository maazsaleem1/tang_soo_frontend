import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tang_soo_karate/controllers/terms_condition_controller.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_appbar.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({super.key});

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  static const _tag = 'terms_condition';

  @override
  void initState() {
    super.initState();
    Get.put(TermsConditionController(), tag: _tag);
  }

  @override
  void dispose() {
    Get.delete<TermsConditionController>(tag: _tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TermsConditionController>(tag: _tag);
    final bodyGrey = const Color(0xFF8A8A8A);

    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      appBar: CustomAppBar(
        title: 'Terms & Condition',
        textType: TextType.font16600,
        showBack: true,
        onPress: () => Get.back(),
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const _TermsLoadingShimmer();
        }

        if (c.errorMessage.value != null && c.errorMessage.value!.isNotEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  styledText(
                    'Could not load terms',
                    TextType.font16500,
                    color: AppColors.appbarTitleColor,
                  ),
                  12.verticalSpace,
                  styledText(
                    c.errorMessage.value!,
                    TextType.font12400,
                    color: AppColors.newtextcolor,
                    maxLines: 5,
                  ),
                  20.verticalSpace,
                  TextButton(
                    onPressed: () => c.load(),
                    child: styledText(
                      'Retry',
                      TextType.font14500,
                      color: const Color(0xFF1E4C9F),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final html = c.page.value?.content ?? '';
        if (html.isEmpty) {
          return Center(
            child: styledText(
              'No content available.',
              TextType.font14500,
              color: AppColors.newtextcolor,
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              styledText('Terms & Condition', TextType.font20700),
              14.verticalSpace,
              Html(
                data: html,
                style: {
                  'body': Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                  ),
                  'div': Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                  ),
                  'p': Style(
                    fontSize: FontSize(14.sp),
                    color: bodyGrey,
                    lineHeight: const LineHeight(1.55),
                    margin: Margins.only(bottom: 10.h),
                  ),
                  'h1': Style(
                    fontSize: FontSize(18.sp),
                    fontWeight: FontWeight.w600,
                    color: AppColors.appbarTitleColor,
                  ),
                  'h2': Style(
                    fontSize: FontSize(16.sp),
                    fontWeight: FontWeight.w600,
                    color: AppColors.appbarTitleColor,
                  ),
                  'h3': Style(
                    fontSize: FontSize(15.sp),
                    fontWeight: FontWeight.w600,
                    color: AppColors.appbarTitleColor,
                  ),
                  'a': Style(
                    color: const Color(0xFF1E4C9F),
                  ),
                  'ul': Style(
                    margin: Margins.only(left: 16.w, bottom: 8.h),
                  ),
                  'ol': Style(
                    margin: Margins.only(left: 16.w, bottom: 8.h),
                  ),
                  'li': Style(
                    fontSize: FontSize(14.sp),
                    color: bodyGrey,
                    lineHeight: const LineHeight(1.5),
                  ),
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _TermsLoadingShimmer extends StatelessWidget {
  const _TermsLoadingShimmer();

  static const _base = Color(0xFFE6E6E6);
  static const _highlight = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      child: Shimmer.fromColors(
        baseColor: _base,
        highlightColor: _highlight,
        period: const Duration(milliseconds: 1300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bar(width: 0.55.sw, height: 24.h, radius: 8.r),
            14.verticalSpace,
            ...List.generate(6, (i) {
              final w = 1.0 - (i % 3) * 0.04;
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _bar(
                  width: w.sw,
                  height: 13.h,
                  radius: 6.r,
                ),
              );
            }),
            8.verticalSpace,
            _bar(width: 0.88.sw, height: 13.h, radius: 6.r),
            10.verticalSpace,
            _bar(width: 0.75.sw, height: 13.h, radius: 6.r),
            10.verticalSpace,
            _bar(width: 0.92.sw, height: 13.h, radius: 6.r),
          ],
        ),
      ),
    );
  }

  Widget _bar({
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
