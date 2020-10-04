import 'package:flutter/material.dart';
import 'package:kyodai_board/model/club.dart';
import 'package:kyodai_board/model/enums/club_type.dart';
import 'package:kyodai_board/view/components/atom/async_image.dart';
import 'package:kyodai_board/view/components/atom/badge.dart';

class ClubCard extends StatelessWidget{
  const ClubCard(this.club, { this.isBookmarked, this.bookmark, this.onTap });

  final Club club;
  final void Function() onTap;
  final void Function() bookmark;
  final bool isBookmarked;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 4),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.grey[50],
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AsyncImage(
                        imageUrl: club.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                club.name,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.bodyText1.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: isBookmarked == null ? null : bookmark,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Icon(
                                  isBookmarked ?? false ? Icons.bookmark : Icons.bookmark_border,
                                  color: isBookmarked ?? false ? Colors.cyan[600] : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            Badge.clubType(club.clubType),
                            if(club.isOfficial)
                              const Badge.official(),
                            if(club.isIntercollege)
                              const Badge.interCollege(),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          club.description,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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