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

enum Tabs{ event, board }
enum TabState{ event, board, transition }

class EventResultPage extends HookWidget{
  const EventResultPage({this.query});

  final EventQuery query;

  @override
  Widget build(BuildContext context) {
    final tabState = useState(TabState.event);
    final tab = useTabController(initialLength: 2);
    tab.addListener((){
      tabState.value = tab.indexIsChanging ? TabState.transition : tab.index == 0 ? TabState.event : TabState.board;
    });

    // final state = useState(eventScheduleProvider(query));
    final scheduleSearchRepo = useProvider(scheduleSearchListProvider);
    final schedules = scheduleSearchRepo.state;

    useEffect((){
      scheduleSearchRepo.fetch(query);
    }, []);

    final bookmarks = useProvider(bookmarkEventProvider).data?.value;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text.rich(
          TextSpan(
            text: 'イベント日程  全 ',
            style: Theme.of(context).textTheme.subtitle1.copyWith(
              fontSize: 15,
              color: Colors.white,
            ),
            children: [
              TextSpan(
                text: '${bookmarks.length ?? ' '}',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const TextSpan(
                text: ' 件',
              ),
            ],
          )
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.search),
          label: const Text('イベント'),
          onPressed: () async {
           final _query = await Navigator.of(context).pushNamed(Routes.boardsSearch, arguments: query.copyWith());
           if(_query != null){
             await Future<void>.delayed(const Duration(milliseconds: 100));
             await Navigator.of(context).pushNamed(Routes.boardsResult, arguments: _query);
           }
          },
        ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () async => scheduleSearchRepo.fetch(query),
          child: schedules.isEmpty
              ? const Center(child: Text('該当するイベントはありませんでした'),)
              : ListView.builder(
                  itemBuilder: (context, index) =>
                    ScheduleCard(
                      schedule: schedules[index],
                      onTap: () => Navigator.of(context).push(MaterialPageRoute<EventScreen>(builder: (_) => EventScreen(schedule: schedules[index]))),
                      isBookmarked: bookmarks.containsClubAndEventId(/*schedules[index].eventId*/'1', schedules[index].clubId),
                      bookmark: () => bookmarks.containsClubAndEventId(/*schedules[index].eventId*/'1', schedules[index].clubId)
                          ? unbookmarkEvent(bookmarks.getWithEventId(/*schedules[index].eventId)*/'1'))
                          : bookmarkEvent(/*schedules[index].eventId*/ '1', schedules[index].clubId),
                          
                    ),
                  itemCount: schedules.length,
                ),
        )
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
