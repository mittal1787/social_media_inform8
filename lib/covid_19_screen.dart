import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class COVID19Screen extends StatefulWidget {
  @override
  _COVID19ScreenState createState() => _COVID19ScreenState();
}

class _COVID19ScreenState extends State<COVID19Screen> {
  static Completer _controller = Completer();
  List<Widget> views = [];
  Map responseJson;

  void initState()
  {
    super.initState();
    views.addAll([
      Text("COVID-19 Data"),
      ExpansionTile(
        title: Text("Johns Hopkins University COVID-19 Map"),
        children: <Widget>[WebView(
            initialUrl: "https://coronavirus.jhu.edu/map.html",
            javascriptMode: JavascriptMode.unrestricted,
            gestureRecognizers: Set()
              ..add(Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer()))
        )],
      ),
      ExpansionTile(
        title: Text("Worldometer COVID-19 Statistics"),
        children: <Widget>[WebView(
            initialUrl: "https://www.worldometers.info/coronavirus/",
            javascriptMode: JavascriptMode.unrestricted,
            gestureRecognizers: Set()
              ..add(Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer()))
        )],
      ),
    ]);
    readJson();
    Map socialBladeSites = responseJson["Social Blade sites"];
    socialBladeSites.forEach((key, value) {
      placeSocialBlade(value);
    });
    Map coordinates = responseJson["Coordinates"];
    placeGoogleMaps(coordinates);
    readMap(responseJson);
  }

   Future<void> readJson() async {
    var response = await http.get("https://social-media-inform8.herokuapp.com/COVID19");
    responseJson = jsonDecode(response.body);
  }

  void placeGoogleMaps(Map coordinates)
  {
    coordinates.forEach((key, value) {
      Map<String, Marker> markers = {};
      views.add(
        ExpansionTile(
          title: Text(key),
          children: <Widget>[
            GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(17.4435, 78.3772),
                  zoom: 14.0,
                ),
                markers: Set.of(markers.values),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  getMarkers(markers, value);
                }
            ),
          ],
        ),
      );
    });
  }

  void getMarkers(Map markers, Map coordsData)
  {
    coordsData.forEach((key, value) {
      markers[key] = Marker(
        markerId: MarkerId(key),
        position: LatLng(value[0], value[1]),
      );
    });
  }

  void placeSocialBlade(Map sbSites)
  {
    sbSites.forEach((key, value) {
      views.add(
          ExpansionTile(
            title: Text(key),
            children: <Widget>[
              WebView(
                  initialUrl: value,
                  javascriptMode: JavascriptMode.unrestricted,
                  gestureRecognizers: Set()
                    ..add(Factory<VerticalDragGestureRecognizer>(
                            () => VerticalDragGestureRecognizer()))
              )
            ],
          )
      );
    });
  }



   void readMap(Map map) {
    map.forEach((key, value) {
      if (value is Map) {
        if (key.toString().toLowerCase() != "social blade sites" || key.toString().toLowerCase() != "coordinates") {
          readMap(value);
        }
      }
      else {
        if (key.toString().toLowerCase() != "charts" && key != "Social Blade sites") {
          views.add(Text(key + ": " + value));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("COVID-19 Data"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://i2.wp.com/neurosciencenews.com/files/2020/06/27-biomarkers-covid19-nuroscienrw-public.jpg?fit=1400%2C933&ssl=1"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [Center(child: Text("COVID-19 Data")),
              Center(
                child: ExpansionTile(
                  title: Text("Johns Hopkins University COVID-19 Map"),
                  children: <Widget>[Container(
                    height: 200,
                    width: 200,
                    child: WebView(
                        initialUrl: "https://coronavirus.jhu.edu/map.html",
                        javascriptMode: JavascriptMode.unrestricted,
                        gestureRecognizers: Set()
                          ..add(Factory<VerticalDragGestureRecognizer>(
                                  () => VerticalDragGestureRecognizer()))
                    ),
                  )],
                ),
              ),
              Center(
                child: ExpansionTile(
                  title: Text("Worldometer COVID-19 Statistics"),
                  children: <Widget>[Container(
                    height: 200,
                    width: 200,
                    child: WebView(
                        initialUrl: "https://www.worldometers.info/coronavirus/",
                        javascriptMode: JavascriptMode.unrestricted,
                        gestureRecognizers: Set()
                          ..add(Factory<VerticalDragGestureRecognizer>(
                                  () => VerticalDragGestureRecognizer()))
                    ),
                  )],
                ),
              ),
              Center(
                child: ExpansionTile(
                  title: Text("Social Media Analysis Charts"),
                  children: <Widget>[Container(
                    height: 200,
                    width: 200,
                    child: WebView(
                        initialUrl: responseJson["ChartsSite"],
                        javascriptMode: JavascriptMode.unrestricted,
                        gestureRecognizers: Set()
                          ..add(Factory<VerticalDragGestureRecognizer>(
                                  () => VerticalDragGestureRecognizer()))
                    ),
                  )],
                ),
              ),
            Center(
              child: Column(
                children: views,
              ),
            )],
          ),
        ),
      ),
    );
  }
}
