import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/model/board.dart';
import 'package:kyodai_board/view/components/atom/async_image.dart';
import 'package:kyodai_board/utils/string_with_br_escape.dart';

class BoardCard extends HookWidget{
  const BoardCard(this.board, { this.onTap });

  final Board board;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {

    final isExpanded = useState(false);


    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(board.title),
            subtitle: Text(
              board.hostName,
            ),
          ),
          ClipRRect(
            child: Align(
              heightFactor: 0.7,
              child: AsyncImage(
                imageUrl: board.imageUrl,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  isExpanded.value ? board.message.escape : board.message.flatten,
                  maxLines: isExpanded.value ? null : 2,
                  softWrap: true,
                  overflow: isExpanded.value ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
                if(!isExpanded.value)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => isExpanded.value = !isExpanded.value,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Text('▽ 続きを読む'),
                        ),
                      ),
                    ],
                  ),
              ]
            )
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
                  '2020年8月30日',
                  style: Theme.of(context).textTheme.caption,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => print('share'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () => print('favorite'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}