import 'dart:math' as math;
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/firebase/analytics.dart';
import 'package:kyodai_board/model/club.dart';
import 'package:kyodai_board/repo/board_repo.dart';
import 'package:kyodai_board/repo/club_repo.dart';
import 'package:kyodai_board/repo/user_repo.dart';
import 'package:kyodai_board/router/routes.dart';
import 'package:kyodai_board/view/components/atom/async_image.dart';
import 'package:kyodai_board/model/club_bookmark.dart';
import 'package:kyodai_board/view/components/atom/badge.dart';
import 'package:kyodai_board/view/components/organism/event_card/event_card.dart';
import 'package:kyodai_board/view/mixins/club_report_dialog.dart';
import 'package:kyodai_board/view/mixins/show_snackbar.dart';
import 'package:kyodai_board/view/screens/event_screen.dart';
import 'package:kyodai_board/utils/ratio_format.dart';
import 'package:kyodai_board/model/enums/campus.dart';
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

  void _moveToChatScreen(BuildContext context, String clubId){
    Navigator.pushNamed(context, Routes.chatDetailTemporary, arguments: clubId);
  }

  @override
  Widget build(BuildContext context) {
    final scrollRatio = useState<double>(0);
    final scrollController = useScrollController();
    useEffect((){
      scrollController.addListener(() {
        scrollRatio.value = scrollController.hasClients
            ? math.min(scrollController.offset / scrollController.position.maxScrollExtent, 0.3)
            : 0;
      });
      return null;
    }, [scrollController]);

    final tabController = useTabController(initialLength: 5);
    final tabIndex = useState(0);
    useEffect(() {
      tabController.addListener(() {
        tabIndex.value = tabController.index;
      });
      return null;
    }, [tabController]);

    final clubRepo = useProvider(clubProvider(_initClub));
    final club = useProvider(clubProvider(_initClub).state);
    final eventsRepo = useProvider(eventByClubProvider);
    final events = useProvider(eventByClubProvider.state);

    final bookmarks = useProvider(bookmarkClubProvider);

    useEffect((){
      clubRepo.fetchIfNull(_clubId);
      eventsRepo.fetchIfEmpty(_clubId);
      return null;
    }, []);

    final contactInfo = club?.contactInfo ?? [];
    final snsInfo = club?.snsInfo ?? [];

    final scaffoldKey = useState(GlobalKey<ScaffoldState>());

    useEffect((){
      analytics.logViewItem(itemId: club.id, itemName: club.name, itemCategory: 'club_page_open');
      return null;
    }, []);

    return Scaffold(
      key: scaffoldKey.value,
      extendBodyBehindAppBar: true,
      floatingActionButton:
        [2, 3].contains(tabIndex.value) ? null : FloatingActionButton.extended(
          icon: const Icon(Icons.question_answer),
          label: const Text('チャット'),
          onPressed: () => _moveToChatScreen(context, club.id),
        ),
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.black.withOpacity(0.2),
        elevation: 0,
        actions: [
          PopupMenuButton<MenuItems>(
            initialValue: MenuItems.report,
            icon: const Icon(Icons.more_vert),
            offset: const Offset(0, 100),
            onSelected: (MenuItems item) async {
              if(item == MenuItems.report){
                final result = await ReportDialog.showClubReport(context, club);
                if(result ?? false){
                  ShowSnackBar.show(scaffoldKey.value.currentState, '通報を完了しました');
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
              imageUrl: club.imageUrl,
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
                        imageUrl: club.iconImageUrl,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    club.name,
                                    maxLines: 2,
                                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                bookmarks.when(
                                  loading: () => const InkWell(child: Icon(Icons.bookmark)),
                                  error: (dynamic _, __) => const InkWell(child: Icon(Icons.bookmark)),
                                  data: (data) => InkWell(
                                    onTap: () => () => bookmarks.data.value.containsClubId(club.id)
                                        ? unbookmarkClub(bookmarks.data.value.getWithClubId(club.id))
                                        : bookmarkClub(club.id),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Icon(
                                        data.containsClubId(club.id) ? Icons.bookmark : Icons.bookmark_border,
                                        color: data.containsClubId(club.id) ?? false ? Colors.cyan[600] : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              club.genre?.join(' ') ?? '',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Wrap(
                                    spacing: 8,
                                    children: [
                                      Badge.clubType(club.clubType),
                                      if(club.isOfficial)
                                        const Badge.official(),
                                      if(club.isIntercollege)
                                        const Badge.interCollege(),
                                    ],
                                  ),
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
            
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(
                  color: Colors.grey[200],
                  width: 2,
                )),
              ),
              child: Center(
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: const BubbleTabIndicator(
                    indicatorHeight: 30,
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Colors.orange,
                  ),
                  controller: tabController,
                  isScrollable: true,
                  labelColor: Colors.white,
                  labelStyle: const TextStyle(
                    textBaseline: TextBaseline.ideographic,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    textBaseline: TextBaseline.ideographic,
                  ),
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(text: '活動'),
                    Tab(text: '雰囲気'),
                    Tab(text: 'イベント'),
                    // Tab(text: 'タイムライン'),
                    Tab(text: '情報'),
                    Tab(text: 'SNS/連絡先'),
                  ],
                ),
              ),
            ),

            // Divider(
            //   thickness: 8,
            //   height: 8,
            //   color: Colors.grey[200],
            // ),

            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildPassage('団体紹介', club.description),
                        _buildPassage('活動日', club.freq_display),
                        _buildPassage('メンバーの説明', club.member_display),
                        _buildPassage('活動場所', club.place_display),
                        _buildPassage('費用', club.cost_display),
                        _buildPassage('大会・発表会など', club.competition_display),
                        const SizedBox(height: 100),
                      ].where((e) => e != null).toList(),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildPassage('活動への参加', club.obligation_display),
                        _buildPassage('モチベーション', club.motivation_display),
                        _buildPassage('飲み会', club.drinking_display),
                        _buildPassage('イベント', club.event_display),
                        _buildPassage('合宿・旅行', club.trip_display),
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
                  // Container(
                  //   child: const Text('投稿一覧'),
                  // ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Divider(color: Colors.transparent, height: 8),
                        if(club.memberCount != null) ...[
                          _buildQandA(context, '部員数', '${club.memberCount}人'),
                          const Divider(),
                        ],
                        if(club.genderRatio != null) ...[
                          _buildQandA(context, '男女比', '男：女 = ${club.genderRatio.toFormatRatio()}'),
                          const Divider(),
                        ],
                        if(club.campus != null) ...[
                          _buildQandA(context, '主に活動しているキャンパス', '${club.campus.map((campus) => campus.format).join()}'),
                          const Divider(),
                        ],
                        if(club.isIntercollege != null) ...[
                          _buildQandA(context, 'インカレか', club.isIntercollege ? 'Yes': 'No'),
                          const Divider(),
                        ],
                        if(club.kuRatio != null) ...[
                          _buildQandA(context, '自分の大学の割合', '${club.kuRatio?.toFormatPercentage()}'),
                          const Divider(),
                        ],
                        if(club.isCompany != null) ...[
                          _buildQandA(context, '会社団体か', club.isCompany ? 'Yes': 'No'),
                          const Divider(),
                        ],
                        if(club.hasSchoolRestrict != null) ...[
                          _buildQandA(context, '学部制限があるか', club.hasSchoolRestrict ? 'Yes': 'No'),
                          const Divider(),
                        ],
                        const SizedBox(height: 100),
                      ].where((e) => e != null).toList(),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader('ホームページ'),
                        if(club.homepageUrl == null)
                          const Center(child: Text('ホームページは登録されていません')),
                        if(club.homepageUrl != null) ...[
                          _buildListTile(context, title: 'ホームページ', subtitle: club.homepageUrl, onTap: () async {
                            await launch(club.homepageUrl);
                          }),
                        ],
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

  Widget _buildListTile(BuildContext context, { String title, String subtitle, void Function() onTap }){
    return ListTile(
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildContact(BuildContext context, ContactInfo contactInfo) {
    return _buildListTile(
      context,
      title: contactInfo.description,
      subtitle: contactInfo.contact,
      onTap: () => showModalBottomSheet<void>(
        context: context,
        builder: (_) => _buildContactSheet(context, contactInfo),
      )
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
      margin: const EdgeInsets.fromLTRB(8, 16, 8, 8),
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
