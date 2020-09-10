import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyodai_board/model/value_objects/query/club_query.dart';
import 'package:kyodai_board/model/club_bookmark.dart';
import 'package:kyodai_board/repo/club_repo.dart';
import 'package:kyodai_board/repo/user_repo.dart';
import 'package:kyodai_board/router/routes.dart';
import 'package:kyodai_board/view/components/organism/buttom_navigation/bottom_navigation.dart';
import 'package:kyodai_board/view/components/organism/club_card/club_card.dart';
import 'package:kyodai_board/view/pages/club_page/club_tabs.dart';
import 'package:kyodai_board/view/screens/club_screen.dart';

class ClubPage extends HookWidget{
  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 9);

    final clubs = useProvider(clubListProvider.state);
    final clubsRepo = useProvider(clubListProvider);
    final bookmarks = useProvider(bookmarkClubProvider).data?.value;

    useEffect((){
      clubsRepo.fetch();
    }, []);

    return DefaultTabController(
      length: 9,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          bottom: TabBar(
            controller: tabController,
            isScrollable: true,
            tabs: ClubTabs.values.map((clubTab) => Tab(text: clubTab.format)).toList(),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
              icon: const Icon(Icons.search),
              label: const Text('団体'),
              onPressed: () async {
                final query = await Navigator.of(context).pushNamed(Routes.clubsSearch, arguments: ClubQuery());
                if(query != null){
                  await Future<void>.delayed(const Duration(milliseconds: 100));
                  await Navigator.of(context).pushNamed(Routes.clubsResult, arguments: query);
                }
              },
            ),
        body: TabBarView(
          controller: tabController,
          children: List.generate(ClubTabs.values.length, (pageIndex) {
            if(pageIndex == 0){
              return RefreshIndicator(
                onRefresh: () async => clubsRepo.fetch(),
                child: clubs == null ? const Center(child: Text('loading')) : clubs.isEmpty ? const Center(child: Text('該当する団体はありません'))
                  : ListView.builder(
                      itemCount: clubs.length,
                      itemBuilder: (context, index) =>
                          ClubCard(
                            clubs[index],
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<ClubScreen>(
                                builder: (_) => ClubScreen(club: clubs[index])
                              ),
                            ),
                            isBookmarked: bookmarks?.containsClubId(clubs[index].id),
                            bookmark: bookmarks == null ? null : () =>
                                bookmarks.containsClubId(clubs[index].id)
                                  ? unbookmarkClub(bookmarks.getWithClubId(clubs[index].id))
                                  : bookmarkClub(clubs[index].id)
                          ),
                    ),
              );
            }else{
              final filteredClubs = clubs.where((club) => club.profile.clubType == ClubTabs.values[pageIndex].clubType).toList();
              return RefreshIndicator(
                onRefresh: () async => clubsRepo.fetch(),
                child: clubs == null ? const Center(child: Text('loading')) : filteredClubs.isEmpty ? const Center(child: Text('該当する団体はありませんでした'))
                  : ListView.builder(
                      itemCount: filteredClubs.length,
                      itemBuilder: (context, index) {
                        final club = filteredClubs[index];
                        return ClubCard(
                            club,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<ClubScreen>(
                                builder: (_) => ClubScreen(club: club)
                              )
                            ),
                            isBookmarked: bookmarks?.containsClubId(club.id),
                            bookmark: bookmarks == null ? null : () =>
                                bookmarks.containsClubId(club.id)
                                  ? unbookmarkClub(bookmarks.getWithClubId(club.id))
                                  : bookmarkClub(club.id)
                          );
                      },
                    ),
              );
            }
          }).toList(),
        ),
        bottomNavigationBar: BottomNavigation(),
      ),
    );
  }
}