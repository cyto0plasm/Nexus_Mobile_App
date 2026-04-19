import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/core/helpers/dio_client.dart';
import 'package:nexus/core/localization/locale_cubit.dart';
import 'package:nexus/core/localization/locale_service.dart';
import 'package:nexus/core/routing/app_router.dart';
import 'package:nexus/NexusApp.dart';
import 'package:nexus/di.dart';
import 'package:nexus/features/Feedback/flash_bar.dart';
import 'package:nexus/features/cubit/auth/auth_cubit.dart';
import 'package:nexus/features/cubit/feedback/flash_cubit.dart';
import 'package:nexus/repositories/auth_repo.dart';
import 'package:nexus/services/auth_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  


  DioClient.init();
  setupDI();
  
  final initialLocale = await LocaleService.resolveLocale();

 runApp(
  MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => LocaleCubit()..loadSavedLocale()),
      BlocProvider(create: (_) => getIt<FlashCubit>()),
      BlocProvider(create: (_) => getIt<AuthCubit>()),
    ],
    child: NexusApp(
      appRouter: AppRouter(authRepo: getIt()),
      initialLocale: initialLocale,
    ),
  ),
);

}