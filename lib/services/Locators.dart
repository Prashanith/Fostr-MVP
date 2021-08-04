import 'package:fostr/services/UserService.dart';
import 'package:get_it/get_it.dart';

void setupLocators() {
  GetIt.I.registerLazySingleton(() => UserService());
}
