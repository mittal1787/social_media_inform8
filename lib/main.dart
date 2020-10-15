import 'dart:collection';
import 'dart:io';
import 'dart:ui';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialmediainform8/Services/authentication_service.dart';
import 'package:socialmediainform8/covid_19_screen.dart';
import 'package:socialmediainform8/input_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialmediainform8/stored_screen.dart';
import 'package:socialmediainform8/twitter_trending.dart';
import 'constants.dart';
import 'package:google_fonts/google_fonts.dart';

Color fbColor = const Color.fromARGB(255, 66, 165, 245);
AuthenticationService auth = AuthenticationService();
final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser loggedInUser;
//final firestoreInstance = Firestore.instance;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social media Informate',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignIn(),
    );
  }
}

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final controllerOne = TextEditingController();
  final controllerTwo = TextEditingController();

  void initState() {
      super.initState();
      try {
        getCurrentUser();
        if (loggedInUser != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SocialMediaScreen()));
        }
      } catch (e) {
        print(e);
      }
  }

  void getCurrentUser() async{
    loggedInUser = await _auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Social Media Informate"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome to your Social Media Informate",
            ),
            Text(
              "Sign in",
            ),
            TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Email'
              ),
              controller: controllerOne,
            ),
            TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Password'
              ),
              controller: controllerTwo,
              obscureText: true,
            ),
            RaisedButton(
              child: Text("Sign in"),
                onPressed: () async {
                  try {
                    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
                        email: controllerOne.text,
                        password: controllerTwo.text)).user;
                    if (user != null)
                    {
                      loggedInUser = user;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SocialMediaScreen()));
                    }
                    else {
                      print("Sorry, user was not found");
                    }
                  } catch (e) {
                    print(e.message);
                  }
                },
            ),
            RaisedButton(
              child: Text("Sign up"),
              onPressed: ()
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final controllerOne = TextEditingController();
  final controllerTwo = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Social Media Informate"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Sign Up"),
            TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Email'
              ),
              controller: controllerOne,
            ),
            TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Password'
              ),
              obscureText: true,
              controller: controllerTwo,
            ),
            RaisedButton(
                child: Text("Sign up"),
                onPressed: () async {
                  try {
                    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
                      email: controllerOne.text,
                      password: controllerTwo.text,
                    )).user;
                    if (user != null)
                    {
                      loggedInUser = user;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SocialMediaScreen()));
                    }
                    else {
                      print("Sorry, user was not found");
                    }
                  } catch (e) {
                    print(e.message);
                  }
                },
            ),
          ],
        ),
      ),
    );
  }
}

class SocialMediaScreen extends StatefulWidget {
  @override
  _SocialMediaScreenState createState() => _SocialMediaScreenState();
}

class _SocialMediaScreenState extends State<SocialMediaScreen> {
  String dropdownValue = "Facebook";
  List<String> items = ['Facebook', 'Twitter', 'YouTube', 'Instagram', 'Twitch', 'Tumblr', 'Pinterest', 'Misc'];
  Map platformObjectList = {"Facebook": ["Page", "Post", "Place", "Video", "Photo", "Album", "Group", "User", "Event", "Search"],
                            "Twitter": ["Tweet", "User", "Place", "Hashtag", "Search", "Trending"],
                            "YouTube":['Search', 'Channel', "Vid", "Playlist"],
                            "Instagram": ["User", "Post", "Hashtag"],
                            "Twitch": ["User", "Video", "Stream", "Game"],
                            "Tumblr": ["Blog"],
                            "Pinterest": ["Board", "Pin", "User", "Search"],
                            "Misc": ["Search", "Trending", "News", "COVID-19", "Saved"]};


  Color appBarColor = Color(0xFF1877f2);
  Text screenTitle = Text("Select your social media platform");
  static TextStyle appBarStyle = getFontFamily(androidFontFamily: GoogleFonts.roboto(), iOSFontFamily: GoogleFonts.sacramento());
  Text appBarTitle = Text("Social Media Informate", style: appBarStyle);
  static List<String> nodes = ["Page", "Post", "Place", "Video", "Photo", "Album", "Group", "User", "Event", "Search"];
  String secondDropdown = nodes[0];
  static TextStyle getFontFamily({TextStyle androidFontFamily, TextStyle iOSFontFamily}) {
    return Platform.isAndroid ? androidFontFamily : iOSFontFamily;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appBarColor,
          title: appBarTitle,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            screenTitle,
            DropdownButton<String>(
              value: dropdownValue,
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
                  dropdownValue = newValue;
                  nodes = platformObjectList[dropdownValue];
                  appBarColor = platformColors[dropdownValue];
                  secondDropdown = nodes[0];
                });
              },
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: secondDropdown,
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
                  secondDropdown = newValue;
                });
              },
              items: nodes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            RaisedButton(
              child: Text("Go"),
              onPressed: ()
              async {
                if (dropdownValue == "Misc"){
                  if (secondDropdown == "COVID-19")
                  {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>COVID19Screen()));
                  }
                  else if (secondDropdown == "Saved")
                  {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>SavedData()));
                  }
                }
                else {
                  if (dropdownValue == "Twitter" && secondDropdown == "Trending")
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>TwitterTrending()));
                  }
                  else{
                    String inputName = "";
                    if (secondDropdown == "search")
                    {
                      inputName = "q";
                    }
                    else if (secondDropdown == "hashtag"){
                      inputName = "hashtag";
                    }
                    else {
                      inputName = secondDropdown + " Id";
                    }
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>InputScreen(dropdownValue, secondDropdown, inputName, platformColors[dropdownValue], platformFonts[dropdownValue])));
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}



