import 'package:trip_planner/domain/io/net/dio_client.dart';
import 'package:trip_planner/domain/io/net/i_dio_client.dart';
import 'package:dio/dio.dart';
import 'package:spot_di/spot_di.dart';

abstract class SpotModule {
  static void registerDependencies() {
    Spot.init((factory, single) {
      // Networking
      single<Dio, Dio>((get) => Dio());
      single<IDioClient, DioClient>((get) => DioClient());

      // DAOs
      // single<AUserDao, AUserDao>((get) => UserDao());
      
      // Repositories
      // factory<IExampleRepo, ExampleRepo>((get) => ExampleRepo());

      // Services
      // single<IExampleService, ExampleService>((get) => ExampleService(get<IDioClient>()));

      // Core Services
      // factory<IAuthService, AuthService>((get) => AuthService());
    });
  }
}

abstract class TestSpotModule extends SpotModule {
  static void registerDependencies() {
    Spot.init((factory, single) {

    });
  }
}
