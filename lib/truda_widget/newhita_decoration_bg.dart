import 'package:flutter/material.dart';
import 'package:truda/truda_common/truda_colors.dart';

class NewHitaDecorationBg extends BoxDecoration {
  const NewHitaDecorationBg({Color? color})
      : super(
            color: color ?? TrudaColors.baseColorBlackBg,
            image: const DecorationImage(
                image: AssetImage('assets/images/newhita_me_bg.png'),
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth),
            border: const BorderDirectional(
              bottom: BorderSide(
                  color: Colors.white24, width: 0.5, style: BorderStyle.solid),
            ));
}
