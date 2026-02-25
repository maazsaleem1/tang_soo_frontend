import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/controllers/navbar_controller.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/homescreenfolder/home_screen.dart';
import 'package:tang_soo_karate/notificationfolder/notification_screen.dart';
import 'package:tang_soo_karate/profile_setting_folder/profile_Setting.dart';
import 'package:tang_soo_karate/progressfolder/progress_screen.dart';
import 'package:tang_soo_karate/res/app_colours.dart';
import 'package:tang_soo_karate/trainingfolder/trainingscreen.dart';

class NavBarScreen extends StatefulWidget {
  final int initialIndex;
  const NavBarScreen({super.key, this.initialIndex = 0});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final bottomController = Get.put(NavBarController());

  @override
  void initState() {
    super.initState();
    bottomController.itemSelect(widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    var screens = [
      HomeScreen(),
      ProgressScreen(),
      Trainingscreen(),
      Profilescreen(),
    ];
    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: false,
        key: _key,
        appBar: getAppBar(bottomController.count.value),
        bottomNavigationBar: bottomNavbar(bottomController),
        body: screens[bottomController.count.value],
      );
    });
  }

  AppBar getAppBar(int index) {
    String title;
    switch (index) {
      case 0:
        title = 'Welcome john';
        break;
      case 1:
        title = 'Progress';
        break;
      case 2:
        title = 'Training';
        break;
      case 3:
        title = 'Profile';
        break;
      default:
        title = '';
    }

    return AppBar(
      surfaceTintColor: AppColors.backgroundcolour,
      elevation: 0,
      backgroundColor: AppColors.backgroundcolour,
      // leading: GestureDetector(
      //   onTap: () => _key.currentState!.openDrawer(),
      //   child: Padding(
      //     padding: EdgeInsets.only(left: 15.w),
      //     child: SvgPicture.asset("assets/images/drawericon.svg", height: 40),
      //   ),
      // ),
      title: styledText(title, TextType.font18),

      // Text(
      //   title,
      //   style: interFont(
      //     fontsize: 18,
      //     fontweight: FontWeight.w600,
      //     color: Appcolors.textsecondary,
      //   ),
      // ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 15.w),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => const NotificationScreen());
                },
                child: badges.Badge(
                  showBadge: true,
                  badgeContent: Text(
                    "3",
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  position: badges.BadgePosition.topEnd(top: -8, end: 0),
                  child: SvgPicture.asset(
                    "assets/images/notificationicon.svg",
                    height: 25.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget bottomNavbar(NavBarController bottomcontroller) {
  return Container(
    height: 88.h,
    width: 1.sw,
    color: AppColors.whiteColor,
    child: Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          navBarItem(
            index: 0,
            controller: bottomcontroller,
            selectedIcon: "assets/images/selectedhomescreen.svg",
            unselectedIcon: "assets/images/homeunselectedicon.svg",
            label: "Home",
          ),
          navBarItem(
            index: 1,
            controller: bottomcontroller,
            selectedIcon: "assets/images/progressselectedicon.svg",
            unselectedIcon: "assets/images/progressunselectedicon.svg",
            label: "Progress",
          ),
          navBarItem(
            index: 2,
            controller: bottomcontroller,
            selectedIcon: "assets/images/trainigselectedicon.svg",
            unselectedIcon: "assets/images/trainingunselectedicon.svg",
            label: "Training",
          ),
          navBarItem(
            index: 3,
            controller: bottomcontroller,
            selectedIcon: "assets/images/profileselectedicon.svg",
            unselectedIcon: "assets/images/profileunselectedicon.svg",
            label: "Profile",
          ),
        ],
      );
    }),
  );
}

Widget navBarItem({
  required int index,
  required NavBarController controller,
  required String selectedIcon,
  required String unselectedIcon,
  required String label,
}) {
  bool isSelected = controller.count.value == index;

  return GestureDetector(
    onTap: () {
      controller.itemSelect(index);
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(isSelected ? selectedIcon : unselectedIcon),
        SizedBox(height: isSelected ? 5.h : 5.h),

        styledText(
          label,
          TextType.font14600,
          color: isSelected ? Color(0xff1E4C9F) : Color(0xffC4C4C4),
        ),
        // AppText(
        //   text: label,
        //   fontSize: 10.sp,
        //   fontWeight: FontWeight.w500,
        //   color: Appcolors.textsecondary,
        // ),
      ],
    ),
  );
}
