import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AsyncImage extends StatelessWidget{
  const AsyncImage({
    @required this.imageUrl,
    this.placeholderUrl = 'https://placehold.it/350x150',
    this.errorImageUrl = 'https://placehold.it/350x150',
    this.placeholderWidget,
    this.errorWidget,
    this.imageBuilder,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.colorBlendMode,
  }): assert(placeholderWidget == null && placeholderUrl != null
              || placeholderWidget != null && placeholderUrl == null,
        '[placeholderWidget]と[placeholderUrl]のどちらか一方を（のみ）指定する必要があります');

  final String imageUrl, placeholderUrl, errorImageUrl;
  final Widget placeholderWidget, errorWidget;
  final Widget Function(BuildContext, ImageProvider<dynamic>) imageBuilder;
  final double height, width;
  final BoxFit fit;
  final Color color;
  final BlendMode colorBlendMode;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: imageBuilder,
      placeholder: (context, url) => _buildPlaceholder(context),
      errorWidget: (context, url, dynamic _) => _buildErrorWidget(context),
      height: height,
      width: width,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
    );
  }

  Widget _buildPlaceholder(BuildContext context){
    if(placeholderWidget != null){
      return placeholderWidget;
    }
    if(imageBuilder != null){
      return imageBuilder(context, NetworkImage(placeholderUrl));
    }
    return Image.network(placeholderUrl);
  }

    Widget _buildErrorWidget(BuildContext context){
    if(errorWidget != null){
      return errorWidget;
    }
    if(imageBuilder != null){
      return imageBuilder(context, NetworkImage(errorImageUrl));
    }
    return Image.network(errorImageUrl);
  }
  
}