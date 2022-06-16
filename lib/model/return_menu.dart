import 'package:scooty/model/parking_places.dart';

class ReturnMenu{

  ReturnMenu({
   required this.parking,
   required this.batteryLevel,
   required this.maxDist
});

  late double maxDist;
  late double batteryLevel;
  late List<ParkingPlaces> parking;


}