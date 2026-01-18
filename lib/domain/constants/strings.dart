class ConstantsStrings {
  final appName = 'Trip Planner';
  final appSlug = 'trip-planner';
  final useLocalApiServer = false;

  String get baseUrl {
    const bool isProduction = bool.fromEnvironment('dart.vm.product');

    if (isProduction || !useLocalApiServer) {
      return 'https://trip-planner-basic.vercel.app/api';
    } else {
      return 'http://localhost:3002/api';
    }
  }
}
