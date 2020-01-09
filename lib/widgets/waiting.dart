import 'package:flutter/material.dart';

class WaitingWidget extends StatelessWidget {
  WaitingWidget({Key key, this.bgPage}) : super(key: key);
  final Widget bgPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Stack(
        children: <Widget>[
          bgPage,
          new Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.white70,
            ),
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: new CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        "Loading...",
                        style: new TextStyle(
                          color: Colors.black
                        ),
                      ),
                    ),
                  ),
                ]
              )
          )
        ]
      )
    );
  }
}