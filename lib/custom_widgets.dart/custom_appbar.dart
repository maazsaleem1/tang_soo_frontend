import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';
import 'package:tang_soo_karate/res/svgsicon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextType textType;
  final bool showBack;
  final VoidCallback? onPress;
  final VoidCallback? ondrawericon;
  final VoidCallback? onActionImageOnTap;
  final VoidCallback? buttonOnTap;
  final bool neednotificationicon;
  final Color? iconColor;
  final double horizontalPadding;
  final double? paddingFromRightInAction;
  final String? actionImage;
  final bool ifYouWantTapDown;
  final bool ifYouWantAppButton;
  final bool isYouWantOtherThingAgainstText;
  final void Function(TapDownDetails)? onThreeDotsOnTap;

  const CustomAppBar({
    super.key,
    required this.title,
    this.isYouWantOtherThingAgainstText = false,
    this.actionImage,
    this.textType = TextType.xlarge,
    this.showBack = true,
    this.neednotificationicon = false,
    this.onPress,
    this.ondrawericon,
    this.horizontalPadding = 10,
    this.buttonOnTap,
    this.onActionImageOnTap,
    this.paddingFromRightInAction,
    this.iconColor,
    this.onThreeDotsOnTap,
    this.ifYouWantTapDown = false,
    this.ifYouWantAppButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          showBack
              ? GestureDetector(
                onTap: onPress ?? () => Navigator.of(context).pop(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: SvgPicture.asset(
                    SvgIcons.backicon,
                    fit: BoxFit.scaleDown,
                    color: iconColor,
                  ),
                ),
              )
              : GestureDetector(
                onTap: ondrawericon,
                child: SvgPicture.asset(
                  "assets/images/drawericon.svg",
                  fit: BoxFit.scaleDown,
                ),
              ),
      backgroundColor: AppColors.backgroundcolour,
      centerTitle: true,
      title:
          isYouWantOtherThingAgainstText
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    child: Image.asset("assets/images/profileimage.png"),
                  ),
                  5.horizontalSpace,
                  styledText(
                    title,
                    textType,

                    color: AppColors.appbarTitleColor,
                  ),
                ],
              )
              : styledText(title, textType, color: AppColors.appbarTitleColor),

      actions: [
        if (neednotificationicon && actionImage != null)
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Get.to(() => const NotificationScreen());
                  },
                  child: badges.Badge(
                    badgeContent: const Text(
                      "3",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    position: badges.BadgePosition.topEnd(top: -5, end: 0),
                    child: SvgPicture.asset(actionImage!),
                  ),
                ),
              ],
            ),
          )
        else if (!neednotificationicon && actionImage != null)
          ifYouWantTapDown
              ? GestureDetector(
                onTapDown: onThreeDotsOnTap,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: paddingFromRightInAction ?? 0.0,
                  ),
                  child: SvgPicture.asset(actionImage!),
                ),
              )
              : GestureDetector(
                onTap: onActionImageOnTap,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: paddingFromRightInAction ?? 0.0,
                  ),
                  child: SvgPicture.asset(actionImage!),
                ),
              )
        else if (!neednotificationicon && ifYouWantAppButton)
          Padding(
            padding: EdgeInsets.only(right: paddingFromRightInAction ?? 0.0),
            child: GestureDetector(
              onTap: buttonOnTap,
              child: Container(
                height: 26.h,
                width: 55.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.backgroundcolourpie,
                ),
                child: Center(child: styledText("Post", TextType.medium)),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
