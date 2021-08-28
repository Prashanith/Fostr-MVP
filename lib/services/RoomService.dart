import 'package:fostr/core/data.dart';

class RoomService {
  const RoomService._();

  getRooms(id) async {
    roomCollection.doc(id).collection("rooms").snapshots();
  }
}
