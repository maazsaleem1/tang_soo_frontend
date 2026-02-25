import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_appbar.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<_NotificationItem> _items = [
    _NotificationItem(
      title: "Payment Successful",
      subtitle: "Your White Belt has been unlocked successfully.",
      time: "2 hours ago",
      isUnread: true,
      groupHeader: "",
    ),
    _NotificationItem(
      title: "New Lesson Available",
      subtitle: "A new lesson has been added to White Belt training.",
      time: "3 days ago",
      isUnread: true,
      groupHeader: "",
    ),
    _NotificationItem(
      title: "Belt Completed 🎉",
      subtitle: "You've completed all White Belt lessons.",
      time: "1 week ago",
      isUnread: false,
      groupHeader: "7 days ago",
    ),
    _NotificationItem(
      title: "Password Updated",
      subtitle: "Your password was changed successfully.",
      time: "2 weeks ago",
      isUnread: false,
      groupHeader: "",
    ),
  ];

  void _markAllAsRead() {
    setState(() {
      for (final item in _items) {
        item.isUnread = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      appBar: CustomAppBar(
        title: "Notifications",
        textType: TextType.font16600,
        showBack: true,
        onPress: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _markAllAsRead,
                  child: styledText(
                    "Mark All as Read",
                    TextType.font12400,
                    color: AppColors.buttoncolour,
                    textDecoration: TextDecoration.underline,
                    textDecorationColor: AppColors.buttoncolour,
                  ),
                ),
              ),
              8.verticalSpace,
              Expanded(
                child: ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder:
                      (_, __) => Divider(color: const Color(0xFFE2E2E2)),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.groupHeader.isNotEmpty) ...[
                          styledText(item.groupHeader, TextType.font14500),
                          10.verticalSpace,
                        ],
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  styledText(item.title, TextType.font16600),
                                  4.verticalSpace,
                                  styledText(
                                    item.subtitle,
                                    TextType.font12400,
                                    color: const Color(0xFF666666),
                                  ),
                                  8.verticalSpace,
                                  styledText(
                                    item.time,
                                    TextType.font14500,
                                    color: const Color(0xFF8A8A8A),
                                  ),
                                ],
                              ),
                            ),
                            8.horizontalSpace,
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  item.isUnread = !item.isUnread;
                                });
                              },
                              child: Container(
                                width: 10.w,
                                height: 10.w,
                                margin: EdgeInsets.only(top: 6.h),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      item.isUnread
                                          ? const Color(0xFF2DAAE1)
                                          : Colors.transparent,
                                  border: Border.all(
                                    color: const Color(0xFFCFCFCF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationItem {
  final String title;
  final String subtitle;
  final String time;
  final String groupHeader;
  bool isUnread;

  _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.groupHeader,
    required this.isUnread,
  });
}
