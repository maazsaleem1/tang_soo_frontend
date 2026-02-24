import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_appbar.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int _expandedIndex = 0;

  final List<Map<String, String>> _faqs = const [
    {
      "question": "How do belt-level payments work?",
      "answer":
          "Lorem ipsum dolor sit amet consectetur.\nOrnare sit imperdiet sit urna.",
    },
    {
      "question": "Can I access lessons offline?",
      "answer":
          "Lorem ipsum dolor sit amet consectetur.\nOrnare sit imperdiet sit urna.",
    },
    {
      "question": "How do I unlock the next belt?",
      "answer":
          "Lorem ipsum dolor sit amet consectetur.\nOrnare sit imperdiet sit urna.",
    },
    {
      "question": "What happens if a payment fails?",
      "answer":
          "Lorem ipsum dolor sit amet consectetur.\nOrnare sit imperdiet sit urna.",
    },
    {
      "question": "Can I cancel my subscription?",
      "answer":
          "Lorem ipsum dolor sit amet consectetur.\nOrnare sit imperdiet sit urna.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      appBar: CustomAppBar(
        title: "FAQs",
        textType: TextType.font16600,
        showBack: true,
        onPress: () {
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            styledText("Frequently Asked Questions", TextType.font20700),
            18.verticalSpace,
            ...List.generate(_faqs.length, (index) {
              final item = _faqs[index];
              final isExpanded = _expandedIndex == index;
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _faqTile(
                  question: item["question"] ?? "",
                  answer: item["answer"] ?? "",
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
      ),
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
