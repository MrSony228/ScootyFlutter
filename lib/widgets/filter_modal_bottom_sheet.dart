import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:scooty/model/parking_places.dart';
import 'package:scooty/model/return_menu.dart';
import 'package:scooty/screens/main_screen.dart';

import 'map_handler.dart';

class FilterModalBottomSheet {
  final BuildContext context;
  double _batteryLevel;
  double _maxDist;
  MapController mapController;
   List<ParkingPlaces> parking;

  FilterModalBottomSheet(this.context, this._batteryLevel, this._maxDist,
      this.parking, this.mapController);

  Future<ReturnMenu> show() async{
    ReturnMenu result = ReturnMenu(parking: parking, batteryLevel: _batteryLevel, maxDist: _maxDist);
   await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.black,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      height: 3,
                      width: 60,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Уровень батареи',
                              textAlign: TextAlign.left,
                            )),
                        Slider(
                          min: 0.0,
                          max: 100.0,
                          label: _batteryLevel.toInt().toString() + " %",
                          divisions: 100,
                          activeColor: const Color(0xff3B3D10),
                          inactiveColor: const Color(0xff454545),
                          thumbColor: Colors.yellow,
                          value: _batteryLevel,
                          onChanged: (value) {
                            setModalState(() {
                              _batteryLevel = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Дистанция до транспорта',
                              textAlign: TextAlign.left,
                            )),
                        Slider(
                          min: 0.0,
                          max: 1000.0,
                          label: _maxDist.toInt().toString() + " m",
                          divisions: 1000,
                          activeColor: const Color(0xff3B3D10),
                          inactiveColor: const Color(0xff454545),
                          thumbColor: Colors.yellow,
                          value: _maxDist,
                          onChanged: (value) {
                            setModalState(() {
                              _maxDist = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                              onPressed: () async {
                                for (var parkingPlace in parking) {
                                  await mapController.removeMarker(GeoPoint(
                                      latitude: parkingPlace.latitude,
                                      longitude: parkingPlace.longitude));
                                }
                                parking = (await MapHandler(mapController, parking).setTransport(_maxDist, _batteryLevel))!;
                                result = ReturnMenu(parking: parking, batteryLevel: _batteryLevel, maxDist: _maxDist);
                                Navigator.pop(
                                    context, result);
                              },
                              child: const Text("Показать")),
                        ),
                        const SizedBox(
                          height: 42,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          });
        });
    return result;
  }
}
