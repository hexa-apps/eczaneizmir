import 'package:eczaneizmir/core/services/get_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
// import 'package:geodesy/geodesy.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Marker> markers4map = [];
  String fabText = 'Nobetci Eczaneleri Goster';
  bool nobetci = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: false,
        backgroundColor: Colors.white,
        body: Center(
          child: FutureBuilder(
              future: getPharmacies(nobetci),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                        child: Text(
                      'Yukleniyor...',
                      style: TextStyle(color: Colors.black87),
                    ));
                  default:
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString(),
                          style: TextStyle(color: Colors.black87));
                    } else {
                      return Stack(
                          // fit: StackFit.expand,
                          children: [
                            createMap(snapshot.data),
                            Positioned(
                                top: 25,
                                right: 25,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      minimumSize: Size(60, 60),
                                      backgroundColor: Colors.white,
                                      shape: CircleBorder(),
                                      elevation: 5.0),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.grey[900],
                                    size: 27,
                                  ),
                                  onPressed: () {},
                                )),
                            Positioned(
                              bottom: 15,
                              left: MediaQuery.of(context).size.width * 0.125,
                              child: TextButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                  ),
                                  minimumSize: MaterialStateProperty.all(Size(
                                      MediaQuery.of(context).size.width * 0.75,
                                      40)),
                                  shadowColor:
                                      MaterialStateProperty.all(Colors.grey),
                                  elevation: MaterialStateProperty.all(5.0),
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  backgroundColor: !nobetci
                                      ? MaterialStateProperty.all(
                                          Colors.red[600])
                                      : MaterialStateProperty.all(Colors.white),
                                  foregroundColor: !nobetci
                                      ? MaterialStateProperty.all(Colors.white)
                                      : MaterialStateProperty.all(
                                          Colors.red[600]),
                                ),
                                onPressed: fabClicked,
                                child: Text(
                                  fabText,
                                ),
                              ),
                            ),
                          ]);
                    }
                }
              }),
        ),
      ),
    );
  }

  void fabClicked() {
    if (!nobetci) {
      fabText = 'Tum Eczaneleri Goster';
    } else {
      fabText = 'Nobetci Eczaneleri Goster';
    }
    nobetci = !nobetci;
    setState(() {});
  }

  FlutterMap createMap(data) {
    markers4map.clear();
    data.forEach((pharmacy) {
      isNumeric(pharmacy.locx) && isNumeric(pharmacy.locy)
          ? markers4map.add(Marker(
              anchorPos: AnchorPos.align(AnchorAlign.top),
              width: 50,
              height: 50,
              point: LatLng(
                  double.parse(pharmacy.locx), double.parse(pharmacy.locy)),
              builder: (ctx) => Image.asset(nobetci
                  ? 'assets/png/nobetci-pin.png'
                  : 'assets/png/eczane-pin.png')))
          : print('s');
    });
    return FlutterMap(
      options: MapOptions(
        nePanBoundary: LatLng(39.641, 28.796),
        swPanBoundary: LatLng(37.632, 25.956),
        plugins: [
          MarkerClusterPlugin(),
        ],
        interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        maxZoom: 18,
        minZoom: 6,
        center:
            markers4map.isNotEmpty ? markers4map.first.point : LatLng(41, 28),
        zoom: 10.0,
      ),
      layers: [
        TileLayerOptions(
            maxZoom: 18,
            urlTemplate:
                "https://api.mapbox.com/styles/v1/mapbox/light-v10/tiles/{z}/{x}/{y}"
                "?access_token={accessToken}",
            additionalOptions: {
              'accessToken':
                  'ACCESSTOKEN',
            },
            // urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            // subdomains: ['a', 'b', 'c'],
            tileProvider: NonCachingNetworkTileProvider()),
        MarkerClusterLayerOptions(
          maxClusterRadius: 80,
          size: Size(50, 50),
          anchor: AnchorPos.align(AnchorAlign.center),
          fitBoundsOptions: FitBoundsOptions(
            padding: EdgeInsets.all(50),
          ),
          polygonOptions: PolygonOptions(
              borderColor: Colors.transparent,
              color: Colors.transparent,
              borderStrokeWidth: 3),
          markers: markers4map,
          disableClusteringAtZoom: 16,
          builder: (context, markers) {
            return FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.red[600],
              onPressed: null,
              child: Text(
                markers.length.toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ],
    );
  }
}
