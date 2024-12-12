import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/service/api_singleton.dart';
import 'package:mobile/widget/restart_widget.dart';
import 'package:provider/provider.dart';

import 'routing/app_route_config.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final GoRouter router = appRouting();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(374, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          builder: (context, routerChild) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1),
                ),
                child: routerChild!);
          },
          debugShowCheckedModeBanner: false,
          // Uncomment the following lines to enable localization for translation
          // supportedLocales: const [
          //   Locale('en'),
          //   Locale('fr'),
          // ],
          // locale: Provider.of<LanguageProvider>(context).currentLocale,
          // localizationsDelegates: const [
          //   AppLocalizations.delegate,
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          //   GlobalCupertinoLocalizations.delegate,
          // ],

          routerConfig: router,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
            ),
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Poppins',
          ),
        );
      },
    );
  }
}

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  RestartWidget restartWidget = const RestartWidget(child: Main());
  await ApiSingleton().init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => null), // This is a dumb provider, please fill it with actual provider
      ],
      child: restartWidget,
    ),
  );
  FlutterNativeSplash.remove();
}
