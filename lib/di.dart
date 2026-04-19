import 'package:get_it/get_it.dart';
import 'package:nexus/features/cubit/auth/auth_cubit.dart';
import 'package:nexus/features/cubit/feedback/flash_cubit.dart';
import 'package:nexus/repositories/auth_repo.dart';
import 'package:nexus/services/auth_services.dart';

final getIt = GetIt.instance;

void setupDI() {
  getIt.registerLazySingleton<AuthServices>(() => AuthServices());
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepo(authServices: getIt<AuthServices>()),
  );
  getIt.registerLazySingleton(() => AuthCubit(getIt<AuthRepo>()));
  getIt.registerLazySingleton(() => FlashCubit());

}