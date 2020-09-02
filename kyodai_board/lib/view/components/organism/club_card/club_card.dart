import 'package:flutter/material.dart';
import 'package:kyodai_board/model/club.dart';
import 'package:kyodai_board/view/components/atom/async_image.dart';

class ClubCard extends StatelessWidget{
  const ClubCard(this.club, { this.onTap });

  final Club club;
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
                      imageUrl: club.profile.imageUrl,
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
                        Text(club.profile.name),
                        Text(club.profile.genre.join(' ')),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              color: Colors.cyan,
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                              child: Text(
                                '公認',
                                style: Theme.of(context).textTheme.caption.copyWith(
                                  // backgroundColor: Colors.cyan[400],
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          club.profile.description,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () => print('share'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_border),
                        onPressed: () => print('bookmark'),
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