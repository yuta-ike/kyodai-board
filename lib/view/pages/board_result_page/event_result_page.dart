import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/model/value_objects/event_query/event_query.dart';
import 'package:kyodai_board/repo/board_repo.dart';
import 'package:kyodai_board/router/routes.dart';
import 'package:kyodai_board/view/components/organism/buttom_navigation/bottom_navigation.dart';
import 'package:kyodai_board/view/components/organism/event_card/event_card.dart';
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

    final state = useState(eventSearchProvider(query));
    final events = useProvider(state.value);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text('検索結果')
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
          onRefresh: () async => print('refresh'),
          child: events.when(
            data: (events) => events.isEmpty
              ? const Center(child: Text('該当するイベントはありませんでした'),)
              : ListView.builder(
                  itemBuilder: (context, index) =>
                    EventCard(
                      events[index],
                      onTap: () => Navigator.of(context).push(MaterialPageRoute<EventScreen>(builder: (_) => EventScreen(events[index]))),
                    ),
                  itemCount: events.length,
                ),
            loading: () => const Center(child: Text('loading')),
            error: (dynamic err, st){
              print(err);
              return Center(child: Text(err.toString()));
            },
          ),
        )
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
