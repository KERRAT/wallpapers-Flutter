import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/screens/drawers/end_drawer_functions/wallpaper_change_method.dart';

class ChangeMethodTile extends StatefulWidget {
  final WallpaperChangeMethod changeMethod;
  final ValueChanged<WallpaperChangeMethod> onChanged;

  const ChangeMethodTile({
    required this.changeMethod,
    required this.onChanged,
  });

  @override
  _ChangeMethodTileState createState() => _ChangeMethodTileState();
}

class _ChangeMethodTileState extends State<ChangeMethodTile> {
  WallpaperChangeMethod _changeMethod = WallpaperChangeMethod.sequential;

  @override
  void initState() {
    super.initState();
    _changeMethod = widget.changeMethod;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Change Method'),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _changeMethod == WallpaperChangeMethod.sequential
                  ? Colors.blue
                  : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _changeMethod = WallpaperChangeMethod.sequential;
              });
              widget.onChanged(WallpaperChangeMethod.sequential);
            },
            child: const Text(
              'Sequential',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _changeMethod == WallpaperChangeMethod.random
                  ? Colors.blue
                  : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _changeMethod = WallpaperChangeMethod.random;
              });
              widget.onChanged(WallpaperChangeMethod.random);
            },
            child: const Text(
              'Random',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
