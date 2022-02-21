
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_viewdemo/yjl_flutter_bloc/yjl_flutter_bloc.dart';
class demoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return YjlBlocProvider(
      create:(BuildContext context)=>countBloc(),
      child:Builder(builder: (context)=>_builderPage(context),) ,
    );
  }

  Widget _builderPage(BuildContext context) {
    final bloc = YjlBlocProvider.of<countBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text(''),),
      body: Center(
        child: YjlBlocBuilder<countBloc,countState>(
          builder: (context,state){
            return Text('点击了 ${bloc.state.count}');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>bloc.increment(),
        child: Icon(Icons.add),
      ),
    );

  }
}

class countBloc extends YjlBaseBloc<countState>{
  countBloc() : super(countState().init());

  void increment()=> emit(state.clone()..count = ++state.count);
}
class countState {

  late int count;
  countState init(){
    return countState()..count = 0;
  }

  countState clone(){
    return countState()..count = count;
  }


}