import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus/auth_gate.dart';
import 'package:nexus/core/localization/locale_cubit.dart';
import 'package:nexus/core/routing/app_router.dart';
import 'package:nexus/core/theme/colors.dart';
import 'package:nexus/features/Feedback/flash_bar.dart';
import 'package:nexus/l10n/app_localizations.dart';

class NexusApp extends StatelessWidget {
  final AppRouter appRouter;
  final Locale initialLocale;


  const NexusApp({
    super.key,
    required this.appRouter,
    required this.initialLocale, 
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      
      builder: (context, locale) {
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
            locale: locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            title: "Nexus",
            theme: ThemeData(
              primaryColor: ColorsManager.Primary,
              scaffoldBackgroundColor: Colors.white,
            ),
            debugShowCheckedModeBanner: false,
            home: AuthGate(),
            onGenerateRoute: appRouter.generateRoute,
            builder: (context, child) => FlashBar(child: child!),
          ),
        );
      },
    );
  }
}