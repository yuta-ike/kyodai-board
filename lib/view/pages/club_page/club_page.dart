import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/repo/club_repo.dart';
import 'package:kyodai_board/view/components/organism/buttom_navigation/bottom_navigation.dart';
import 'package:kyodai_board/view/components/organism/club_card/club_card.dart';
import 'package:kyodai_board/view/pages/club_page/club_tabs.dart';
import 'package:kyodai_board/view/screens/club_screen.dart';

class ClubPage extends HookWidget{
  @override
  Widget build(BuildContext context) {

    final clubs = useProvider(clubProvider);

    return DefaultTabController(
      length: 9,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          bottom: TabBar(
            isScrollable: true,
            tabs: ClubTabs.values.map((clubTab) => Tab(text: clubTab.format)).toList(),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
              icon: const Icon(Icons.search),
              label: const Text('団体'),
              onPressed: () => print('団体検索'),
            ),
        body: TabBarView(
          children: List.generate(9, (index) =>
            Center(
              child: RefreshIndicator(
                onRefresh: () async => print('refresh'),
                child: clubs.when(
                  data: (clubs) => ListView.builder(
                    itemCount: clubs.length,
                    itemBuilder: (context, index) =>
                        ClubCard(
                          clubs[index],
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<ClubScreen>(
                              builder: (_) => ClubScreen(clubs[index])
                            )
                          ),
                        ),
                  ),
                  loading: () => const Center(child: Text('loading')),
                  error: (dynamic err, st){
                    print(err);
                    return Center(child: Text(err.toString()));
                  },
                ),
              ),
            ),
          ).toList(),
        ),
        bottomNavigationBar: BottomNavigation(),
      ),
    );
  }
}