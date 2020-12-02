import 'package:Setel_Test_Assignment/service/connection_service.dart';
import 'package:Setel_Test_Assignment/service/location_service.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';
import './util/network_config.dart';

// import 'core/services/database.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // for services or viewmodels that needs to be kept alive throughout the app

  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => SnackbarService());

  // locator.registerLazySingleton(() => API());
  locator.registerLazySingleton(() => LocationService());
  locator.registerLazySingleton(() => ConnectionService());
}
