import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/model/event.dart';
import 'package:kyodai_board/view/components/atom/async_image.dart';

class EventCard extends HookWidget{
  const EventCard({
    this.event,
    this.onTap,
  });

  final EventBase event;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: AsyncImage(
                      imageUrl: event.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.title),
                        Text(event.hostName),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              color: Colors.cyan,
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                              child: Text(
                                '初心者歓迎',
                                style: Theme.of(context).textTheme.caption.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event.description,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]
                    ),
                  ),
                ),
              ],
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.grey[100],
                
            //   ),
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       Row(
            //         children: [
            //           IconButton(
            //             icon: const Icon(Icons.share),
            //             onPressed: () => print('share'),
            //           ),
            //           IconButton(
            //             icon: const Icon(Icons.bookmark_border),
            //             onPressed: () => print('bookmark'),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}