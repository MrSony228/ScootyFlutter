import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scooty/widgets/filter_modal_bottom_sheet.dart';
import 'package:scooty/widgets/menu_modal_bottom_sheet.dart';

import '../screens/login_screen.dart';
import '../screens/registartion_screen.dart';

class MarkerWidget extends StatefulWidget {
  const MarkerWidget({Key? key}) : super(key: key);

  @override
  State<MarkerWidget> createState() {
    return _MarkerWidget();
  }
}

class _MarkerWidget extends State<MarkerWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: IconButton(
          onPressed: () {}, icon: const Icon(MdiIcons.scooterElectric, size:40 ,)),
    );
  }
}
