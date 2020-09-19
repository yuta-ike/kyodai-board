import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/model/event.dart';
import 'package:kyodai_board/repo/user_repo.dart';
import 'package:kyodai_board/view/components/atom/async_image.dart';
import 'package:kyodai_board/utils/date_extension.dart';
import 'package:kyodai_board/view/components/atom/text_with_icon.dart';

class ScheduleCard extends HookWidget{
  const ScheduleCard({
    this.schedule,
    this.onTap,
    this.isBookmarked,
    this.bookmark,
  });

  final Schedule schedule;
  final void Function() onTap;
  final bool isBookmarked;
  final void Function() bookmark;

  @override
  Widget build(BuildContext context) {
    final isOneDay = schedule.startAt.isSameDay(schedule.endAt);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AsyncImage(
                        imageUrl: schedule.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          schedule.hostName,
                          style: Theme.of(context).textTheme.caption.copyWith(
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          schedule.title,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                      ]
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWithIcon(
                    isOneDay
                      ? '${schedule.startAt.approximatelyDateFormat()}   ${schedule.startAt.timeFormat()} 〜 ${schedule.endAt.timeFormat()}'
                      : '${schedule.startAt.approximatelyDateFormat()}（${schedule.startAt.month}/${schedule.startAt.day}） 〜 ${schedule.endAt.timeFormat()}（${schedule.startAt.month}/${schedule.startAt.day}）',
                    leadingIcon: Icons.calendar_today,
                    spacing: 8,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    children: [
                      // IconButton(
                      //   icon: const Icon(Icons.share),
                      //   onPressed: () => print('share'),
                      // ),
                      IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked ? Colors.cyan[600] : Colors.black,
                        ),
                        onPressed: bookmark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}