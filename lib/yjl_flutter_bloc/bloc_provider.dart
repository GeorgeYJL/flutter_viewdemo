import 'package:flutter/widgets.dart';

import 'base_bloc.dart';

class YjlBlocProvider<T extends YjlBaseBloc> extends InheritedWidget {
  YjlBlocProvider({
    Key? key,
    Widget? child,
    required this.create,
  }) : super(key: key, child: child ?? Container());

  final T Function(BuildContext context) create;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  @override
  InheritedElement createElement() => YjlBlocInheritedElement(this);

// of 方法 用于子组件 获取bloc  bloc 框架为了该功能 引入了Provider
  static T of<T extends YjlBaseBloc>(BuildContext context) {
    var inheritedElement =
    context.getElementForInheritedWidgetOfExactType<YjlBlocProvider<T>>()
    as YjlBlocInheritedElement<T>?;

    if (inheritedElement == null) {
      throw 'not found';
    }

    return inheritedElement.value;
  }
}

//自定义 InheritedElement 用于存储 bloc 通过vlue属性获取
class YjlBlocInheritedElement<T extends YjlBaseBloc> extends InheritedElement {
  YjlBlocInheritedElement(YjlBlocProvider<T> widget) : super(widget);

  bool _firstBuild = true;

  late T _value;

  T get value => _value;

  @override
  void performRebuild() {
    if (_firstBuild) {
      _firstBuild = false;
      _value = (widget as YjlBlocProvider<T>).create(this);
    }

    super.performRebuild();
  }

  @override
  void unmount() {
    _value.close();
    super.unmount();
  }
}