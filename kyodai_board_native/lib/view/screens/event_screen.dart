import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/model/event.dart';
import 'package:kyodai_board/repo/board_repo.dart';
import 'package:kyodai_board/repo/user_repo.dart';
import 'package:kyodai_board/view/components/atom/async_image.dart';
import 'package:kyodai_board/utils/date_extension.dart';
import 'package:kyodai_board/model/enums/apply_type.dart';
import 'package:kyodai_board/view/mixins/club_report_dialog.dart';
import 'package:kyodai_board/view/mixins/show_snackbar.dart';
import 'package:kyodai_board/view/screens/club_screen.dart';
import 'package:kyodai_board/model/event_bookmark.dart';
import 'package:social_embed_webview/social_embed_webview.dart';

enum MenuItems {
  report
}

String tweetContent = r'''
<a class="twitter-timeline" data-lang="ja" data-dnt="true" data-chrome=”noheader” data-theme="light" href="https://twitter.com/Twitter?ref_src=twsrc%5Etfw">Tweets by Twitter</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>''';

class EventScreen extends HookWidget{
  const EventScreen({ this.schedule, Event event }): _event = event;

  final Schedule schedule;
  final Event _event;

  Future<void> _apply(BuildContext context, Schedule schedule) async {
    // webpageならwebpageへ飛ぶ
    // appなら申し込む
    final result = await showModalBottomSheet<bool>(
      context: context,
      builder: (BuildContext context){
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              if(schedule.applyTypes.needApply) ...[
                _buildChipInfo(
                  context,
                  '応募方法',
                  schedule.applyTypes.where((element) => element != ApplyType.none).map((e) => e.format).toList()
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(schedule.applyType_display)
                ),
              ],
              
              if(!schedule.applyTypes.needApply)
                _buildInfo(context, '応募方法', '応募は不要です'),

              const Divider(),
              _buildInfo(context, '持ち物', schedule.belongings),
              const Divider(),
              _buildInfo(context, '集合場所', schedule.place_display),
              const Divider(),
              _buildInfo(context, '実施場所', schedule.meetingPlace_display),
              const Divider(),
              _buildInfo(context, '雨天時', schedule.weatherCancel_display),
              const Divider(),
              _buildInfo(context, '注意事項', schedule.notes),
              const Divider(),
              _buildInfo(context, '連絡先', schedule.contact),
              const Divider(),
              _buildInfo(context, '当日連絡先', schedule.contactCurrentDay),
              const Divider(),

              if(schedule.applyTypes.appApply)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlineButton(
                      child: const Text('キャンセル'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    const SizedBox(width: 16),
                    if(schedule.applyTypes.contains(ApplyType.app))
                      RaisedButton(
                        child: const Text('申し込む'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    const SizedBox(width: 16),
                    if(schedule.applyTypes.contains(ApplyType.webpage))
                      RaisedButton(
                        child: const Text('申し込みフォームへ'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                  ]
                ),
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
    final event = useProvider(eventDetailProvider(_event).state);
    final eventRepo = useProvider(eventDetailProvider(_event));
    final iconUrl = useState('');
    
    final showAllSchedule = useState(true);

    final bookmarks = useProvider(bookmarkEventProvider);

    useEffect((){
      eventRepo.fetchIfNeed(schedule);
    }, []);
    
    useEffect((){
      if(event != null){
        iconUrl.value = event.iconUrl;
      }
    }, [event != null]);

    final key = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: key,
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
            onSelected: (MenuItems item) async {
              if(item == MenuItems.report){
                final result = await ReportDialog.showEventReport(context, event);
                if(result ?? false){
                  ShowSnackBar.show(key.currentState, '通報を完了しました');
                }
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
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints.expand(height: MediaQuery.of(context).size.height * 0.3),
                color: Colors.grey,
                child: event == null && schedule == null ? null : AsyncImage(
                  imageUrl: event?.imageUrl ?? schedule?.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ClubScreen(clubId: event.clubId)
                        )
                      ),
                      child: AsyncImage(
                        imageUrl: iconUrl.value,
                        imageBuilder: (_, image) => CircleAvatar(
                          radius: 32,
                          backgroundImage: image,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event?.title ?? schedule?.title ?? '',
                                style: Theme.of(context).textTheme.headline1.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                event?.hostName ?? schedule?.hostName ?? '',
                                style: Theme.of(context).textTheme.headline2.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
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
                      ),
                    ),
                  ]
                )
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  event?.description ?? schedule?.description ?? '',
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
                    if(event != null)
                      bookmarks.when(
                        data: (data) => IconButton(
                          icon: Icon(
                            data.containsClubAndEventId(event.id, event.clubId) ? Icons.bookmark : Icons.bookmark_border,
                            color: data.containsClubAndEventId(event.id, event.clubId) ? Colors.cyan[600] : Colors.black,
                          ),
                          onPressed: () {
                            print(bookmarks.data.value.containsClubAndEventId(event.id, event.clubId));
                            return bookmarks.data.value.containsClubAndEventId(event.id, event.clubId)
                              ? unbookmarkEvent(bookmarks.data.value.getWithEventId(event.id))
                              : bookmarkEvent(event.id, event.clubId);
                          },
                        ),
                        loading: () => const IconButton(
                            icon: Icon(
                              Icons.bookmark_border,
                              color: Colors.transparent,
                            ),
                            onPressed: null,
                          ),
                        error: (dynamic _, __) => const IconButton(
                          icon: Icon(
                            Icons.bookmark_border,
                            color: Colors.red,
                          ),
                          onPressed: null,
                        ),
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
                    Text.rich(
                      TextSpan(
                        text: 'イベント日程  全 ',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontSize: 13,
                        ),
                        children: [
                          TextSpan(
                            text: '${event?.schedules?.length ?? ' '}',
                            style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: ' 件',
                          ),
                        ],
                      )
                    ),

                    if(event?.applyTypes?.needApply ?? false)
                      const SizedBox(height: 8),
                      
                    if((event?.applyTypes?.needApply ?? false) && (event.schedules?.isNotEmpty ?? false))
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.red,
                            )
                          ),
                          child: Text(
                            'このイベントは事前申し込みが必要な回があります',
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.red
                            ),
                          )
                        ),
                      ),

                    const SizedBox(height: 16),
                    
                    if(event == null)
                      const SizedBox(height: 300, child: Text('loading')),
                    
                    if(event != null)
                      Container(
                        constraints: showAllSchedule.value ? const BoxConstraints(maxHeight: 300) : null,
                        child: event.schedules?.isEmpty ?? false
                          ? Center(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.red,
                                  )
                                ),
                                child: Text(
                                  '現在登録されているイベント日程はありません',
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                                    color: Colors.red
                                  ),
                                )
                              ),
                          )
                          : ListView.separated(
                            physics: showAllSchedule.value ? null : const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 0),
                            itemCount: event.schedules?.length ?? 0,
                            separatorBuilder: (context, index) => const Divider(thickness: 0, height: 0,),
                            itemBuilder: (context, index){
                              return ScheduleListItem(event.schedules[index], () => _apply(context, event.schedules[index]));
                            }
                          ),
                      ),
                    
                    const SizedBox(height: 8),
                    
                    if(event?.schedules?.isNotEmpty ?? false)
                    Center(
                      child: FlatButton(
                        onPressed: () => showAllSchedule.value = !showAllSchedule.value,
                        child: Text(showAllSchedule.value ? '全ての日程を見る' : '日程を折りたたむ'),
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
                child: event == null
                  ? const SizedBox(height: 300, child: Text('loading'))
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '情報',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '＊参加回によって異なる場合があります。詳しくは上記「イベント日程」からご確認ください。',
                        style: Theme.of(context).textTheme.caption.copyWith(
                          color: Theme.of(context).errorColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 14,
                        ),
                        child: Column(
                          children: [
                            _buildInfo(context, '持ち物', event.belongings),
                            const Divider(),
                            _buildInfo(context, '集合場所', event.place_display),
                            const Divider(),
                            _buildInfo(context, '実施場所', event.meetingPlace_display),
                            const Divider(),
                            _buildInfo(context, '雨天時', event.weatherCancel_display),
                            const Divider(),
                            _buildInfo(context, '注意事項', event.notes),
                            const Divider(),
                            _buildInfo(context, '連絡先', event.contact),
                            const Divider(),
                            _buildInfo(context, '当日連絡先', event.contactCurrentDay),
                          ],
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
                  children: [
                    Text(
                      'SNS',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
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

              SafeArea(
                top: false, left: false, right: false,
                child: Container(
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
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildInfo(BuildContext context, String header, String body){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            header,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }

  Widget _buildChipInfo(BuildContext context, String header, List<String> chips){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            header,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: chips.map((chipString) =>
              Chip(
                backgroundColor: Colors.cyan,
                label: Text(
                  chipString,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Colors.white,
                  ),
                ),
              )
            ).toList(),
          ),
        ],
      ),
    );
  }
}

class ScheduleListItem extends HookWidget {
  const ScheduleListItem(this.schedule, this.onPressed);
  final Schedule schedule;
  final void Function() onPressed;
  
  @override
  Widget build(BuildContext context) {
    // TODO: 申し込み開始日以前には申し込めない
    final isExpanded = useState(false);
    final isOneDay = schedule.startAt.isSameDay(schedule.endAt);
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
                  child: Text(
                    schedule.startAt.dateFormat(separator: '\n'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold)
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isOneDay
                          ? '${schedule.startAt.timeFormat()} 〜 ${schedule.endAt.timeFormat()}'
                          : '${schedule.startAt.timeFormat()}（${schedule.startAt.month}/${schedule.startAt.day}） 〜 ${schedule.endAt.timeFormat()}（${schedule.startAt.month}/${schedule.startAt.day}）',
                        style: const TextStyle(fontWeight: FontWeight.bold)
                      ),
                      Text(
                        schedule.applyTypes.needApply
                            ? '締め切り: ${schedule.applyEndAt.dateFormat()} ${schedule.applyEndAt.timeFormat()}'
                            : '申し込みは不要です',
                        style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  alignment: Alignment.centerRight,
                  icon: const Icon(Icons.expand_more),
                  onPressed: () => isExpanded.value = !isExpanded.value,
                )
              ],
            ),
          ),
        ),
        if(isExpanded.value)
          DefaultTextStyle(
            style: Theme.of(context).textTheme.caption.copyWith(
              color: Colors.black,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 78),
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                children: [
                  Text(schedule.time_display),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

        if(isExpanded.value)
          OutlineButton(
            onPressed: onPressed,
            child: Text(
              schedule.applyTypes.needApply ? '詳細 / 申し込み' : '詳細'
            ),
          ),
        
        if(isExpanded.value)
          const SizedBox(height: 16),
      ],
    );
  }
}