import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/model/event.dart';
import 'package:kyodai_board/model/event_bookmark.dart';
import 'package:kyodai_board/repo/user_repo.dart';
import 'package:kyodai_board/view/components/atom/async_image.dart';

class EventCard extends HookWidget{
  const EventCard({
    this.event,
    this.onTap,
  });

  final Event event;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final bookmarks = useProvider(bookmarkEventProvider);

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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AsyncImage(
                        imageUrl: event.imageUrl,
                        fit: BoxFit.cover,
                      ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.club.name,
                                    style: Theme.of(context).textTheme.caption.copyWith(
                                        fontSize: 11,
                                      ),
                                  ),
                                  Text(
                                    event.title,
                                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            bookmarks.when(
                              loading: () => const Icon(Icons.bookmark_border),
                              error: (dynamic _, __) => const Icon(Icons.bookmark_border),
                              data: (bookmarks) {
                                final isBookmarked = bookmarks.containsClubAndEventId(event.id, event.clubId);
                                return InkWell(
                                  onTap: () => isBookmarked ? unbookmarkEvent(bookmarks.getWithEventId(event.id)) : bookmarkEvent(event.id, event.clubId),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 3, left: 8),
                                    child: Icon(
                                      isBookmarked ?? false ? Icons.bookmark : Icons.bookmark_border,
                                      color: isBookmarked ?? false ? Colors.cyan[600] : Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
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
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 13,
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}