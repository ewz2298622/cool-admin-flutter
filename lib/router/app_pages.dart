import 'package:flutter_app/views/album/album.dart';
import 'package:flutter_app/views/cash/cash.dart';
import 'package:flutter_app/views/connection_error/connection_error.dart';
import 'package:flutter_app/views/environment_error/environment_error.dart';
import 'package:flutter_app/views/feedback/feedback.dart';
import 'package:flutter_app/views/htmlPage/html.dart';
import 'package:flutter_app/views/invite/invite.dart';
import 'package:flutter_app/views/live_detail/live_detail.dart';
import 'package:flutter_app/views/login/login.dart';
import 'package:flutter_app/views/score/score.dart';
import 'package:flutter_app/views/search/result/search_result.dart';
import 'package:flutter_app/views/splash_page/splash_page.dart';
import 'package:flutter_app/views/week/week.dart';
import 'package:flutter_app/router/routes.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../views/cash_order/cash_order.dart';
import '../views/notice/notice.dart';
import '../views/score_order/score_order.dart';
import '../views/search/search.dart';
import '../views/short_drama/short_drama.dart';
import '../views/video_detail/detail.dart';

final List<GetPage> appGetPages = [
  GetPage(name: AppRoutes.splash, page: () => SplashPage()),
  GetPage(name: AppRoutes.main, page: () => MainPage()),
  GetPage(name: AppRoutes.videoDetail, page: () => VideoDetail()),
  GetPage(name: AppRoutes.shortDrama, page: () => ShortDrama()),
  GetPage(name: AppRoutes.notice, page: () => Notice()),
  GetPage(name: AppRoutes.html, page: () => HtmlPage()),
  GetPage(name: AppRoutes.week, page: () => WeekPage()),
  GetPage(name: AppRoutes.search, page: () => VideoSearch()),
  GetPage(name: AppRoutes.searchResult, page: () => SearchResult()),
  GetPage(name: AppRoutes.login, page: () => Login()),
  GetPage(name: AppRoutes.feedback, page: () => FeedbackPage()),
  GetPage(name: AppRoutes.score, page: () => TaskCenterPage()),
  GetPage(name: AppRoutes.scoreOrder, page: () => ScoreOrder()),
  GetPage(name: AppRoutes.connectionError, page: () => ConnectionError()),
  GetPage(name: AppRoutes.videoAlbum, page: () => VideoAlbum()),
  GetPage(name: AppRoutes.liveDetail, page: () => Live_Detail()),
  GetPage(name: AppRoutes.inviteRecord, page: () => InviteCenterPage()),
  GetPage(name: AppRoutes.cashPage, page: () => CashPage()),
  GetPage(name: AppRoutes.cashOrder, page: () => CashOrder()),
  GetPage(name: AppRoutes.environmentError, page: () => EnvironmentError()),
];
