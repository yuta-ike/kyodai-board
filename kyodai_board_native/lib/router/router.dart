import 'package:flutter/material.dart';
import 'package:kyodai_board/firebase/firebase_auth.dart';
import 'package:kyodai_board/model/chat_room.dart';
import 'package:kyodai_board/model/value_objects/query/club_query.dart';
import 'package:kyodai_board/model/value_objects/query/event_query.dart';
import 'package:kyodai_board/router/route_builders/only_reverse_animation_route_builder.dart';
import 'package:kyodai_board/view/pages/auth/email_verify_page.dart';
import 'package:kyodai_board/view/pages/auth/login_page.dart';
import 'package:kyodai_board/view/pages/auth/register_page.dart';
import 'package:kyodai_board/view/pages/auth/top_page.dart';
import 'package:kyodai_board/view/pages/board_page/board_page.dart';
import 'package:kyodai_board/view/pages/board_page/event_search_screen.dart';
import 'package:kyodai_board/view/pages/board_result_page/event_result_page.dart';
import 'package:kyodai_board/view/pages/chat_page/chat_page.dart';
import 'package:kyodai_board/view/pages/chat_page/chat_screen.dart';
import 'package:kyodai_board/view/pages/chat_page/chat_temporary_screen.dart';
import 'package:kyodai_board/view/pages/club_page/club_page.dart';
import 'package:kyodai_board/view/pages/club_page/club_search_screen.dart';
import 'package:kyodai_board/view/pages/club_result_page/club_result_page.dart';
import 'package:kyodai_board/view/pages/my_page/my_page.dart';
import 'package:kyodai_board/view/pages/setting_page/setting_page.dart';
import 'package:kyodai_board/view/screens/account_setting_screens/account_screen.dart';
import 'package:kyodai_board/view/screens/notify_screen.dart';
import 'package:kyodai_board/view/screens/version_screen.dart';

class RouterProp<T>{
  const RouterProp(this.arguments, { this.implicit = false });
  final T arguments;
  final bool implicit;
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final isAuthenticated = auth.currentUser != null;
    // TODO: チャット画面にログインへのメッセージ
    // TODO: チャット画面へ遷移しようとするとログインへの導線

    if(!isAuthenticated){
      switch (settings.name) {
        case '/':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/'),
            pageBuilder: (_, __, ___) => TopPage(),
          );

        case '/top':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/top'),
            pageBuilder: (_, __, ___) => TopPage(),
          );
        
        case '/login':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/login'),
            pageBuilder: (_, __, ___) => LoginPage(),
          );
        
        case '/register':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/register'),
            pageBuilder: (_, __, ___) => RegisterPage(),
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
            pageBuilder: (_, __, ___) => TopPage(),
          );
      }
    } else {
      switch (settings.name) {
        case '/':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/mypage'),
            pageBuilder: (_, __, ___) => MyPage(),
          );

        case '/emailVerify':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/emailVerify'),
            pageBuilder: (_, __, ___) => EmailVerifyPage(),
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
            builder: (_) => EventSearchScreen(eventQuery: query),
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

        case '/clubs/search':
          final query = settings.arguments as ClubQuery;
          return MaterialPageRoute<void>(
            settings: const RouteSettings(name: '/clubs'),
            builder: (_) => ClubSearchScreen(query: query),
            fullscreenDialog: true,
          );
        
        case '/clubs/result':
          final query = settings.arguments as ClubQuery;
          return MaterialPageRoute<void>(
            settings: const RouteSettings(name: '/clubs'),
            builder: (_) => ClubResultPage(query: query),
            fullscreenDialog: true,
          );
        
        case '/settings':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/clubs'),
            pageBuilder: (_, __, ___) => SettingPage(),
          );
        
        case '/settings/notify':
          return MaterialPageRoute<void>(
            settings: const RouteSettings(name: '/settings/notify'),
            builder: (_) => const NotifyScreen(),
          );
        
        case '/settings/version':
          return MaterialPageRoute<void>(
            settings: const RouteSettings(name: '/settings/version'),
            builder: (_) => const VersionScreen(),
          );

        case '/splash':
          return PageRouteBuilder<void>(
            settings: const RouteSettings(name: '/mypage'),
            pageBuilder: (_, __, ___) => MyPage(),
          );
      }

      final isAnonymous = auth.currentUser.isAnonymous;
      final isVerified = auth.currentUser.emailVerified;

      if(isAnonymous || !isVerified){
        return PageRouteBuilder<void>(
          pageBuilder: (_, __, ___) => Scaffold(
            body: Center(
                child: Text('No route defined for ${settings.name}')),
          )
        );
      }else{
        // TODO: チャット利用前にログインを促す
        switch(settings.name){
          case '/settings/account':
            return MaterialPageRoute<int>(
                settings: const RouteSettings(name: '/chat/detail'),
                builder: (_) => AccountScreen(),
              );
          case '/chat':
            return PageRouteBuilder<void>(
              settings: const RouteSettings(name: '/chat'),
              pageBuilder: (_, __, ___) => ChatPage(),
            );

          case '/chat/detail':
            final props = settings.arguments as RouterProp<ChatRoom>;
            if(props.implicit){
              return OnlyReverseAnimationPageRoute<void>(
                settings: const RouteSettings(name: '/chat/detail'),
                builder: (_) => ChatScreen(props.arguments),
              );
            }else{
              return MaterialPageRoute<int>(
                settings: const RouteSettings(name: '/chat/detail'),
                builder: (_) => ChatScreen(props.arguments),
              );
            }
            break;
          
          case '/chat/temporary':
            final clubId = settings.arguments as String;
            return MaterialPageRoute<int>(
              settings: const RouteSettings(name: '/chat/temporary'),
              builder: (_) => ChatTemporaryScreen(clubId),
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
}