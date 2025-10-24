import 'package:auto_route/auto_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../shared/services/notification/notification.dart';
import '../routers/router.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key, this.initialMessage}) : super(key: key);
  final RemoteMessage? initialMessage;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = getIt.get<AppRouter>();

  @override
  Widget build(BuildContext context) {
    if (widget.initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final id = widget.initialMessage!.data['order_id'];
        if (id != null) {
          _appRouter.push(
            OrderDetailRoute(
              order: id,
              typeOrder: TypeOrder.ad,
              isDrafOrder: true,
            ),
          );
        }
      });
    }
    initializeDateFormatting('vi_VN', null);

    return MaterialApp.router(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        final MediaQueryData data = MediaQuery.of(context);

        return MediaQuery(
          data: data.copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      routerDelegate: _appRouter.delegate(
        // initialRoutes: _mapRouteToPageRouteInfo(),
        deepLinkBuilder: (deepLink) => DeepLink(_mapRouteToPageRouteInfo()),
        // navigatorObservers: () => [AppNavigatorObserver()],
      ),
      routeInformationParser: _appRouter.defaultRouteParser(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
    );
  }

  List<PageRouteInfo> _mapRouteToPageRouteInfo() {
    final token = AppSharedPreference.instance.getValue(PrefKeys.token);
    if (token == null) {
      return [const LoginV2Route()];
    } else {
      return [const HomeRoute()];
    }
  }
}
