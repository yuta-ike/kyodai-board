import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/model/value_objects/query/club_query.dart';
import 'package:kyodai_board/repo/club_repo.dart';
import 'package:kyodai_board/router/routes.dart';
import 'package:kyodai_board/view/components/organism/buttom_navigation/bottom_navigation.dart';
import 'package:kyodai_board/view/components/organism/club_card/club_card.dart';
import 'package:kyodai_board/view/screens/club_screen.dart';
import 'package:kyodai_board/view/screens/event_screen.dart';

class ClubResultPage extends HookWidget{
  const ClubResultPage({this.query});

  final ClubQuery query;

  @override
  Widget build(BuildContext context) {

    final clubs = useProvider(clubSearchProvider(query));

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: clubs.when(
          loading: () => null,
          error: (dynamic _, __) => null,
          data: (clubs) => Text.rich(
            TextSpan(
              text: '検索結果  全 ',
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                fontSize: 15,
                color: Colors.white,
              ),
              children: [
                TextSpan(
                  text: '${clubs.length ?? ' '}',
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
          child: clubs.when(
            data: (clubs) => clubs.isEmpty
              ? const Center(child: Text('該当する団体はありませんでした'),)
              : ListView.builder(
                  itemBuilder: (context, index) =>
                    ClubCard(
                      clubs[index],
                      onTap: () => Navigator.of(context).push(MaterialPageRoute<EventScreen>(builder: (_) => ClubScreen(club: clubs[index]))),
                    ),
                  itemCount: clubs.length,
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
