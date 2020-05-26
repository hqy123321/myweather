
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:city_pickers/city_pickers.dart';

import 'tianqi_http.dart';
import 'tianqi_model.dart';



class DreamPage extends StatefulWidget {
  @override
  _DreamPageState createState() => _DreamPageState();
}

class _DreamPageState extends State<DreamPage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive {
    return true ;
  }

  Color containercolor = Colors.black38;
  String name ;
  Color textcolor = Colors.white;
  TianqiModel tianqiModel;
  List<Data> data = [];

  String get cityName => null;
 Future<Null> _getHttp() async {
    try{
      tianqiModel = await TianqiHttp.getTianqiHttp(cityName);
      print(tianqiModel);
      setState(() {
        data = tianqiModel.data;
      });
    }catch (e) {
      print('抛出错误$e');
    }
    return null;
  }
  @override
  void initState() {
    super.initState();
    _getHttp();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:RefreshIndicator(
        onRefresh: _getHttp,
        child:Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xff375f84), Color(0xff6994bd)],
            )
          ),
          child: (tianqiModel == null) ? _loding(context) :  ListView(
            children: <Widget>[
              _appbar(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child:  _topwidget(),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: _centerwidget(),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: _bottmowidget(),
              ),
              _indexwidget()
            ],
          ),
        )
      )
    );
  }

  Widget _appbar() {            //头部
    return AppBar(
      title: GestureDetector(
        child: Text('${tianqiModel.city}'),
        onTap: () {
          this._show(context);
        },
      ),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 10.0),
          alignment: Alignment.center,
          child: IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              this.openSetting(context);
            },
          )
        )
      ],
    );
  }

  Widget _topwidget() {
    return Container(
      color: containercolor,
      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text('${tianqiModel.data.first.wea}',style: TextStyle(color: textcolor, fontSize: 20.0),),
          new Text('${tianqiModel.data.first.tem}',style: TextStyle(color: textcolor, fontSize: 20.0),)
        ],
      ),
    );
  }

  Widget _centerwidget() {
    return Container (
      color: containercolor,
      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text('空气质量',style: TextStyle(color: textcolor, fontSize: 30.0),),
          new Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Text('${tianqiModel.data.first.air.toInt()}',style: TextStyle(color: textcolor, fontSize: 25.0,)),
                new Text('${tianqiModel.data.first.airLevel}',style: TextStyle(color: textcolor, fontSize: 25.0,))
              ],
            ),
          ),
          new Text('${tianqiModel.data.first.airTips}',style: TextStyle(color: textcolor, fontSize: 18.0,))
        ],
      ),
    );
  }

  Widget _bottmowidget() {
    return Container(
      color: containercolor,
      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
      child: Column(
        children: <Widget>[
         new Padding(
           padding: EdgeInsets.only(bottom: 10.0),
           child: new Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
             new Text('预报', style: TextStyle(color: textcolor),),
             new Text('${DateTime.now().hour}:${DateTime.now().minute}发布',style: TextStyle(color: textcolor),)
           ],
         ),
        ),
         Padding(
           padding: EdgeInsets.only(bottom: 10.0),
           child: new Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: _topItem(),
         ),
        ),
         new Column(
           children: _bottomItem(),
         )
        ],
      ),
    );
  }
  
  

  List<Widget> _topItem() {
    List<Widget> widgets = new List();
      for(int i = 0; i < tianqiModel.data.first.hours.length; i++) {
        widgets.add(topitemView(tianqiModel.data.first.hours[i]));
      }
    return widgets ;
  }

  Widget topitemView(Hours hours) {
    return Container(
      child: Column(
        children: <Widget>[
          new Text('${DateTime.now().hour}:00',style: TextStyle(color: textcolor),),
          new Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: new Text('${hours.wea}',style: TextStyle(color: textcolor),),
          ),
          new Text('${hours.tem}',style: TextStyle(color: textcolor),)
        ],
      ),
    );
  }

  List<Widget> _bottomItem() {
    List<Widget> widgets = new List();
    for (int i = 0; i < data.length; i++) {
      widgets.add(bottomitemView(data[i]));
    }
    return widgets ;
  }
  Widget bottomitemView(Data data) {
    return Container(
      padding: EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text('${data.day}',style: TextStyle(color: textcolor, fontSize: 20.0),),
          new Text('${data.wea}',style: TextStyle(color: textcolor, fontSize: 20.0)),
          new Text('${data.tem1}/${data.tem2}',style: TextStyle(color: textcolor, fontSize: 20.0))
        ],
      ),
    );
  }

  Widget _indexwidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text('生活指数',style: TextStyle(color: textcolor,fontSize: 20.0),),
        ),
        new GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          childAspectRatio: 1.6,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          children: tianqiModel.data.first.index.map((item){
            if(item.title == null || item.level == null) {
              return Container(
                color: containercolor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text('疫情期间',style: TextStyle(color: textcolor),),
                    new Text('不出门',style: TextStyle(color: textcolor),)
                  ],
                ),
              );
            } else {
              return Container(
                color: containercolor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text('${item.title}',style: TextStyle(color: textcolor),),
                    new Text('${item.level}',style: TextStyle(color: textcolor),)
                  ],
                ),
              );
            }
          }).toList(),
        )
      ],
    );
  }
 
  void openSetting(BuildContext context) {
     showModalBottomSheet(
      context: context,
       builder: (BuildContext context) {
         return Column(
           mainAxisSize: MainAxisSize.min,
           children: <Widget>[
             ListTile(
               title: Text('管理城市'),
               onTap: () {
               },
             ),
             Divider(height: 0.6,),
             ListTile(
               title: Text('关于我们'),
               onTap: () {

               },
             ),
           ],
         );
       }
    );
  } 

  _show(BuildContext context) async{    
    Result result = await CityPickers.showCityPicker(
      context: context ,
     // height: double.infinity/3
    );
     name = result.cityName;
     int shiIndex=-1;
    if(name.contains("市")){
      shiIndex = name.indexOf("市");

    }else if(name.contains("城")){
      shiIndex = name.indexOf("城区");
    }
    if(shiIndex!=-1){
      name  = name.substring(0,shiIndex);
    }
    print(result.toString());
     TianqiHttp.getTianqiHttp(name).then((value){
       setState(() {
         tianqiModel = value;
       });
     });
  }

  _loding(BuildContext context) {
    return Center(
      child: Text('jaiozhasdf'),
    );
  }
}