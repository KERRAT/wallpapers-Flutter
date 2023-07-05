import 'package:flutter/material.dart';

import '../end_drawer_functions/value_conversion.dart';

class ChangeIntervalTile extends StatefulWidget {
  final double changeInterval;
  final ValueChanged<double> onChanged;

  const ChangeIntervalTile({
    required this.changeInterval,
    required this.onChanged,
  });

  @override
  _ChangeIntervalTileState createState() => _ChangeIntervalTileState();
}

class _ChangeIntervalTileState extends State<ChangeIntervalTile> {
  late double _changeInterval;

  @override
  void initState() {
    super.initState();
    _changeInterval = widget.changeInterval;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Change Interval'),
      subtitle: Slider(
        value: getSliderValue(_changeInterval),
        min: 3.0,
        max: 35.0, // 12 * 5 minutes + 24 hours
        divisions: 32, // to provide 5 minutes and 1 hour steps
        onChanged: (newValue) {
          setState(() {
            _changeInterval = getRealValue(newValue);;
          });
          widget.onChanged(getRealValue(newValue));
        },
        label: getReadableInterval(_changeInterval),
      ),
      trailing: SizedBox(
        width: 35.0, // you can adjust this value as per your requirement
        child: Text(
          getReadableInterval(_changeInterval),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}
