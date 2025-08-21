import 'package:flutter/material.dart';
import 'package:rasa/core/theme/color_app.dart';

class DetailItems extends StatelessWidget {
  DetailItems({
    super.key,
    this.isShowTitle = true,
    required this.data,
    this.title,
    this.color = blackColor,
    TextStyle? textStyle,
    this.isShowIcon = false,
    this.iconImage,
  }) : textStyle = textStyle ??
            greyTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w400);

  final bool isShowTitle;
  final bool isShowIcon;
  final String data;
  final String? title;
  final Color color;
  final TextStyle textStyle;
  final String? iconImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isShowTitle) ...[
          Text(
            title!,
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: bold,
            ),
          ),
          SizedBox(height: 9),
        ],
        Container(
          height: 37,
          // width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: whiteColor,
            border: Border.all(color: color.withValues(alpha: 0.69), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              if (isShowIcon) ...[
                ImageIcon(
                  AssetImage(iconImage!),
                  color: greyColor.withValues(alpha: 70),
                ),
              ],
              SizedBox(width: 8),
              Text(
                data,
                style: textStyle,
              ),
            ],
          ),
        )
      ],
    );
  }
}
