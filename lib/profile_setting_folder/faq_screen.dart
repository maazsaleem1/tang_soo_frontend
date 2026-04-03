import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tang_soo_karate/controllers/faq_controller.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_appbar.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  static const _tag = 'faq';

  int _expandedIndex = 0;

  @override
  void initState() {
    super.initState();
    Get.put(FaqController(), tag: _tag);
  }

  @override
  void dispose() {
    Get.delete<FaqController>(tag: _tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<FaqController>(tag: _tag);

    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      appBar: CustomAppBar(
        title: 'FAQs',
        textType: TextType.font16600,
        showBack: true,
        onPress: () {
          Get.back();
        },
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const _FaqLoadingShimmer();
        }

        if (c.errorMessage.value != null && c.errorMessage.value!.isNotEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  styledText(
                    'Could not load FAQs',
                    TextType.font16500,
                    color: AppColors.appbarTitleColor,
                  ),
                  12.verticalSpace,
                  styledText(
                    c.errorMessage.value!,
                    TextType.font12400,
                    color: AppColors.newtextcolor,
                    maxLines: 4,
                  ),
                  20.verticalSpace,
                  TextButton(
                    onPressed: () => c.loadFaqs(),
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

        if (c.items.isEmpty) {
          return Center(
            child: styledText(
              'No FAQs available yet.',
              TextType.font14500,
              color: AppColors.newtextcolor,
            ),
          );
        }

        final list = c.items;
        final expandedIdx =
            _expandedIndex < 0 || _expandedIndex >= list.length
                ? 0
                : _expandedIndex;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              styledText('Frequently Asked Questions', TextType.font20700),
              18.verticalSpace,
              ...List.generate(list.length, (index) {
                final item = list[index];
                final isExpanded = expandedIdx == index;
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _faqTile(
                    question: item.question,
                    answer: item.answer,
                    isExpanded: isExpanded,
                    onTap: () {
                      setState(() {
                        _expandedIndex = isExpanded ? -1 : index;
                      });
                    },
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget _faqTile({
    required String question,
    required String answer,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: const Color(0xFFE2E2E2)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: styledText(
                    question,
                    TextType.font14500,
                    color: const Color(0xFF333333),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFF8A8A8A),
                  size: 22.sp,
                ),
              ],
            ),
            if (isExpanded && answer.isNotEmpty) ...[
              10.verticalSpace,
              styledText(
                answer,
                TextType.font14400,
                color: const Color(0xFF7F7F7F),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Skeleton layout matching FAQ tiles while [FaqController] loads.
class _FaqLoadingShimmer extends StatelessWidget {
  const _FaqLoadingShimmer();

  static const _base = Color(0xFFE6E6E6);
  static const _highlight = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
      child: Shimmer.fromColors(
        baseColor: _base,
        highlightColor: _highlight,
        period: const Duration(milliseconds: 1300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bar(width: 0.65.sw, height: 22.h, radius: 6.r),
            18.verticalSpace,
            ...List.generate(7, (i) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _shimmerTile(i),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _bar({
    required double width,
    required double height,
    double radius = 8,
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

  /// Vary widths slightly so rows don’t look identical.
  Widget _shimmerTile(int index) {
    final w = 0.92.sw - (index % 3) * 12.w;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bar(width: w, height: 13.h, radius: 6.r),
                8.verticalSpace,
                _bar(width: w * 0.72, height: 13.h, radius: 6.r),
              ],
            ),
          ),
          8.horizontalSpace,
          Container(
            width: 22.w,
            height: 22.w,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }
}
