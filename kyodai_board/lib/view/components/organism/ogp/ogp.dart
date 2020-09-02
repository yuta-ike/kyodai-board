import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/utils/get_metadata.dart';
import 'package:kyodai_board/view/components/atom/async_image.dart';
import 'package:url_launcher/url_launcher.dart';

class Ogp extends HookWidget{
  const Ogp(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    final data = useFuture(getMetadata(url));

    return Card(
      elevation: 0.5,
      child: InkWell(
        onTap: _launchUrl,
        child: Row(
          children: [
            AsyncImage(
              imageUrl: data.data?.image ?? '',
              height: 100,
              width: 100,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.data?.title ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    data.data?.description ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    url,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ]
              ),
            )
          ]
        ),
      ),
    );
  }

  void _launchUrl() async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}