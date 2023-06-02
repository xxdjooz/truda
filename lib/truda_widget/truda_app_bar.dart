import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';

class TrudaAppBar extends AppBar {
  TrudaAppBar({
    Key? key,
    Widget? title,
    Widget? leading,
    double? leadingWidth,
    bool? centerTitle,
    List<Widget>? actions,
    Color? backgroundColor,
    PreferredSizeWidget? bottom,
    SystemUiOverlayStyle? systemOverlayStyle,
    TextStyle? titleTextStyle,
    double? titleSpacing,
  }) : super(
          key: key,
          backgroundColor: backgroundColor ?? Colors.transparent,
          elevation: 0,
          title: title,
          leading: leading ??
              GestureDetector(
                onTap: () => Navigator.maybePop(Get.context!),
                child: Container(
                  padding: const EdgeInsetsDirectional.only(start: 15),
                  alignment: AlignmentDirectional.centerStart,
                  child: Image.asset(
                    'assets/images/newhita_base_back.png',
                    matchTextDirection: true,
                  ),
                ),
              ),
          leadingWidth: leadingWidth ?? 80,
          actions: actions,
          bottom: bottom,
          titleTextStyle: titleTextStyle ??
              const TextStyle(
                fontSize: 18,
                color: TrudaColors.textColor333,
                fontWeight: FontWeight.bold,
              ),
          centerTitle: centerTitle ?? true,
          foregroundColor: TrudaColors.textColor333,
          systemOverlayStyle: systemOverlayStyle,
          titleSpacing: titleSpacing,
        );
}
