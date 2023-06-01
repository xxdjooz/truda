import 'package:flutter/material.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_widget/newhita_net_image.dart';

class NewHitaAvatarWithBg extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final double? padding;
  final bool? isVip;

  final String? placeholderAsset;

  const NewHitaAvatarWithBg({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.padding,
    this.placeholderAsset,
    this.isVip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double insert = width == null ? 5 : width! / 15;
    return SizedBox(
      width: width,
      height: height,
      child: NewHitaNetImage(
        url,
        isCircle: true,
        placeholderAsset: placeholderAsset,
        imageBuilder: (context, provider) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: isVip == true
                    ? EdgeInsets.all(insert)
                    : null,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: provider,
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              if (isVip == true)
              Positioned(
                top: -insert,
                left: -insert,
                right: -insert,
                bottom: -insert,
                child: Image.asset(
                  'assets/images_ani/newhita_me_vip.webp',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
