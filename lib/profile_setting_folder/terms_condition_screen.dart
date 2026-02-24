import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_appbar.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      appBar: CustomAppBar(
        title: "Terms & Condition",
        textType: TextType.font16600,
        showBack: true,
        onPress: () {
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            styledText("Terms & Condition", TextType.font20700),
            14.verticalSpace,
            styledText(
              "Lorem ipsum dolor sit amet consectetur. Sem purus non pellentesque faucibus ultrices maecenas mauris pretium vel. Pellentesque sit cursus interdum aenean sed vulputate. Sit tincidunt arcu scelerisque in in. At proin velit porttitor urna leo eleifend.",
              TextType.font14400,
              color: const Color(0xFF8A8A8A),
            ),
            10.verticalSpace,
            styledText(
              "Lorem ipsum dolor sit amet consectetur. Sem purus non pellentesque faucibus ultrices maecenas mauris pretium vel. Pellentesque sit cursus interdum aenean sed vulputate. Sit tincidunt arcu scelerisque in in. At proin velit porttitor urna leo eleifend.",
              TextType.font14400,
              color: const Color(0xFF8A8A8A),
            ),
            10.verticalSpace,
            styledText(
              "Lorem ipsum dolor sit amet consectetur. Sem purus non pellentesque faucibus ultrices maecenas mauris pretium vel. Pellentesque sit cursus interdum aenean sed vulputate. Sit tincidunt arcu scelerisque in in. At proin velit porttitor urna leo eleifend.",
              TextType.font14400,
              color: const Color(0xFF8A8A8A),
            ),
            10.verticalSpace,
            styledText(
              "Lorem ipsum dolor sit amet consectetur. Sem purus non pellentesque faucibus ultrices maecenas mauris pretium vel. Pellentesque sit cursus interdum aenean sed vulputate. Sit tincidunt arcu scelerisque in in. At proin velit porttitor urna leo eleifend.",
              TextType.font14400,
              color: const Color(0xFF8A8A8A),
            ),
          ],
        ),
      ),
    );
  }
}
