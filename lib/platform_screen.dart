import 'package:flutter/cupertino.dart';
import 'dart:io';

class PlatformScreen {
  String name;
  List<String> platformObjects;
  Color color;
  String androidFontFamily;
  String iOSFontFamily;
  String macFontFamily;
  String windowsFontFamily;

  PlatformScreen(this.name, this.platformObjects, this.color, {this.androidFontFamily, this.iOSFontFamily, this.macFontFamily, this.windowsFontFamily});

  String fontFamily()
  {
    if (Platform.isAndroid)
    {
      return androidFontFamily;
    }
    else if (Platform.isIOS)
    {
      return iOSFontFamily;
    }
    else if (Platform.isMacOS)
    {
     return macFontFamily;
    }
    else {
      return windowsFontFamily;
    }
  }

}