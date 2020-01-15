import 'package:flutter/material.dart';

class SelectableImage extends StatelessWidget {
  SelectableImage(
    this.assetPath,
    {
      this.height,
      this.width,
      this.selected,
      this.onTap,
    }
  );

  final String assetPath;
  final double height;
  final double width;
  final bool selected;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Stack(
        children: <Widget>[
          Image.asset(
            assetPath,
            height: this.height,
            width: this.width,
          ),
          new Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: this.onTap,
              child: Opacity(
                opacity: this.selected ? 0.5 : 0,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Center(
                      child: new SizedBox(
                        height: this.height,
                        width: this.height,
                        child: const DecoratedBox(
                          decoration: const BoxDecoration(
                            color: Colors.blue
                          ),
                        ),
                      ),
                    )
                  ]
                )
              )
            )
          )
        ]
      )
    );
  }
}