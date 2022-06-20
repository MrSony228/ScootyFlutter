import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../internet_engine.dart';
import '../model/bank_card.dart';
import '../model/parking_places.dart';
import '../model/transport.dart';
import '../model/user_to_register.dart';
import '../screens/qr-code_scanner.dart';
import 'bank_card_widget.dart';
import 'marker_widget.dart';

List<ParkingPlaces> parking = [];

class MapHandler extends StatelessWidget {
  final MapController mapController;

  List<Transport> transport = [];
  var position;

  MapHandler(this.mapController, parking);

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    // LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<List<ParkingPlaces>?> setTransport(
      double _maxDist, double _batteryLevel) async {
    List<GeoPoint> geoPoints = await mapController.geopoints;
    if (geoPoints.isNotEmpty) {
      for (int i = 0; i < geoPoints.length; i++) {
        await mapController.removeMarker(geoPoints[i]);
      }
    }
    var position = await _determinePosition();
    try {
      parking = (await InternetEngine().getTransport(
          position.latitude.toString(),
          position.longitude.toString(),
          _maxDist.toString(),
          _batteryLevel.toString()))!;
    } catch (set) {
      return null;
    }

    for (int i = 0; i < parking.length; i++) {
      List<Transport> transport = parking[i].transports;
      if (transport.isEmpty) {
      } else {
        addMarker(parking[i].latitude, parking[i].longitude, mapController);
        print('ok' + parking[i].toString());
      }
    }
    return parking;
  }

  String convertDistance(double distance, String one, String two, String five) {
    var n = distance.toInt().abs();
    n %= 100;
    if (n >= 5 && n <= 20) {
      return five;
    }
    n %= 10;
    if (n == 1) {
      return one;
    }
    if (n >= 2 && n <= 4) {
      return two;
    }
    return five;
  }

  String dateFormat() {
    var date = DateTime.now().add(const Duration(minutes: 5)).toLocal();
    var newFormat = DateFormat("HH:mm");
    String updatedDt = newFormat.format(date);
    return updatedDt.toString();
  }

  IconData getBatteryLevelIcon(int batteryLevel) {
    double n = batteryLevel / 10;
    switch (n.toInt()) {
      case 1:
        return MdiIcons.batteryCharging10;
      case 2:
        return MdiIcons.batteryCharging20;
      case 3:
        return MdiIcons.batteryCharging30;
      case 4:
        return MdiIcons.batteryCharging40;
      case 5:
        return MdiIcons.batteryCharging50;
      case 6:
        return MdiIcons.batteryCharging60;
      case 7:
        return MdiIcons.batteryCharging70;
      case 8:
        return MdiIcons.batteryCharging80;
      case 9:
        return MdiIcons.batteryCharging90;
      default:
        return MdiIcons.batteryCharging100;
    }
  }

  void addMarker(
      double latitude, double longitude, MapController mapController) {
    mapController.addMarker(GeoPoint(latitude: latitude, longitude: longitude),
        markerIcon: const MarkerIcon(iconWidget: MarkerWidget()));
  }

  Transport selectTransport = Transport(
      mileage: 0,
      free: true,
      price: 0,
      batteryLevel: 0,
      id: 0,
      manufacturer: '',
      description: '',
      name: '',
      latitude: 0,
      longitude: 0);

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        -1, 0, 0, 0, 255, //
        0, -1, 0, 0, 255, //
        0, 0, -1, 0, 255, //
        0, 0, 0, 1, 0, //
      ]),
      child: OSMFlutter(
        controller: mapController,
        trackMyPosition: true,
        showZoomController: true,
        // androidHotReloadSupport: true,
        initZoom: 18,
        onMapIsReady: (result) async {
          await setTransport(500, 30);
          position = await _determinePosition();
          await mapController.currentLocation();
          await mapController.setZoom(stepZoom: 14);
        },
        onLocationChanged: (GeoPoint geoPoint) async {
          await mapController.currentLocation();
        },
        onGeoPointClicked: (GeoPoint geoPoint) async {
          double distance = 0;
          position = await _determinePosition();
          for (var parkingPlace in parking) {
            if (parkingPlace.longitude == geoPoint.longitude &&
                parkingPlace.latitude == geoPoint.latitude) {
              transport = parkingPlace.transports;
              distance = await distance2point(
                  GeoPoint(
                      latitude: position.latitude.toDouble(),
                      longitude: position.longitude),
                  GeoPoint(
                      latitude: parkingPlace.latitude,
                      longitude: parkingPlace.longitude));
            }
          }
          showModalBottomSheet(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white,
                                ),
                                height: 3,
                                width: 60,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            transport[0].manufacturer,
                                            textAlign: TextAlign.left,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            transport[0].name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                MdiIcons.clockTimeThreeOutline,
                                                color: Colors.yellow,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                "Сегодня в " + dateFormat(),
                                                style: const TextStyle(
                                                    fontFamily: ""),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(children: [
                                            const Icon(
                                              MdiIcons.mapMarkerOutline,
                                              color: Colors.yellow,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              distance.toInt().toString() +
                                                  convertDistance(
                                                      distance,
                                                      " метр",
                                                      " метра",
                                                      " метров"),
                                              style: const TextStyle(
                                                  fontFamily: ""),
                                            )
                                          ]),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(children: [
                                            const Icon(
                                              MdiIcons.currencyRub,
                                              color: Colors.yellow,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              transport[0].price.toString() +
                                                  "р  в минуту",
                                              style: const TextStyle(
                                                  fontFamily: ""),
                                            )
                                          ]),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(children: [
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Icon(
                                              getBatteryLevelIcon(
                                                  transport[0].batteryLevel),
                                              color: Colors.yellow,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              transport[0]
                                                      .batteryLevel
                                                      .toString() +
                                                  " %",
                                              style: const TextStyle(
                                                  fontFamily: ""),
                                            )
                                          ]),
                                        ]),
                                  ),
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    SizedBox(
                                        width: 192,
                                        height: 202,
                                        child: Image.asset(
                                            'assets/images/electric scooter profile view 2.png')),
                                    const SizedBox(
                                      height: 22,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          showModalBottomSheet(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              isScrollControlled: true,
                                              backgroundColor: Colors.black,
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(builder:
                                                    (context, setModalState) {
                                                  return Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16,
                                                              right: 16),
                                                      child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const SizedBox(
                                                              height: 16,
                                                            ),
                                                            Center(
                                                              child: Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20)),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                height: 3,
                                                                width: 60,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 16,
                                                            ),
                                                            Row(children: [
                                                              Container(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    3,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            16,
                                                                        right:
                                                                            16),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Транспорт\nзабронирован",
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .subtitle1,
                                                                        ),
                                                                        Text(
                                                                          transport[0]
                                                                              .manufacturer,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          transport[0]
                                                                              .name,
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              8,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            const Icon(
                                                                              MdiIcons.clockTimeThreeOutline,
                                                                              color: Colors.yellow,
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 4,
                                                                            ),
                                                                            Text(
                                                                              "Сегодня в " + dateFormat(),
                                                                              style: const TextStyle(fontFamily: ""),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              8,
                                                                        ),
                                                                        Row(
                                                                            children: [
                                                                              const Icon(
                                                                                MdiIcons.mapMarkerOutline,
                                                                                color: Colors.yellow,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 4,
                                                                              ),
                                                                              Text(
                                                                                "~" + distance.toInt().toString() + convertDistance(distance, " метр", " метра", " метров"),
                                                                                style: const TextStyle(fontFamily: ""),
                                                                              )
                                                                            ]),
                                                                        const SizedBox(
                                                                          height:
                                                                              8,
                                                                        ),
                                                                        Row(
                                                                            children: [
                                                                              const Icon(
                                                                                MdiIcons.currencyRub,
                                                                                color: Colors.yellow,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 4,
                                                                              ),
                                                                              Text(
                                                                                transport[0].price.toString() + "р  в минуту",
                                                                                style: const TextStyle(fontFamily: ""),
                                                                              )
                                                                            ]),
                                                                        const SizedBox(
                                                                          height:
                                                                              8,
                                                                        ),
                                                                        Row(
                                                                            children: [
                                                                              const SizedBox(
                                                                                width: 4,
                                                                              ),
                                                                              Icon(
                                                                                getBatteryLevelIcon(transport[0].batteryLevel),
                                                                                color: Colors.yellow,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 4,
                                                                              ),
                                                                              Text(
                                                                                transport[0].batteryLevel.toString() + " %",
                                                                                style: const TextStyle(fontFamily: ""),
                                                                              )
                                                                            ]),
                                                                      ]),
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Column(children: [
                                                                SizedBox(
                                                                    width: 192,
                                                                    height: 202,
                                                                    child: Image
                                                                        .asset(
                                                                            'assets/images/electric scooter profile view 2.png')),
                                                                const SizedBox(
                                                                  height: 22,
                                                                ),
                                                              ]),
                                                            ]),
                                                            Center(
                                                              child: Row(
                                                                children: [
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        final result = await Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => const QrCodeScannerScreen()));
                                                                        setModalState(
                                                                            () {
                                                                          selectTransport =
                                                                              result;
                                                                        });

                                                                        Position
                                                                            position =
                                                                            await _determinePosition();

                                                                        var distance = await distance2point(
                                                                            GeoPoint(
                                                                                latitude: position.latitude.toDouble(),
                                                                                longitude: position.longitude),
                                                                            GeoPoint(latitude: selectTransport.latitude, longitude: selectTransport.longitude));

                                                                        if (selectTransport.id !=
                                                                            0) {
                                                                          Navigator.pop(context);
                                                                          showModalBottomSheet(
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
                                                                                      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
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
                                                                                        Row(
                                                                                          children: [
                                                                                            Container(
                                                                                              height: MediaQuery.of(context).size.height / 3,
                                                                                              padding: const EdgeInsets.only(left: 16, right: 16),
                                                                                              child: Align(
                                                                                                alignment: Alignment.centerLeft,
                                                                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                                                                                  Text(
                                                                                                    selectTransport.manufacturer,
                                                                                                    textAlign: TextAlign.left,
                                                                                                    style: Theme.of(context).textTheme.subtitle1,
                                                                                                  ),
                                                                                                  const SizedBox(
                                                                                                    height: 5,
                                                                                                  ),
                                                                                                  Text(
                                                                                                    selectTransport.name,
                                                                                                    style: Theme.of(context).textTheme.subtitle1,
                                                                                                  ),
                                                                                                  const SizedBox(
                                                                                                    height: 8,
                                                                                                  ),
                                                                                                  Row(
                                                                                                    children: [
                                                                                                      const Icon(
                                                                                                        MdiIcons.clockTimeThreeOutline,
                                                                                                        color: Colors.yellow,
                                                                                                      ),
                                                                                                      const SizedBox(
                                                                                                        width: 4,
                                                                                                      ),
                                                                                                      Text(
                                                                                                        "Сегодня в " + dateFormat(),
                                                                                                        style: const TextStyle(fontFamily: ""),
                                                                                                      )
                                                                                                    ],
                                                                                                  ),
                                                                                                  const SizedBox(
                                                                                                    height: 8,
                                                                                                  ),
                                                                                                  Row(children: [
                                                                                                    const Icon(
                                                                                                      MdiIcons.mapMarkerOutline,
                                                                                                      color: Colors.yellow,
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 4,
                                                                                                    ),
                                                                                                    Text(
                                                                                                      distance.toInt().toString() + convertDistance(distance, " метр", " метра", " метров"),
                                                                                                      style: const TextStyle(fontFamily: ""),
                                                                                                    )
                                                                                                  ]),
                                                                                                  const SizedBox(
                                                                                                    height: 8,
                                                                                                  ),
                                                                                                  Row(children: [
                                                                                                    const Icon(
                                                                                                      MdiIcons.currencyRub,
                                                                                                      color: Colors.yellow,
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 4,
                                                                                                    ),
                                                                                                    Text(
                                                                                                      selectTransport.price.toString() + "р  в минуту",
                                                                                                      style: const TextStyle(fontFamily: ""),
                                                                                                    )
                                                                                                  ]),
                                                                                                  const SizedBox(
                                                                                                    height: 8,
                                                                                                  ),
                                                                                                  Row(children: [
                                                                                                    const SizedBox(
                                                                                                      width: 4,
                                                                                                    ),
                                                                                                    Icon(
                                                                                                      getBatteryLevelIcon(selectTransport.batteryLevel),
                                                                                                      color: Colors.yellow,
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 4,
                                                                                                    ),
                                                                                                    Text(
                                                                                                      selectTransport.batteryLevel.toString() + " %",
                                                                                                      style: const TextStyle(fontFamily: ""),
                                                                                                    )
                                                                                                  ]),
                                                                                                ]),
                                                                                              ),
                                                                                            ),
                                                                                            const Spacer(),
                                                                                            Column(
                                                                                              children: [
                                                                                                SizedBox(width: 192, height: 202, child: Image.asset('assets/images/electric scooter profile view 2.png')),
                                                                                                const SizedBox(
                                                                                                  height: 22,
                                                                                                ),
                                                                                                ElevatedButton(
                                                                                                    onPressed: () async {
                                                                                                      List<BankCard> bankCards = await InternetEngine().getBankCards();
                                                                                                      UserToRegister? user = await InternetEngine().getUser();
                                                                                                      if (bankCards.isEmpty) {
                                                                                                        showDialog(
                                                                                                            context: context,
                                                                                                            builder: (context) {
                                                                                                              return AlertDialog(
                                                                                                                backgroundColor: Colors.black,

                                                                                                                // shape: RoundedRectangleBorder(
                                                                                                                //   borderRadius: BorderRadius.circular(6),
                                                                                                                //   side: const BorderSide(color: Colors.yellow),
                                                                                                                // ),
                                                                                                                title: const Text(
                                                                                                                  "Ошибка",
                                                                                                                  style: TextStyle(
                                                                                                                    color: Colors.white,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                content: const Text(
                                                                                                                  "У вас нет существующих банковских карт, хотите добавить новую?",
                                                                                                                ),
                                                                                                                actions: [
                                                                                                                  Container(
                                                                                                                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                                                                                                    child: Row(
                                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                      children: [
                                                                                                                        SizedBox(
                                                                                                                          width: 130,
                                                                                                                          child: ElevatedButton(
                                                                                                                              onPressed: () {
                                                                                                                                BankCard bankCard = BankCard(numberBankCard: "", cardDate: "", cardCvc: 0, userId: 0);
                                                                                                                                Navigator.pop(context);
                                                                                                                                BankCardModalBottomSheet(context, bankCard, user!, true).show();
                                                                                                                                return;
                                                                                                                              },
                                                                                                                              child: const Text("Да")),
                                                                                                                        ),
                                                                                                                        const Spacer(),
                                                                                                                        SizedBox(
                                                                                                                          width: 130,
                                                                                                                          child: ElevatedButton(
                                                                                                                              style: ElevatedButton.styleFrom(primary: Colors.black, onPrimary: Colors.yellow, side: const BorderSide(width: 2.0, color: Colors.yellow)),
                                                                                                                              onPressed: () {
                                                                                                                                Navigator.pop(context);
                                                                                                                                return;
                                                                                                                              },
                                                                                                                              child: const Text('Нет')),
                                                                                                                        )
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ],
                                                                                                              );
                                                                                                            });
                                                                                                      } else {
                                                                                                        Navigator.pop(context);

                                                                                                        showModalBottomSheet(
                                                                                                            shape: RoundedRectangleBorder(
                                                                                                              borderRadius: BorderRadius.circular(20.0),
                                                                                                            ),
                                                                                                            isScrollControlled: true,
                                                                                                            backgroundColor: Colors.black,
                                                                                                            context: context,
                                                                                                            builder: (context) {
                                                                                                              _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                                                                                                              return StreamBuilder<int>(
                                                                                                                  stream: _stopWatchTimer.rawTime,
                                                                                                                  initialData: 0,
                                                                                                                  builder: (context, snap) {
                                                                                                                    final value = snap.data;
                                                                                                                    final displayTime = StopWatchTimer.getDisplayTime(value!);
                                                                                                                    return Container(
                                                                                                                        padding: const EdgeInsets.only(left: 16, right: 16),
                                                                                                                        child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                                                                                                                          Row(children: [
                                                                                                                            Container(
                                                                                                                              height: MediaQuery.of(context).size.height / 3,
                                                                                                                              padding: const EdgeInsets.only(left: 16, right: 16),
                                                                                                                              child: Align(
                                                                                                                                alignment: Alignment.centerLeft,
                                                                                                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                                                                                                                  Text(
                                                                                                                                    "Поездка начата",
                                                                                                                                    style: Theme.of(context).textTheme.subtitle1,
                                                                                                                                  ),
                                                                                                                                  Text(
                                                                                                                                    selectTransport.manufacturer,
                                                                                                                                    textAlign: TextAlign.left,
                                                                                                                                  ),
                                                                                                                                  const SizedBox(
                                                                                                                                    height: 5,
                                                                                                                                  ),
                                                                                                                                  Text(
                                                                                                                                    selectTransport.name,
                                                                                                                                  ),
                                                                                                                                  const SizedBox(
                                                                                                                                    height: 8,
                                                                                                                                  ),
                                                                                                                                  Row(
                                                                                                                                    children: [
                                                                                                                                      const Icon(
                                                                                                                                        MdiIcons.clockTimeThreeOutline,
                                                                                                                                        color: Colors.yellow,
                                                                                                                                      ),
                                                                                                                                      const SizedBox(
                                                                                                                                        width: 4,
                                                                                                                                      ),
                                                                                                                                      Text(
                                                                                                                                        displayTime.substring(1, 8),
                                                                                                                                        style: const TextStyle(fontFamily: ""),
                                                                                                                                      )
                                                                                                                                    ],
                                                                                                                                  ),
                                                                                                                                  const SizedBox(
                                                                                                                                    height: 8,
                                                                                                                                  ),
                                                                                                                                  Row(children: [
                                                                                                                                    const Icon(
                                                                                                                                      MdiIcons.mapMarkerOutline,
                                                                                                                                      color: Colors.yellow,
                                                                                                                                    ),
                                                                                                                                    const SizedBox(
                                                                                                                                      width: 4,
                                                                                                                                    ),
                                                                                                                                    Text(
                                                                                                                                      "~" + distance.toInt().toString() + convertDistance(distance, " метр", " метра", " метров"),
                                                                                                                                      style: const TextStyle(fontFamily: ""),
                                                                                                                                    )
                                                                                                                                  ]),
                                                                                                                                  const SizedBox(
                                                                                                                                    height: 8,
                                                                                                                                  ),
                                                                                                                                  Row(children: [
                                                                                                                                    const Icon(
                                                                                                                                      MdiIcons.currencyRub,
                                                                                                                                      color: Colors.yellow,
                                                                                                                                    ),
                                                                                                                                    const SizedBox(
                                                                                                                                      width: 4,
                                                                                                                                    ),
                                                                                                                                    Text(
                                                                                                                                      selectTransport.price.toString() + "р  в минуту",
                                                                                                                                      style: const TextStyle(fontFamily: ""),
                                                                                                                                    )
                                                                                                                                  ]),
                                                                                                                                  const SizedBox(
                                                                                                                                    height: 8,
                                                                                                                                  ),
                                                                                                                                  Row(children: [
                                                                                                                                    const SizedBox(
                                                                                                                                      width: 4,
                                                                                                                                    ),
                                                                                                                                    Icon(
                                                                                                                                      getBatteryLevelIcon(selectTransport.batteryLevel),
                                                                                                                                      color: Colors.yellow,
                                                                                                                                    ),
                                                                                                                                    const SizedBox(
                                                                                                                                      width: 4,
                                                                                                                                    ),
                                                                                                                                    Text(
                                                                                                                                      selectTransport.batteryLevel.toString() + " %",
                                                                                                                                      style: const TextStyle(fontFamily: ""),
                                                                                                                                    )
                                                                                                                                  ]),
                                                                                                                                ]),
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            const Spacer(),
                                                                                                                            Column(children: [
                                                                                                                              SizedBox(
                                                                                                                                  width: 192,
                                                                                                                                  height: 202,
                                                                                                                                  child: Image.asset(
                                                                                                                                    'assets/images/electric scooter profile view 2.png',
                                                                                                                                    alignment: Alignment.centerLeft,
                                                                                                                                  )),
                                                                                                                              const SizedBox(
                                                                                                                                height: 22,
                                                                                                                              ),
                                                                                                                              ElevatedButton(
                                                                                                                                  style: ElevatedButton.styleFrom(primary: Colors.black, onPrimary: Colors.yellow, side: const BorderSide(width: 2.0, color: Colors.yellow)),
                                                                                                                                  onPressed: () async {
                                                                                                                                    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                                                                                                                                    var time = displayTime.substring(2, 5);
                                                                                                                                    var time1 = displayTime.substring(5, 8);
                                                                                                                                    if (time[0] == "0" || time[0] == ":") {
                                                                                                                                      time = time.substring(1, time.length);
                                                                                                                                    }
                                                                                                                                    if (time1[0] == "0" || time1[0] == ":") {
                                                                                                                                      time1 = time1.substring(1, time1.length);
                                                                                                                                    }
                                                                                                                                    var timeResult = (int.parse(time) * 60) + int.parse(time1);
                                                                                                                                    var price = selectTransport.price / 60;
                                                                                                                                    var result = timeResult * price;
                                                                                                                                    await showDialog(
                                                                                                                                        context: context,
                                                                                                                                        builder: (context) {
                                                                                                                                          return AlertDialog(
                                                                                                                                            backgroundColor: Colors.black,
                                                                                                                                            title: const Text(
                                                                                                                                              "Уведомление",
                                                                                                                                              style: TextStyle(
                                                                                                                                                color: Colors.white,
                                                                                                                                              ),
                                                                                                                                            ),
                                                                                                                                            content: Text(
                                                                                                                                              "Ваша поездка стоила: " + result.toStringAsFixed(2) + " рублей",
                                                                                                                                            ),
                                                                                                                                            actions: [
                                                                                                                                              ElevatedButton(
                                                                                                                                                  onPressed: () {
                                                                                                                                                    Navigator.pop(context);
                                                                                                                                                  },
                                                                                                                                                  child: const Text("Закрыть"))
                                                                                                                                            ],
                                                                                                                                          );
                                                                                                                                        });
                                                                                                                                    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                                                                                                                                    Navigator.pop(context);
                                                                                                                                  //  parking = (await MapHandler(mapController, parking).setTransport(_maxDist, _batteryLevel))!;
                                                                                                                                    return;
                                                                                                                                  },
                                                                                                                                  child: const Text('Закончить ')),
                                                                                                                            ]),
                                                                                                                          ])
                                                                                                                        ]));
                                                                                                                  });
                                                                                                            });
                                                                                                      }
                                                                                                    },
                                                                                                    child: const Text(
                                                                                                      'Начать поездку',
                                                                                                    )),
                                                                                                const SizedBox(
                                                                                                  height: 42,
                                                                                                ),
                                                                                              ],
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ]));
                                                                                });
                                                                              });
                                                                        }
                                                                      },
                                                                      child: const Text(
                                                                          'Начать поездку')),
                                                                  const Spacer(),
                                                                  ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          primary: Colors
                                                                              .black,
                                                                          onPrimary: Colors
                                                                              .yellow,
                                                                          side: const BorderSide(
                                                                              width:
                                                                                  2.0,
                                                                              color: Colors
                                                                                  .yellow)),
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator.pop(
                                                                            context);
                                                                        //  parking = (await MapHandler(mapController, parking).setTransport(_maxDist, _batteryLevel))!;
                                                                        return;
                                                                      },
                                                                      child: const Text(
                                                                          'Отмена')),
                                                                ],
                                                              ),
                                                            ),
                                                          ]));
                                                });
                                              });
                                        },
                                        child: const Text(
                                          'Забронировать',
                                        )),
                                    const SizedBox(
                                      height: 42,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ]));
                });
              });
        },
        // userLocationMarker: UserLocationMaker(
        //   personMarker: const MarkerIcon(
        //     icon: Icon(
        //       MdiIcons.circleSmall,
        //       color: Colors.transparent,
        //       size: 0,
        //     ),
        //   ),
        //   directionArrowMarker: const MarkerIcon(
        //     icon: Icon(
        //       Icons.double_arrow,
        //       color: Color(0xff0014c4),
        //       size: 170,
        //     ),
        //   ),
        // ),
        // roadConfiguration: RoadConfiguration(
        //   startIcon: const MarkerIcon(
        //     icon: Icon(
        //       CustomIcons.location,
        //       size: 64,
        //       color: Colors.brown,
        //     ),
        //   ),
        //   roadColor: Colors.yellowAccent,
        // ),
        // markerOption: MarkerOption(
        //     defaultMarker: const MarkerIcon(
        //   icon: Icon(
        //     CustomIcons.location,
        //     color: Colors.blue,
        //     size: 56,
        //   ),
        // )),
      ),
    );
  }
}
