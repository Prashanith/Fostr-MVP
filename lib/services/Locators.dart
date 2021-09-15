import 'package:get_it/get_it.dart';

import 'AgoraService.dart';
import 'MethodeChannels.dart';
import 'RatingsService.dart';
import 'RoomService.dart';
import 'UserService.dart';

void setupLocators() {
  GetIt.I.registerSingleton(UserService());
  GetIt.I.registerSingleton(AgoraService.init());
  GetIt.I.registerSingleton(AgoraChannel());
  GetIt.I.registerSingleton(RatingService());
  GetIt.I.registerSingleton(RoomService());
}
