import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_appbar.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

/// Plan card backgrounds by list index: 0 → Level 1, 1 → Level 2, 2 → Level 3.
const List<String> kSubscriptionPlanCardBackgrounds = [
  'assets/images/image1.png',
  'assets/images/image2.png',
  'assets/images/image3.png',
];

class _PlanData {
  const _PlanData({
    required this.level,
    required this.title,
    required this.features,
    required this.ctaColor,
  });

  final int level;
  final String title;
  final List<String> features;
  final Color ctaColor;
}

class PurchasePlanScreen extends StatefulWidget {
  const PurchasePlanScreen({super.key});

  @override
  State<PurchasePlanScreen> createState() => _PurchasePlanScreenState();
}

class _PurchasePlanScreenState extends State<PurchasePlanScreen> {
  bool _isMonthly = true;

  static const Color _coralCta = Color(0xFFFF5247);
  static const Color _level2Cta = Color(0xFF00C1BC);
  static const Color _level3Cta = Color(0xFF005C87);
  static const Color _checkGreen = Color(0xFF3CB471);
  static const Color _lessonHeading = Color(0xFF9E9E9E);
  static const Color _featureGrey = Color(0xFF6A6A6A);

  List<_PlanData> _plansForBilling() {
    return [
      _PlanData(
        level: 1,
        title: 'Level 1 - White to Red Belt',
        features: const [
          'Foundations & Intro',
          'White Belt',
          'Yellow & Orange Progression',
          'Green Belt',
          'Red Belt',
          'Cho Dan Bo / Pre-Black Belt Prep',
          'Weapons Introduction',
        ],
        ctaColor: _coralCta,
      ),
      _PlanData(
        level: 2,
        title: 'Level 2 - Black Belt',
        features: const [
          '1st Dan Curriculum',
          '2nd Dan Curriculum',
          '3rd Dan Curriculum',
          'Master Wellness Series',
        ],
        ctaColor: _level2Cta,
      ),
      _PlanData(
        level: 3,
        title: 'Level 3 - Master',
        features: const [
          'Everything in Black Belt',
          'Master Level Techniques',
          'Teaching Methodology',
          'Dojo Management Tips',
          'Exclusive Master Classes',
        ],
        ctaColor: _level3Cta,
      ),
    ];
  }

  String _priceForLevel(int level) {
    if (_isMonthly) {
      switch (level) {
        case 1:
          return '\$4.99';
        case 2:
          return '\$5.99';
        case 3:
        default:
          return '\$6.99';
      }
    }
    switch (level) {
      case 1:
        return '\$59.88';
      case 2:
        return '\$71.88';
      case 3:
      default:
        return '\$83.88';
    }
  }

  @override
  Widget build(BuildContext context) {
    final durationLabel = _isMonthly ? '/month' : '/year';
    final plans = _plansForBilling();

    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      appBar: CustomAppBar(
        title: 'Purchase Plan',
        textType: TextType.font16600,
        neednotificationicon: true,
        actionImage: 'assets/images/notificationicon.svg',
        onPress: () => Get.back(),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              styledText(
                'Choose Your Training Journey',
                TextType.font20700,
                color: AppColors.appbarTitleColor,
              ),
              14.verticalSpace,
              _billingToggle(),
              14.verticalSpace,
              ...plans.asMap().entries.map((entry) {
                final index = entry.key;
                final plan = entry.value;
                return Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: _SubscriptionPlanCard(
                    backgroundAsset:
                        kSubscriptionPlanCardBackgrounds[index.clamp(
                          0,
                          kSubscriptionPlanCardBackgrounds.length - 1,
                        )],
                    title: plan.title,
                    amount: _priceForLevel(plan.level),
                    durationLabel: durationLabel,
                    features: plan.features,
                    ctaLabel: 'Unlock level ${plan.level}',
                    ctaColor: plan.ctaColor,
                    checkColor: _checkGreen,
                    lessonHeadingColor: _lessonHeading,
                    featureTextColor: _featureGrey,
                    onUnlock: () {},
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _billingToggle() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isMonthly = true),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color:
                      _isMonthly ? const Color(0xFFD6E4E9) : Colors.transparent,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Center(
                  child: styledText(
                    'Monthly',
                    TextType.font16500,
                    color:
                        _isMonthly
                            ? AppColors.buttoncolour
                            : const Color(0xFFB2B2B2),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isMonthly = false),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color:
                      !_isMonthly
                          ? const Color(0xFFD6E4E9)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Center(
                  child: styledText(
                    'Yearly',
                    TextType.font16500,
                    color:
                        !_isMonthly
                            ? AppColors.buttoncolour
                            : const Color(0xFFB2B2B2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionPlanCard extends StatelessWidget {
  const _SubscriptionPlanCard({
    required this.backgroundAsset,
    required this.title,
    required this.amount,
    required this.durationLabel,
    required this.features,
    required this.ctaLabel,
    required this.ctaColor,
    required this.checkColor,
    required this.lessonHeadingColor,
    required this.featureTextColor,
    required this.onUnlock,
  });

  final String backgroundAsset;
  final String title;
  final String amount;
  final String durationLabel;
  final List<String> features;
  final String ctaLabel;
  final Color ctaColor;
  final Color checkColor;
  final Color lessonHeadingColor;
  final Color featureTextColor;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: SizedBox(
          height: 400.h,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                backgroundAsset,
                fit: BoxFit.cover,
                // width: double.infinity,
                // height: double.infinity,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 104.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          styledText(
                            title,
                            TextType.font16500,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          10.verticalSpace,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                amount,
                                style: GoogleFonts.inter(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.05,
                                ),
                              ),
                              Text(
                                ' $durationLabel',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            styledText(
                              'Lessons Included:',
                              TextType.font12400,
                              color: lessonHeadingColor,
                            ),
                            8.verticalSpace,
                            ...features.map(
                              (line) => Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 16.sp,
                                      color: checkColor,
                                    ),
                                    8.horizontalSpace,
                                    Expanded(
                                      child: styledText(
                                        line,
                                        TextType.font12400,
                                        color: featureTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            20.verticalSpace,
                            AppButton(
                              text: ctaLabel,
                              textColor: AppColors.whiteColor,
                              backgroundColor: ctaColor,
                              onPress: onUnlock,
                              minWidth: 0,
                              horizontalMargin: 0,
                              height: 48,
                              verticalMargin: 0,
                              fontsize: 15,
                              fontweight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
