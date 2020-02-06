import 'package:flutter/material.dart';
import 'package:myzap/constants/durations.dart';
import 'package:myzap/widgets/selectable_image.dart';


class DurationChoice extends StatelessWidget {
  final bool selectable;
  final Duration selected;
  final Function onSelected;

  DurationChoice({Key key, this.selectable, this.selected, this.onSelected }): super(key: key);

  @override
  Widget build(BuildContext context) {
    var dcs = Durations.map((duration) {
      return new Material(
        type: MaterialType.button,
        color: Colors.red.shade500,
        child: Container(
          child: Center(
            child: SelectableImage(
              duration.icon,
              height: 180.0,
              width: 180.0,
              selected: (this.selected == duration),
              onTap: () { this.onSelected(duration); }
            ),
          ),
        )
      );
    }).toList();

    return SingleChildScrollView(
      child: Row(
        children: dcs,
      ),
      scrollDirection: Axis.horizontal
    );
  }
}