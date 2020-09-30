import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/model/value_objects/query/event_query.dart';
import 'package:kyodai_board/model/event_bookmark.dart';
import 'package:kyodai_board/repo/board_repo.dart';
import 'package:kyodai_board/repo/user_repo.dart';
import 'package:kyodai_board/router/routes.dart';
import 'package:kyodai_board/view/components/organism/buttom_navigation/bottom_navigation.dart';
import 'package:kyodai_board/view/components/organism/schedule_card/schedule_card.dart';
import 'package:kyodai_board/view/screens/event_screen.dart';

enum Tabs{ event, eventBookmark, /*board*/ }
enum TabState{ event, eventBookmark, /*board,*/ transition }

// FIXME: タブを移動すると検索情報が失われる

class BoardPage extends HookWidget{
  const BoardPage();

  @override
  Widget build(BuildContext context) {
    final tabState = useState(TabState.event);
    final tab = useTabController(initialLength: 2);
    tab.addListener((){
      tabState.value = tab.indexIsChanging ? TabState.transition : tab.index == 0 ? TabState.event : TabState.eventBookmark;
    });

    final scheduleRepo = useProvider(scheduleProvider);
    final schedules = scheduleRepo.state;

    useEffect((){
      scheduleRepo.fetch();
      return null;
    }, []);

    final bookmarks = useProvider(bookmarkEventProvider).data?.value;

    final bookmarkedSchedules = schedules.where((schedule) => bookmarks.containsClubAndEventId(schedule.eventRef.id, schedule.clubId)).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BubbleTabIndicator(
              indicatorHeight: 30,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.orange[50],
            ),
            controller: tab,
            isScrollable: true,
            labelColor: Colors.deepOrange[800],
            labelStyle: const TextStyle(
              textBaseline: TextBaseline.ideographic,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
            unselectedLabelStyle: const TextStyle(
              textBaseline: TextBaseline.alphabetic,
              fontWeight: FontWeight.normal,
              letterSpacing: 0,
            ),
            unselectedLabelColor: Colors.white,
            tabs: const [
              Tab(text: '一覧'),
              Tab(text: 'ブックマーク'),
              // Tab(text: 'タイムライン'),
            ],
          ),
        ),
        floatingActionButton: tabState.value != TabState.event
          ? null :
          FloatingActionButton.extended(
            icon: const Icon(Icons.search),
            label: tabState.value == TabState.event ? const Text('イベント') : const Text('タイムライン'),
            onPressed: () async {
              final query = await Navigator.of(context).pushNamed(Routes.boardsSearch, arguments: EventQuery());
              if(query != null){
                await Future<void>.delayed(const Duration(milliseconds: 100));
                await Navigator.of(context).pushNamed(Routes.boardsResult, arguments: query);
              }
            },
          ),
        body: TabBarView(
          controller: tab,
          children: [
            Center(
              child: RefreshIndicator(
                onRefresh: () async => scheduleRepo.fetch(),
                child: schedules.isEmpty
                    ? const Center(child: Text('該当するイベントはありませんでした'))
                    : ListView.builder(
                        itemCount: schedules.length,
                        itemBuilder: (context, index) =>
                          ScheduleCard(
                            schedule: schedules[index],
                            onTap: () => Navigator.of(context).push(MaterialPageRoute<EventScreen>(builder: (_) => EventScreen(schedule: schedules[index]))),
                            isBookmarked: bookmarks.containsClubAndEventId(schedules[index].eventRef.id, schedules[index].clubId),
                            bookmark: () => bookmarks.containsClubAndEventId(schedules[index].eventRef.id, schedules[index].clubId)
                                ? unbookmarkEvent(bookmarks.getWithEventId(schedules[index].eventRef.id))
                                : bookmarkEvent(schedules[index].eventRef.id, schedules[index].clubId),
                          ),
                      ),
              )
            ),
            Center(
              child: RefreshIndicator(
                onRefresh: () async => scheduleRepo.fetch(),
                child: bookmarkedSchedules.isEmpty
                    ? const Center(child: Text('該当するイベントはありませんでした'))
                    : ListView.builder(
                        itemCount: bookmarkedSchedules.length,
                        itemBuilder: (context, index) =>
                          ScheduleCard(
                            schedule: bookmarkedSchedules.toList()[index],
                            onTap: () => Navigator.of(context).push(MaterialPageRoute<EventScreen>(builder: (_) => EventScreen(schedule: schedules[index]))),
                            isBookmarked: bookmarks.containsClubAndEventId(bookmarkedSchedules[index].eventRef.id, bookmarkedSchedules[index].clubId),
                            bookmark: () => bookmarks.containsClubAndEventId(bookmarkedSchedules[index].eventRef.id, bookmarkedSchedules[index].clubId)
                                ? unbookmarkEvent(bookmarks.getWithEventId(bookmarkedSchedules[index].eventRef.id))
                                : bookmarkEvent(bookmarkedSchedules[index].eventRef.id, bookmarkedSchedules[index].clubId),
                          ),
                      ),
              )
            ),
          ]
        ),
        bottomNavigationBar: BottomNavigation(),
      ),
    );
  }
}
