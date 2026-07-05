import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'config/routes/app_router.dart';
import 'config/theme/app_theme.dart';
import 'feature/authentication/presentation/bloc/authentication_bloc.dart';
import 'injection_container.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: '.env');
  await initDependencies();

  // Kick off the session hydration before the first frame so the router's
  // redirect logic can immediately decide between /login and /home.
  sl<AuthenticationBloc>().add(const AuthCheckRequested());

  runApp(const MediLogixApp());

  FlutterNativeSplash.remove();
}

class MediLogixApp extends StatefulWidget {
  const MediLogixApp({super.key});

  @override
  State<MediLogixApp> createState() => _MediLogixAppState();
}

class _MediLogixAppState extends State<MediLogixApp> {
  late final AuthenticationBloc _authBloc = sl<AuthenticationBloc>();
  late final GoRouter _router = buildAppRouter(_authBloc);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>.value(
      value: _authBloc,
      child: ScreenUtilInit(
        designSize: const Size(374, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'MediLogix',
            theme: AppTheme.light,
            routerConfig: _router,
            builder: (context, routerChild) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1),
                ),
                child: routerChild!,
              );
            },
          );
        },
      ),
    );
  }
}
