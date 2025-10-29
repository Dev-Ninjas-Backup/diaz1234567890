import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:diaz1234567890/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final RxBool? toggleValue;
  final VoidCallback? onToggle;
  final VoidCallback onTap;
  const SettingsButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.toggleValue,
    this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.profileButtonColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.black, size: 24),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getTextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
                Text(
                  subtitle,
                  style: getTextStyle(
                    color: AppColors.subTitle,
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            Spacer(),
            if (toggleValue != null)
              Obx(
                () => GestureDetector(
                  onTap: onToggle,
                  child: Container(
                    width: 35,
                    height: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: toggleValue!.value
                          ? Color(0xFF006EF0)
                          : AppColors.subTitle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: toggleValue!.value
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: toggleValue!.value ? Colors.white : Colors.black,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
