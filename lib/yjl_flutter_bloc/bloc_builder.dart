import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_viewdemo/yjl_flutter_bloc/base_bloc.dart';

import 'bloc_provider.dart';

class YjlBlocBuilder<T extends YjlBaseBloc<V>, V> extends StatefulWidget {
  const YjlBlocBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Function(BuildContext context, V state) builder;

  @override
  _YjlBlocBuilderState createState() => _YjlBlocBuilderState<T, V>();
}

class _YjlBlocBuilderState<T extends YjlBaseBloc<V>, V>
    extends State<YjlBlocBuilder<T, V>> {
  late T _bloc;
  late V _state;
  StreamSubscription<V>? _listen;

  @override
  void initState() {
    _bloc = YjlBlocProvider.of<T>(context);
    _state = _bloc.state;

    //数据改变刷新Widget
    _listen = _bloc.stream.listen((event) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _state);
  }

  @override
  void dispose() {
    _listen?.cancel();
    super.dispose();
  }
}