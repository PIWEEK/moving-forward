import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart';

class Resource extends StatelessWidget {
  ListTile _dataRow(IconData icon, String title, Color color) {
    return ListTile(
      leading: Icon(
        icon,
        size: 24.0,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: color,
        ),
      ),
      dense: true,
    );
  }

  Container _dataSection() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: Column(
          children: [
            _dataRow(Icons.location_on, 'Calle Barbate, 62, 1oC, 11012',
                MfColors.dark),
            _dataRow(Icons.call, '915 123 456', MfColors.dark),
            _dataRow(
                Icons.access_time, 'L - V de 9:00h a 18:00h', MfColors.dark),
            _dataRow(
                Icons.mail_outline, 'cadiz@apdha.org', MfColors.primary[400]),
            _dataRow(Icons.whatshot, '667 123 456', MfColors.dark),
            _dataRow(Icons.public, 'apdhacadiz. wordpress.com',
                MfColors.primary[400]),
            _dataRow(Icons.public, 'http://es-la.facebook.com/apdha.cadiz.1',
                MfColors.primary[400]),
          ],
        ));
  }

  // TODO: remove when real data
  final String phone = 'tel:+0034625528029';
  final String email = 'mailto:hola@xaviju.dev';
  final String url = 'https://github.com/PIWEEK/moving-forward/';

  _executeAction(String action) async {
    if (await canLaunch(action)) {
      await launch(action);
    } else {
      throw 'Could not execute action';
    }
  }

  _save() {
    return null;
  }

  Column _actionIcon(IconData icon, String text, String action) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
              color: MfColors.dark,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: IconButton(
            color: MfColors.white,
            icon: Icon(icon),
            tooltip: text,
            onPressed: () {
              if (action != 'save') {
                _executeAction(action);
              } else {
                _save();
              }
            },
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Container _actionSection() {
    return Container(
        color: MfColors.primary[100],
        padding: EdgeInsets.all(32.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _actionIcon(Icons.call, 'Llamar', phone),
              _actionIcon(Icons.mail_outline, 'Escribir e-mail', email),
              _actionIcon(Icons.public, 'Visitar web', url),
              _actionIcon(Icons.bookmark_border, 'Guardar', 'save'),
            ]));
  }

  _launchMap({String lat = "47.6", String long = "-122.3"}) async {
    var mapSchema = 'geo:$lat,$long';
    if (await canLaunch(mapSchema)) {
      await launch(mapSchema);
    } else {
      throw 'Could not launch $mapSchema';
    }
  }

  SizedBox _mapSection() {
    return SizedBox(
        height: 210,
        child: Stack(
          children: <Widget>[
            Container(
                child: FlutterMap(
              options: MapOptions(
                center: LatLng(51.5, -0.09),
                zoom: 13.0,
              ),
              children: <Widget>[
                TileLayerWidget(
                    options: TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'])),
                MarkerLayerWidget(
                    options: MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 16.0,
                      height: 22.0,
                      point: LatLng(51.5, -0.09),
                      builder: (ctx) => Container(
                        child: Image(
                          image: AssetImage('assets/marker.png'),
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            )),
            Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.symmetric(horizontal: 60.0),
                child: FlatButton(
                    color: MfColors.dark,
                    textColor: MfColors.white,
                    padding: EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: () {
                      _launchMap(lat: '51.5', long: '-0.09');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.directions_walk,
                          color: MfColors.white,
                          size: 18.0,
                        ),
                        Text(
                          "Ruta a pie",
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " (menos de 500m)",
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    )))
          ],
        ));
  }

  Container _titleSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'APDHA (Asociación Pro Derechos Humanos de Andalucía)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MfColors.dark,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          Text(
            'Información, defensa de derechos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MfColors.dark,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 3.0),
                  child: Chip(
                    backgroundColor: Color(0xFFE1EFFF),
                    label: Text(
                      'Jurídico',
                      style: TextStyle(color: MfColors.dark),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 3.0),
                  child: Chip(
                    backgroundColor: Color(0xFFFEF3DE),
                    label: Text(
                      'LGTBI+',
                      style: TextStyle(color: MfColors.dark),
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.
    return Scaffold(
        body: Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          _mapSection(),
          _titleSection(),
          _actionSection(),
          _dataSection()
        ],
      ),
    ));
  }
}
