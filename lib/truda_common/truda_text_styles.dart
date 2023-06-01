import 'package:flutter/material.dart';
import 'package:truda/truda_common/truda_colors.dart';

class TrudaTextStyles extends TextStyle {
  // Color? color;
  // TextDecoration? decoration;
  // Color? decorationColor;
  // double? decorationThickness;
  // FontWeight? fontWeight;
  // FontStyle? fontStyle;
  // double? fontSize;
  // double? height;

  const TrudaTextStyles.black16({
    Color? color = TrudaColors.textColor000,
    double? fontSize = 16,
    FontWeight? fontWeight,
  }) : super(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        );

  const TrudaTextStyles.black14({
    Color? color = TrudaColors.textColor000,
    double? fontSize = 14,
    FontWeight? fontWeight,
  }) : super(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        );

  const TrudaTextStyles.gray16({
    Color? color = TrudaColors.textColor999,
    double? fontSize = 16,
    FontWeight? fontWeight,
  }) : super(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        );

  const TrudaTextStyles.gray14({
    Color? color = TrudaColors.textColor999,
    double? fontSize = 14,
    FontWeight? fontWeight,
  }) : super(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        );
}
