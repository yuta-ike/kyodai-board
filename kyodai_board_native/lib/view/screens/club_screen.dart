import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/model/club.dart';
import 'package:kyodai_board/view/components/atom/async_image.dart';
import 'package:kyodai_board/model/util/freq.dart';
import 'package:kyodai_board/model/enums/campus.dart';
import 'package:kyodai_board/utils/ratio_format.dart';

enum MenuItems {
  report
}

String tweetContent = r'''
<a class="twitter-timeline" data-lang="ja" data-dnt="true" data-chrome=”noheader” data-theme="light" href="https://twitter.com/Twitter?ref_src=twsrc%5Etfw">Tweets by Twitter</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>''';

class ClubScreen extends HookWidget{
  const ClubScreen(this.club);

  final Club club;

  @override
  Widget build(BuildContext context) {
    final scrollRatio = useState(0.0);
    final scrollController = useScrollController();
    scrollController.addListener(() {
      scrollRatio.value = scrollController.hasClients
          ? math.min(scrollController.offset / scrollController.position.maxScrollExtent, 0.3)
          : 0;
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.question_answer),
          label: const Text('チャット'),
          onPressed: () => print('チャット画面へ'),
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
      body: DefaultTabController(
        length: 6,
        child: Column(
          children: [
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
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          ],
                        ),
                      ),
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
                      )
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

            const TabBar(
              isScrollable: true,
              labelColor: Colors.black,
              tabs: [
                Tab(text: '活動内容'),
                Tab(text: '雰囲気'),
                Tab(text: 'イベント'),
                Tab(text: '投稿'),
                Tab(text: '情報'),
                Tab(text: 'SNS/連絡先'),
              ],
            ),

            Expanded(
              child: Column(
                children: [
                  Flexible(
                    child: TabBarView(
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
                          child: const Text('イベント一覧'),
                        ),
                        Container(
                          child: const Text('投稿一覧'),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildQandA('部員数', '${club.profile.memberCount}人'),
                              const Divider(),
                              _buildQandA('男女比', '男：女 = ${club.profile.genderRatio.toFormatRatio()}'),
                              const Divider(),
                              _buildQandA('主に活動しているキャンパス', '${club.profile.campus.format}'),
                              const Divider(),
                              _buildQandA('飲み会頻度', '${club.profile.drinkingFreq.format}'),
                              const Divider(),
                              _buildQandA('イベント頻度', '${club.profile.eventFreq.format}'),
                              const Divider(),
                              _buildQandA('合宿・旅行頻度', '${club.profile.tripFreq.format}'),
                              const Divider(),
                              _buildQandA('インカレか', club.profile.isIntercollege ? 'Yes': 'No'),
                              const Divider(),
                              _buildQandA('自分の大学オンリーか', club.profile.isOnlyKU ? 'Yes': 'No'),
                              const Divider(),
                              _buildQandA('自分の大学の割合', '${club.profile.kuRatio.toFormatPercentage()}'),
                              if(club.profile.isCompany != null) ...[
                                const Divider(),
                                _buildQandA('会社団体か', club.profile.isCompany ? 'Yes': 'No'),
                              ],
                              if(club.profile.hasSchoolRestrict != null) ...[
                                const Divider(),
                                _buildQandA('学部制限があるか', club.profile.hasSchoolRestrict ? 'Yes': 'No'),
                              ],
                              const SizedBox(height: 100),
                            ].where((e) => e != null).toList(),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildHeader('連絡先'),
                              _buildQandA(club.profile.publicEmailDescription, '${club.profile.publicEmail}'),
                              _buildQandA(club.profile.publicPhoneNumber, '${club.profile.publicPhoneNumber}'),
                              _buildQandA(club.profile.lineId, '${club.profile.lineId}'),
                              _buildHeader(club.profile.twitterUrlDescription),
                              Text(club.profile.twitterUrl),
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

  Widget _buildQandA(String question, String answer) {
    if(question == null || answer == null){
      return null;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        runSpacing: 48,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(question),
          Chip(label: Text(answer)),
        ],
      ),
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

  Container _buildHeader(String topic) {
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
