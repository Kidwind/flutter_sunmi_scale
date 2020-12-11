import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sunmi_scale/flutter_sunmi_scale.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("商米电子称"),
        ),
        body: ScaleInfo(),
      ),
    );
  }
}

class ScaleInfo extends StatefulWidget {
  @override
  _ScaleInfoState createState() => _ScaleInfoState();
}

class _ScaleInfoState extends State<ScaleInfo> {
  static const BACKGEOUND_COLOR = Colors.black;
  static const TEXT_COLOR1 = Colors.white;
  static const TEXT_COLOR2 = Color(0xFF858A95);
  static const DIVIDER_COLOR = Color(0xFF444C5E);

  static const EventChannel eventChannel =
      EventChannel(FlutterSunmiScale.EVENT_CHANNEL_NAME);

  SunmiScaleData _scaleData = SunmiScaleData(false, 0, 0, false, false, false, false, false);

  @override
  void initState() {
    super.initState();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  void _onEvent(dynamic data) {
    data = new Map<String, dynamic>.from(data);
    setState(() {
      _scaleData = SunmiScaleData.fromJson(data);
    });
  }

  void _onError(Object error) {
    setState(() {
      PlatformException exception = error;
      _scaleData = null;
    });
  }

  get isUnderload {
    return _scaleData.net + _scaleData.tare < 0;
  }

  /**
   * 激活稳定。
   */
  get activedStable {
    return _scaleData.isStable &&
        !_scaleData.overload &&
        !isUnderload;
  }

  /**
   * 激活净重。
   */
  get activedNetWeight {
    return _scaleData.tare > 0 &&
        _scaleData.isStable &&
        !_scaleData.overload &&
        !isUnderload;
  }

  /**
   * 激活零位。
   */
  get activedZore {
    return _scaleData.net == 0 &&
        _scaleData.isStable &&
        !_scaleData.overload &&
        !isUnderload;
  }

  String formatQuality(int val) {
    return (val * 1.0 / 1000).toString();
  }

  void _onZeroClick() {
    FlutterSunmiScale.zero();
  }

  void _onTareClick() {
    FlutterSunmiScale.tare();
  }

  void _onSetNumTareClick() {

  }

  void _onClearTareClick() {
    FlutterSunmiScale.clearTare();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: row1(),
            padding: EdgeInsets.fromLTRB(14, 8.6, 14, 8.6),
          ),
          Divider(
            height: 2,
            thickness: 1,
            color: DIVIDER_COLOR,
          ),
          Container(
            child: row2(),
            padding: EdgeInsets.fromLTRB(14, 11.3, 14, 11.3),
          ),
          Divider(
            height: 2,
            thickness: 1,
            color: DIVIDER_COLOR,
          ),
          Container(
            child: row3(),
          ),
          Divider(
            height: 2,
            thickness: 1,
            color: DIVIDER_COLOR,
          ),
          Container(
            child: row4(),
            padding: EdgeInsets.fromLTRB(14, 18, 14, 18),
          )
        ],
      ),
      decoration: BoxDecoration(color: BACKGEOUND_COLOR),
    );
  }

  row1() {
    return Row(
      children: [
        Text(
          "最大秤量：6/15kg",
          style: TextStyle(color: TEXT_COLOR2, fontSize: 12),
        ),
        Text(
          "最小秤量：40g",
          style: TextStyle(color: TEXT_COLOR2, fontSize: 12),
        ),
        Text(
          "分度值 e=2/5g",
          style: TextStyle(color: TEXT_COLOR2, fontSize: 12),
        ),
        Text(
          "T=-5.998kg",
          style: TextStyle(color: TEXT_COLOR2, fontSize: 12),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
    );
  }

  row2() {
    return Row(
      children: [
        Container(
          child: Column(children: [
            ScaleInfoActivedItem(
              activedStable,
              "稳定",
              style: TextStyle(color: TEXT_COLOR1),
            ),
            Container(
              child: ScaleInfoActivedItem(
                activedNetWeight,
                "净重",
                style: TextStyle(color: TEXT_COLOR1),
              ),
              margin: EdgeInsets.fromLTRB(0, 6.5, 0, 0),
            ),
            Container(
              child: ScaleInfoActivedItem(
                activedZore,
                "零位",
                style: TextStyle(color: TEXT_COLOR1),
              ),
              margin: EdgeInsets.fromLTRB(0, 6.5, 0, 0),
            ),
          ]),
        ),
        Container(
          child: Column(
            children: [
              Text(
                _scaleData.tare == 0 ? "计重(kg)" : "净重(kg)",
                style: TextStyle(color: TEXT_COLOR2),
              ),
              Text(
                _scaleData.isCanUse ? formatQuality(_scaleData.net) : "---",
                style: TextStyle(color: _scaleData.isCanUse ? TEXT_COLOR1 : Colors.red, fontSize: 40),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.end,
          ),
        ),
        Container(
          child: Column(
            children: [
              Text(
                "皮重(kg)",
                style: TextStyle(color: TEXT_COLOR2),
              ),
              Text(
                _scaleData.isCanUse ? formatQuality(_scaleData.tare) : "---",
                style: TextStyle(color: _scaleData.isCanUse ? TEXT_COLOR1 : Colors.red, fontSize: 40),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.end,
          ),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  row3() {
    return Row(
      children: [
        FlatButton(
            onPressed: _onZeroClick,
            child: Text(
              "清零",
              style: TextStyle(color: TEXT_COLOR1),
            )),
        FlatButton(
            onPressed: _onTareClick,
            child: Text(
              "去皮",
              style: TextStyle(color: TEXT_COLOR1),
            )),
        FlatButton(
            onPressed: _onSetNumTareClick,
            child: Text(
              "数字去皮",
              style: TextStyle(color: TEXT_COLOR1),
            )),
        FlatButton(
            onPressed: _onClearTareClick,
            child: Text(
              "清皮",
              style: TextStyle(color: TEXT_COLOR1),
            ))
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  row4() {
    return Row(
      children: [
        Image.asset(
          "assets/images/default_scale.png",
          width: 54,
          height: 54,
          fit: BoxFit.cover,
        ),
        Container(
          child: Column(
            children: [
              Text(
                "单价(元/kg)",
                style: TextStyle(color: TEXT_COLOR2),
              ),
              Text(
                "---",
                style: TextStyle(color: TEXT_COLOR1, fontSize: 40),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.fromLTRB(6.66, 0, 0, 0),
        ),
        Expanded(
          child: Container(
            child: Column(
              children: [
                Text(
                  "总价(元)",
                  style: TextStyle(color: TEXT_COLOR2),
                ),
                Text(
                  "---",
                  style: TextStyle(color: TEXT_COLOR1, fontSize: 40),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
            margin: EdgeInsets.fromLTRB(6.66, 0, 0, 0),
          ),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

class ScaleInfoActivedItem extends StatelessWidget {
  bool actived;
  String text;
  TextStyle style;

  ScaleInfoActivedItem(this.actived, this.text, {this.style}) {}

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.adjust,
          color: actived ? Colors.green : Colors.yellow,
          size: 12,
        ),
        Container(
          child: Text(
            text,
            style: style,
          ),
          margin: EdgeInsets.fromLTRB(6, 0, 0, 0),
        )
      ],
    );
  }
}
