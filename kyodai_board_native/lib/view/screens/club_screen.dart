import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/model/club.dart';
import 'package:kyodai_board/model/club_profile.dart';
import 'package:kyodai_board/repo/board_repo.dart';
import 'package:kyodai_board/repo/club_repo.dart';
import 'package:kyodai_board/repo/user_repo.dart';
import 'package:kyodai_board/router/routes.dart';
import 'package:kyodai_board/view/components/atom/async_image.dart';
import 'package:kyodai_board/model/util/freq.dart';
import 'package:kyodai_board/model/enums/campus.dart';
import 'package:kyodai_board/model/club_bookmark.dart';
import 'package:kyodai_board/utils/ratio_format.dart';
import 'package:kyodai_board/view/components/organism/event_card/event_card.dart';
import 'package:kyodai_board/view/mixins/club_report_dialog.dart';
import 'package:kyodai_board/view/mixins/show_snackbar.dart';
import 'package:kyodai_board/view/screens/event_screen.dart';
import 'package:url_launcher/url_launcher.dart';

enum MenuItems {
  report
}

String tweetContent = r'''
<a class="twitter-timeline" data-lang="ja" data-dnt="true" data-chrome=”noheader” data-theme="light" href="https://twitter.com/Twitter?ref_src=twsrc%5Etfw">Tweets by Twitter</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>''';

class ClubScreen extends HookWidget{
  const ClubScreen({Club club, String clubId})
    : _initClub = club
    , _clubId = clubId;

  final Club _initClub;
  final String _clubId;

  Future<void> _bookmark(Club club) async {
    await bookmarkClub(club.id);
  }

  void _moveToChatScreen(BuildContext context, String clubId){
    Navigator.pushNamed(context, Routes.chatDetailTemporary, arguments: clubId);
  }

  @override
  Widget build(BuildContext context) {
    final scrollRatio = useState<double>(0);
    final scrollController = useScrollController();
    scrollController.addListener(() {
      scrollRatio.value = scrollController.hasClients
          ? math.min(scrollController.offset / scrollController.position.maxScrollExtent, 0.3)
          : 0;
    });

    final tabController = useTabController(initialLength: 6);
    final tabIndex = useState(0);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });

    final clubRepo = useProvider(clubProvider(_initClub));
    final club = useProvider(clubProvider(_initClub).state);
    final eventsRepo = useProvider(eventByClubProvider);
    final events = useProvider(eventByClubProvider.state);
    
    final bookmarks = useProvider(bookmarkClubProvider);

    useEffect((){
      clubRepo.fetchIfNull(_clubId);
      eventsRepo.fetchIfEmpty(_clubId);
    }, []);

    final contactInfo = club?.profile?.contactInfo ?? [];
    final snsInfo = club?.profile?.snsInfo ?? [];

    final key = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: key,
      extendBodyBehindAppBar: true,
      floatingActionButton:
        [2, 3].contains(tabIndex.value) ? null : FloatingActionButton.extended(
          icon: const Icon(Icons.question_answer),
          label: const Text('チャット'),
          onPressed: () => _moveToChatScreen(context, club.id),
        ),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50,
        backgroundColor: Colors.black.withOpacity(0.2),
        actions: [
          PopupMenuButton<MenuItems>(
            initialValue: MenuItems.report,
            icon: const Icon(Icons.more_vert),
            offset: const Offset(0, 100),
            onSelected: (MenuItems item) async {
              if(item == MenuItems.report){
                final result = await ReportDialog.showClubReport(context, club);
                if(result ?? false){
                  ShowSnackBar.show(key.currentState, '通報を完了しました');
                }
              }
            },
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem(
                  child: Text('通報'),
                  value: MenuItems.report,
                )
              ];
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) => Column(
          children: club == null ? List.generate(6, (index) => const Center())
          :[
            AsyncImage(
              imageUrl: club.profile.imageUrl,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(
                scrollRatio.value
              ),
              colorBlendMode: BlendMode.srcOver,
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AsyncImage(
                        imageUrl: club.profile.iconImageUrl,
                        imageBuilder: (_, image) => CircleAvatar(
                          radius: 32,
                          backgroundImage: image,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(club.profile.name),
                            Text(
                              club.profile.genre?.join(' '),
                              style: Theme.of(context).textTheme.caption,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
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
                                          '公認',
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
                                          '体育会',
                                          style: Theme.of(context).textTheme.caption.copyWith(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.share),
                                      onPressed: () => print('share'),
                                    ),
                                    bookmarks.when(
                                      data: (data) => IconButton(
                                        icon: Icon(
                                          data.containsClubId(club.id) ? Icons.bookmark : Icons.bookmark_border,
                                          color: data.containsClubId(club.id) ? Colors.cyan[600] : Colors.black,
                                        ),
                                        onPressed: () => bookmarks.data.value.containsClubId(club.id)
                                            ? unbookmarkClub(bookmarks.data.value.getWithClubId(club.id))
                                            : bookmarkClub(club.id),
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  
                ]
              )
            ),

            Divider(
              thickness: 8,
              height: 8,
              color: Colors.grey[200],
            ),

            TabBar(
              controller: tabController,
              isScrollable: true,
              labelColor: Colors.black,
              tabs: const [
                Tab(text: '活動内容'),
                Tab(text: '雰囲気'),
                Tab(text: 'イベント'),
                Tab(text: 'タイムライン'),
                Tab(text: '情報'),
                Tab(text: 'SNS/連絡先'),
              ],
            ),

            Expanded(
              child: Column(
                children: [
                  Flexible(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildPassage('団体紹介', club.profile.description),
                              _buildPassage('活動頻度', club.profile.freq_display),
                              _buildPassage('活動への参加', club.profile.obligation_display),
                              _buildPassage('モチベーション', club.profile.motivation_display),
                              _buildPassage('練習場所', club.profile.place_display),
                              _buildPassage('大会・発表会の頻度', club.profile.competition_display),
                              const SizedBox(height: 100),
                            ].where((e) => e != null).toList(),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildPassage('飲み会', club.profile.drinking_display),
                              _buildPassage('イベント', club.profile.event_display),
                              _buildPassage('合宿・旅行', club.profile.trip_display),
                              const SizedBox(height: 100),
                            ].where((e) => e != null).toList(),
                          ),
                        ),
                        Container(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            // FIXME EventCardを流用しない
                            children: [
                              ...events.map((e) =>
                                EventCard(
                                  event: e,
                                  onTap: () => Navigator.of(context).push(MaterialPageRoute<EventScreen>(builder: (_) => EventScreen(event: e))),
                                )
                              ).toList(),
                              SizedBox(height: MediaQuery.of(context).viewPadding.bottom)
                            ]
                          ),
                        ),
                        Container(
                          child: const Text('投稿一覧'),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildQandA(context, '部員数', '${club.profile.memberCount}人'),
                              const Divider(),
                              _buildQandA(context, '男女比', '男：女 = ${club.profile.genderRatio.toFormatRatio()}'),
                              const Divider(),
                              _buildQandA(context, '主に活動しているキャンパス（吉田キャンパス以外）', '${club.profile.campus.format}'),
                              const Divider(),
                              _buildQandA(context, '飲み会頻度', '${club.profile.drinkingFreq.format}'),
                              const Divider(),
                              _buildQandA(context, 'イベント頻度', '${club.profile.eventFreq.format}'),
                              const Divider(),
                              _buildQandA(context, '合宿・旅行頻度', '${club.profile.tripFreq.format}'),
                              const Divider(),
                              _buildQandA(context, 'インカレか', club.profile.isIntercollege ? 'Yes': 'No'),
                              const Divider(),
                              _buildQandA(context, '自分の大学オンリーか', club.profile.isOnlyKU ? 'Yes': 'No'),
                              const Divider(),
                              _buildQandA(context, '自分の大学の割合', '${club.profile.kuRatio?.toFormatPercentage()}'),
                              if(club.profile.isCompany != null) ...[
                                const Divider(),
                                _buildQandA(context, '会社団体か', club.profile.isCompany ? 'Yes': 'No'),
                              ],
                              if(club.profile.hasSchoolRestrict != null) ...[
                                const Divider(),
                                _buildQandA(context, '学部制限があるか', club.profile.hasSchoolRestrict ? 'Yes': 'No'),
                              ],
                              const SizedBox(height: 100),
                            ].where((e) => e != null).toList(),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildHeader('SNS'),
                              if(snsInfo.isEmpty)
                                const Center(child: Text('SNSは登録されていません')),
                              if(snsInfo.isNotEmpty)
                                ...snsInfo.map((info) => [
                                    _buildContact(context, info),
                                    const Divider(height: 0),
                                  ])
                                  .expand((widget) => widget)
                                  .toList()
                                  ..removeLast(),
                              _buildHeader('連絡先'),
                              if(contactInfo.isEmpty)
                                const Center(child: Text('連絡先は登録されていません')),
                              if(contactInfo.isNotEmpty)
                                ...contactInfo.map((info) => [
                                    _buildContact(context, info),
                                    const Divider(height: 0),
                                  ])
                                  .expand((widget) => widget)
                                  .toList()
                                  ..removeLast(),
                            ].where((e) => e != null).toList(),
                          ),
                        ),
                      ]
                    ),
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQandA(BuildContext context, String question, String answer) {
    if(question == null || answer == null){
      return null;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(question),
          ),
          const SizedBox(width: 12),
          Chip(
            backgroundColor: Colors.cyan,
            label: Text(
              answer,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ]
      ),
    );
  }

  static Widget _buildContactSheet(BuildContext context, ContactInfo contactInfo){
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Text(
                  contactInfo.description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                    fontSize: 16,
                  ),
                ),
                Text(
                  contactInfo.contact,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          
          ListTile(
            title: Text(
              contactInfo.type == ContactType.phone ? '電話番号をコピー' :
              contactInfo.type == ContactType.email ? 'メールアドレスをコピー' : 'URLをコピー'
            ),
            onTap: () async {
              final data = ClipboardData(text: contactInfo.contact);
              await Clipboard.setData(data);
              Navigator.pop(context);
              ShowSnackBar.show(Scaffold.of(context), 'クリップボードにコピーされました');
            }
          ),

          if(contactInfo.type == ContactType.phone) ...[
            ListTile(
              title: const Text('電話をかける'),
              onTap: () async {
                Navigator.pop(context);
                //TODO: avoid hard coding
                await launch('tel:xxx')
                  .then((value) => print('success'))
                  .catchError((dynamic _) => print('miss'));
              }
            ),
            ListTile(
              title: const Text('SMSを送る'),
              onTap: () async {
                Navigator.pop(context);
                //TODO: avoid hard coding
                await launch('sms:xxx')
                  .then((value) => print('success'))
                  .catchError((dynamic _) => print('miss'));
              }
            ),
          ],

          if(contactInfo.type == ContactType.email)
            ListTile(
              title: const Text('メールを送る'),
              onTap: () async {
                Navigator.pop(context);
                //TODO: avoid hard coding
                await launch('mailto:xxx')
                  .then((value) => print('success'))
                  .catchError((dynamic _) => print('miss'));
              },
            ),

          if(contactInfo.type != ContactType.phone && contactInfo.type != ContactType.email)
            ListTile(
              title: const Text('URLを開く'),
              onTap: () async {
                Navigator.pop(context);
                await launch(contactInfo.contact)
                  .then((value) => print('success'))
                  .catchError((dynamic _) => print('miss'));
              },
            ),
            // TODO: twitter アプリへ遷移
        ],
      ),
    );
  }

  Widget _buildContact(BuildContext context, ContactInfo contactInfo) {
    return ListTile(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        builder: (_) => _buildContactSheet(context, contactInfo),
      ),
      trailing: const Icon(Icons.chevron_right),
      title: Text(
        contactInfo.description,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      subtitle: Text(contactInfo.contact),
    );
  }

  Widget _buildPassage(String topic, String paragraph) {
    if(topic == null || paragraph == null){
      return null;
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(topic),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(paragraph),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String topic) {
    if(topic == null){
      return null;
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.cyan,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Text(
        topic,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
}
