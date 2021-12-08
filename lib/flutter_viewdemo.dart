import 'dart:async';

import 'package:flutter/services.dart';

class FlutterViewdemo {
  static const MethodChannel _channel = const MethodChannel('flutter_viewdemo');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// 获取 纹理ID
  static Future<int?> getTextureIdFromNative(int width, int height) async {
    var textureID = await _channel.invokeMethod("createTexture",{"width":width,"height":height});
    return textureID;
  }

  static Future<Null> disposeTexture(int textureID) async{
    return _channel.invokeMethod("dispose",{"textureID":textureID});
  }
}
