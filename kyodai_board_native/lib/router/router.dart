import 'package:flutter/material.dart';
import 'package:kyodai_board/firebase/firebase_auth.dart';
import 'package:kyodai_board/model/value_objects/event_query/event_query.dart';
import 'package:kyodai_board/view/pages/auth/login_page.dart';
import 'package:kyodai_board/view/pages/board_page/board_page.dart';
import 'package:kyodai_board/view/pages/board_page/event_search_screen.dart';
import 'package:kyodai_board/view/pages/board_result_page/event_result_page.dart';
import 'package:kyodai_board/view/pages/chat_page/chat_page.dart';
import 'package:kyodai_board/view/pages/chat_page/chat_screen.dart';
import 'package:kyodai_board/view/pages/club_page/club_page.dart';
import 'package:kyodai_board/view/pages/my_page/my_page.dart';
import 'package:kyodai_board/view/pages/setting_page/setting_page.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    if(auth.currentUser == null){
      switch (settings.name) {
        case '/':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/'),
            pageBuilder: (_, __, ___) => LoginPage(),
          );

        case '/login':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/login'),
            pageBuilder: (_, __, ___) => LoginPage(),
          );
        
        case '/register':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/register'),
            pageBuilder: (_, __, ___) => MyPage(),
          );

        case '/password/resend':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/password/resend'),
            pageBuilder: (_, __, ___) => MyPage(),
          );
        
        case '/password/reset':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/password/reset'),
            pageBuilder: (_, __, ___) => MyPage(),
          );
        
        default:
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/mypage'),
            pageBuilder: (_, __, ___) => LoginPage(),
          );
      }
    }else{
      switch (settings.name) {
        case '/':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/mypage'),
            pageBuilder: (_, __, ___) => MyPage(),
          );

        case '/mypage':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/mypage'),
            pageBuilder: (_, __, ___) => MyPage(),
          );

        case '/boards':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/boards'),
            pageBuilder: (_, __, ___) => const BoardPage(),
          );

        case '/boards/search':
          final query = settings.arguments as EventQuery;
          return MaterialPageRoute<EventQuery>(
            settings: const RouteSettings(name: '/boards/search'),
            builder: (_) => EventSearchScreen(query: query),
            fullscreenDialog: true,
          );
        
        case '/boards/result':
          final query = settings.arguments as EventQuery;
          return MaterialPageRoute<void>(
            settings: const RouteSettings(name: '/boards/result'),
            builder: (_) => EventResultPage(query: query),
          );
        
        case '/clubs':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/clubs'),
            pageBuilder: (_, __, ___) => ClubPage(),
          );

        case '/chat':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/chat'),
            pageBuilder: (_, __, ___) => ChatPage(),
          );

        case '/chat/detail':
          final chatId = settings.arguments as String;
          return MaterialPageRoute<int>(
            settings: const RouteSettings(name: '/chat'),
            builder: (_) => ChatScreen(chatId),
          );

        case '/settings':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/clubs'),
            pageBuilder: (_, __, ___) => SettingPage(),
          );
        
        case '/splash':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/mypage'),
            pageBuilder: (_, __, ___) => MyPage(),
          );

        default:
          return PageRouteBuilder<void>(
            pageBuilder: (_, __, ___) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')),
            )
          );
      }
    }
  }
}