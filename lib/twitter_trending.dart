import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:socialmediainform8/input_screen.dart';


class TwitterTrending extends StatefulWidget {
  @override
  _TwitterTrendingState createState() => _TwitterTrendingState();
}

class _TwitterTrendingState extends State<TwitterTrending> {

  getData() async{
    String url = "https://social-media-inform8.herokuapp.com/TwitterTrending";
    http.Response response = await http.post(url);
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return ResultsScreen(getData(), "Twitter", "Trending");
  }
}
