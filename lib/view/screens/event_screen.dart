import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/model/event.dart';
import 'package:kyodai_board/view/components/atom/async_image.dart';
import 'package:kyodai_board/view/components/organism/ogp/ogp.dart';
import 'package:social_embed_webview/social_embed_webview.dart';

enum MenuItems {
  report
}

String tweetContent = r'''
<a class="twitter-timeline" data-lang="ja" data-dnt="true" data-chrome=”noheader” data-theme="light" href="https://twitter.com/Twitter?ref_src=twsrc%5Etfw">Tweets by Twitter</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>''';

class EventScreen extends HookWidget{
  const EventScreen(this.event);

  final Event event;

  Future<void> _apply(BuildContext context,/*日程データを受け取る*/) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      builder: (BuildContext context){
        return Container(
          height: 400,
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('注意事項など'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlineButton(
                    child: const Text('キャンセル'),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  const SizedBox(width: 16),
                  RaisedButton(
                    child: const Text('申し込む'),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ]
              )
            ],
          ),
        );
      }
    );

    if(result ?? false){
      print('申し込み');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.black.withOpacity(0.1),
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme.copyWith(
          color: Colors.white,
        ),
        actions: [
          PopupMenuButton<MenuItems>(
            initialValue: MenuItems.report,
            icon: const Icon(Icons.more_vert),
            offset: const Offset(0, 100),
            onSelected: (MenuItems item) {
              if(item == MenuItems.report){
                print('通報処理');
              }
            },
            itemBuilder: (BuildContext context) {
              return const [PopupMenuItem(
                child: Text('通報'),
                value: MenuItems.report,
              )];
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints.expand(height: MediaQuery.of(context).size.height * 0.3),
                child: AsyncImage(
                  imageUrl: event.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.title),
                    Text(event.hostName),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.cyan,
                            border:Border.all(
                              width: 1,
                              color: Colors.cyan,
                            ),
                          ),
                          child: Text(
                            '初心者歓迎',
                            style: Theme.of(context).textTheme.caption.copyWith(
                              // backgroundColor: Colors.cyan[400],
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:Border.all(
                              width: 1,
                              color: Colors.red,
                            ),
                          ),
                          child: Text(
                            '要予約',
                            style: Theme.of(context).textTheme.caption.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  ]
                )
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  event.description,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontSize: 13
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
              ),

              Divider(
                thickness: 16,
                height: 16,
                color: Colors.grey[200],
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('イベント一覧'),
                    const Text('毎週水曜日に実施しています。'),

                    const SizedBox(height: 8),
                    
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.red,
                          )
                        ),
                        child: Text(
                          'このイベントは申し込みが必要です',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.red
                          ),
                        )
                      ),
                    ),

                    const SizedBox(height: 8),
                    
                    SizedBox(
                      height: 300,
                      child: ListView.separated(
                        padding: const EdgeInsets.only(top: 0),
                        itemCount: 10,
                        separatorBuilder: (context, index) => const Divider(thickness: 0, height: 0,),
                        itemBuilder: (context, index) => ScheduleListItem(() => _apply(context, /*日程データを与える*/)),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Center(
                      child: FlatButton(
                        onPressed: () => print('load more'),
                        child: const Text('全ての日程を見る'),
                      ),
                    ),
                  ]
                )
              ),

              Divider(
                thickness: 16,
                height: 32,
                color: Colors.grey[200],
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SNS'),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: SingleChildScrollView(
                        child: SocialEmbed(
                          embedCode: tweetContent,
                          type: SocailMediaPlatforms.twitter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                thickness: 16,
                height: 32,
                color: Colors.grey[200],
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('団体情報'),
                    Text('ホームページ'),
                    Text('人数'),
                    Text('男女比'),
                    Text('練習日程'),
                    Text('アピールポイント'),
                    Ogp('https://pub.dev/'),
                  ],
                ),
              ),
              
              Divider(
                thickness: 16,
                height: 32,
                color: Colors.grey[200],
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('実際にチャットする'),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () => print('go to chatroom'),
                      child: const Center(
                        child: Text('チャット画面へ')
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}

class ScheduleListItem extends HookWidget {
  const ScheduleListItem(this.onPressed);
  final void Function() onPressed;
  
  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(false);
    return Column(
      children: [
        InkWell(
          onTap: () => isExpanded.value = !isExpanded.value,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 70,
                  padding: const EdgeInsets.only(right: 10),
                  child: const Text(
                    '9月30日\n水',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '10:00 〜 12:00',
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                      Text(
                        '締め切り: 9/29日23時59分',
                        style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  alignment: Alignment.centerRight,
                  icon: const Icon(Icons.expand_more),
                  onPressed: onPressed,
                )
              ],
            ),
          ),
        ),
        if(isExpanded.value)
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 78),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '・場所: 吉田南グラウンド',
                  style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '・持ち物: 運動できる服装',
                  style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '＊12時からアフターあり!是非ご参加ください',
                  style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        if(isExpanded.value)
          Center(
            child: FlatButton(
              onPressed: onPressed,
              child: const Text('申し込む'),
            ),
          )
      ],
    );
  }
}