import 'package:flutter/cupertino.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/viewmodels/theme_viewmodel.dart';

class DarkModeSwitch extends StatefulWidget {
  @override
  State<DarkModeSwitch> createState() {
    return _DarkModeSwitchState();
  }
}

class _DarkModeSwitchState extends State<DarkModeSwitch> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(
      builder: (context, themeViewModel, child) => SizedBox(
        width: 65,
        child: FlutterSwitch(
          value: themeViewModel.nightMode,
          onToggle: (value) {
            setState(() {
              Provider.of<ThemeViewModel>(context, listen: false)
                  .setNightMode(value);
            });
          },
          toggleSize: 20.0,
          height: 25,
          width: 65,
          padding: 4.0,
          activeColor: kAccentColor,
          showOnOff: true,
        ),
      ),
    );
  }
}
