import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// 网络加载图片
class TrudaNetImage extends CachedNetworkImage {
  TrudaNetImage(
    String imageUrl, {
    Key? key,
    String? placeholderAsset,
    ImageWidgetBuilder? imageBuilder,
    PlaceholderWidgetBuilder? placeholder,
    LoadingErrorWidgetBuilder? errorWidget,
    BoxFit? fit,
    double? width,
    double? height,
    //圆角
    double? radius,
    // 圆形
    bool isCircle = false,
    double? borderWidth,
  }) : super(
            key: key,
            imageUrl: imageUrl,
            // 圆形处理
            imageBuilder: imageBuilder ?? (radius != null
                    ? (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(radius),
                          ),
                        )
                    : isCircle
                        ? (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                border: borderWidth == null
                                    ? null
                                    : Border.all(
                                        color: Colors.white,
                                        width: borderWidth),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                                shape: BoxShape.circle,
                              ),
                            )
                        : imageBuilder),
            placeholder: placeholder ??
                (context, url) {
                  return ClipRRect(
                    borderRadius: isCircle
                        ? BorderRadius.circular(200)
                        : BorderRadius.circular(radius ?? 0),
                    child: Image.asset(
                      (placeholderAsset != null && placeholderAsset.isNotEmpty)
                          ? placeholderAsset
                          : 'assets/images_sized/newhita_base_avatar.webp',
                      fit: BoxFit.cover,
                    ),
                  );
                },
            errorWidget: errorWidget ??
                (context, url, error) {
                  return ClipRRect(
                    borderRadius: isCircle
                        ? BorderRadius.circular(200)
                        : BorderRadius.circular(radius ?? 0),
                    child: Image.asset(
                      (placeholderAsset != null && placeholderAsset.isNotEmpty)
                          ? placeholderAsset
                          : 'assets/images_sized/newhita_base_avatar.webp',
                      fit: BoxFit.cover,
                    ),
                  );
                },
            fit: fit ?? BoxFit.cover,
            width: width,
            height: height);
}
