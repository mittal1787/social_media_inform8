import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socialmediainform8/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestoreInstance = Firestore.instance;

class InputScreen extends StatelessWidget {
  String platform;
  String node;
  String input;
  Color color;
  String fontFamily;
  String accessToken;
  final myController = TextEditingController();

  InputScreen(this.platform, this.node, this.input, this.color, this.fontFamily, {this.accessToken});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.platform + " " + this.node),
        backgroundColor: color,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              node,
              style: TextStyle(
                color: color,
                fontFamily: fontFamily,
              ),
            ),
            Text(
              "Please put $input",
            ),
            TextField(
              decoration: InputDecoration(
                hintText: input,
                border: InputBorder.none,
              ),
              controller: myController,
            ),
            RaisedButton(
              child: Text("Go"),
              onPressed: () async {
                String id = myController.text;
                var url = "https://social-media-inform8.herokuapp.com/$platform$node";
                http.Response response = await http.post(url, body: {input.replaceAll(" ", ""): id});
                var firebaseUser = await FirebaseAuth.instance.currentUser();
                firestoreInstance.collection("users").document(firebaseUser.uid).setData(
                    {
                      "node" : this.node,
                      "email" : firebaseUser.email,
                      "platform": platform,
                      "data" : response.body,
                    }).then((_){
                  print("success!");
                });
                MaterialPageRoute(builder: (context) => ResultsScreen(json.decode(response.body), platform, node));
              },
            )
          ],
        ),
      ),
    );
  }
}

class YouTubeChannel extends StatefulWidget {
  @override
  _YouTubeChannelState createState() => _YouTubeChannelState();
}

class _YouTubeChannelState extends State<YouTubeChannel> {
  String identifier = "channel-id";
  List<String> identifierNames = ["channel-id", "username"];
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YouTube Channel"),
        backgroundColor: platformColors["YouTube"],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "YouTube Channel",
              style: TextStyle(
                color: platformColors["YouTube"],
                fontFamily: platformFonts["YouTube"],
              ),
            ),
            Text(
              "Please put YouTube ID or Channel",
            ),
            Row(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  controller: myController,
                ),
                DropdownButton<String>(
                  value: identifier,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      identifier = newValue;
                    });
                  },
                  items: identifierNames.map<DropdownMenuItem<String>>((
                      String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            ),
            RaisedButton(
              child: Text("Go"),
              onPressed: () async {
                String id = myController.text;
                var url = "https://social-media-inform8.herokuapp.com/YouTubeChannel";
                http.Response response = await http.post(url, body: {
                  "channelId": myController.text,
                  "identifier": identifier,
                });
                var firebaseUser = await FirebaseAuth.instance.currentUser();
                firestoreInstance.collection("users")
                    .document(firebaseUser.uid)
                    .setData(
                    {
                      "node": "channel",
                      "email": firebaseUser.email,
                      "platform": "YouTube",
                      "data": response.body,
                    })
                    .then((_) {
                  print("success!");
                });
                MaterialPageRoute(builder: (context) => ResultsScreen(
                    json.decode(response.body), "YouTube", "Channel"));
              },
            )
          ],
        ),
      ),
    );
  }
}

class ResultsScreen extends StatefulWidget {
  Map data;
  String platform;
  String node;
  List<Widget> views = [];
  static int screenNum = 0;
  static Map<String, int> platformScreenNums = {"Facebook":0, "Twitter":0, "YouTube": 0, "Twitch": 0, "Instagram":0, "Tumblr":0, "Misc": 0};
  ResultsScreen(this.data, this.platform, this.node){
    screenNum++;
    platformScreenNums[platform] += 1;
  }

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {

  @override
  void initState(){
    super.initState();
    if (widget.data.containsKey("ChartsSite"))
    {
      widget.views.add(WebView(
        initialUrl: widget.data["ChartsSite"],
        javascriptMode: JavascriptMode.unrestricted,
      ));
    }
    if (widget.data.containsKey("Social Blade site")) {
      if (widget.data["Social Blade site"] != null)
      {
        widget.views.add(ExpansionTile(
          title: Text("Social Blade"),
          children: <Widget>[
            WebView(
              initialUrl: widget.data["Social Blade site"],
            ),
          ],
        ));
      }
    }
    if (widget.data.keys.contains("Coordinates"))
    {
      if (widget.data["Coordinates"].runtimeType == "Map")
      {
        addCoordinatesDict(widget.data["Coordinates"]);
      }
      else {
        addCoordinatesList(widget.data["Coordinates"]);
      }
    }
    readMap(widget.data);

  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.views,
    );
  }

  void readMap(Map map)
  {
    map.forEach((key, value) {
      if (value is Map)
      {
        if (key.toString().toLowerCase() != "coordinates")
        {
          readMap(value);
        }

      }
      else
      {
        if (key.toString() != "charts" && key.toString() != "ChartsSite" && key.toString().toLowerCase() != "social blade site")
        {
          widget.views.add(Text(key + ": " + value));
        }
      }
    });
  }

  void addCoordinatesDict(Map map)
  {
    map.forEach((key, value) {
      widget.views.add(
          ExpansionTile(
            title: Text(key.toString()),
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(17.4435, 78.3772),
                  zoom: 14.0,
                ),
              ),
            ],
          )
      );
    });
  }

  void addCoordinatesList(List coordinates){
    Map<String, Marker> markers = {};
    for (int i = 0; i < coordinates.length; i++){
      markers[i.toString()] = Marker(
        markerId: MarkerId(i.toString()),
        position: LatLng(coordinates[i][0], coordinates[i][1]),
      );
    }

    widget.views.add(
        ExpansionTile(
          title: Text("Post Locations"),
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(17.4435, 78.3772),
                zoom: 14.0,
              ),
              markers: Set.of(markers.values),
            ),
          ],
        )
    );
  }

}

