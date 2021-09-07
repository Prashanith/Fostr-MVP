import 'package:fostr/services/MethodeChannels.dart';
import 'package:fostr/services/UserService.dart';
import 'package:get_it/get_it.dart';

import 'AgoraService.dart';

void setupLocators() {
  GetIt.I.registerSingleton(UserService());
  GetIt.I.registerSingleton(AgoraService.init());
  GetIt.I.registerSingleton(AgoraChannel());
}
