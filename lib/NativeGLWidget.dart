



import 'package:flutter/widgets.dart';

import 'flutter_viewdemo.dart';

class NativeGLWidget extends StatefulWidget {
  int width;
  int height;
  NativeGLWidget(this.width, this.height);
  @override
  NativeGLWidgetState createState() =>  NativeGLWidgetState();
}

class NativeGLWidgetState extends State<NativeGLWidget> {

  late int? _textureId;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width.toDouble(),
      height: widget.height.toDouble(),
      child: _textureId!=null?
      Texture(textureId: _textureId!):Container(),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlugin();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(_textureId!=null){
      FlutterViewdemo.disposeTexture(_textureId!);
    }
  }

  @override
  void didUpdateWidget(NativeGLWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void initPlugin() async{
    _textureId = (await FlutterViewdemo.getTextureIdFromNative(widget.width, widget.height))!;
    setState(() {});
  }
}