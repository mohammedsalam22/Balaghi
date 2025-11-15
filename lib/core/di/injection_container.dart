import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';
import '../storage/secure_storage_service.dart';
import '../theme/theme_service.dart';
import '../localization/localization_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth/auth_cubit.dart';
import '../../features/complaints/data/datasources/complaint_remote_datasource.dart';
import '../../features/complaints/data/repositories/complaint_repository_impl.dart';
import '../../features/complaints/domain/repositories/complaint_repository.dart';
import '../../features/complaints/presentation/cubit/complaints/complaint_cubit.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // Initialize SharedPreferences with retry logic
  SharedPreferences? sharedPreferences;
  int retries = 3;

  while (retries > 0 && sharedPreferences == null) {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
    } catch (e) {
      retries--;
      if (retries > 0) {
        await Future.delayed(const Duration(milliseconds: 200));
      } else {
        // If all retries fail, throw error
        throw Exception('Failed to initialize SharedPreferences: $e');
      }
    }
  }

  if (sharedPreferences == null) {
    throw Exception('Failed to initialize SharedPreferences after retries');
  }

  final prefs = sharedPreferences; // Already null-checked above
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  sl.registerLazySingleton(() => SecureStorageService());
  sl.registerLazySingleton(
    () => DioClient(storageService: sl<SecureStorageService>()),
  );

  // Theme Service
  final themeService = ThemeService(prefs);
  await themeService.init(); // Initialize theme service
  sl.registerLazySingleton<ThemeService>(() => themeService);

  // Localization Service
  final localizationService = LocalizationService(prefs);
  await localizationService.init(); // Initialize localization service
  sl.registerLazySingleton<LocalizationService>(() => localizationService);

  // Auth - Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: sl()),
  );

  // Auth - Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), storageService: sl()),
  );

  // Auth - Cubits (Factory to create new instance each time)
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      repository: sl<AuthRepository>(),
      storageService: sl<SecureStorageService>(),
    ),
  );

  // Complaints - Data Sources
  sl.registerLazySingleton<ComplaintRemoteDataSource>(
    () => ComplaintRemoteDataSourceImpl(dioClient: sl()),
  );

  // Complaints - Repositories
  sl.registerLazySingleton<ComplaintRepository>(
    () => ComplaintRepositoryImpl(remoteDataSource: sl()),
  );

  // Complaints - Cubits (Factory to create new instance each time)
  sl.registerFactory<ComplaintCubit>(
    () => ComplaintCubit(repository: sl<ComplaintRepository>()),
  );
}
