import 'package:fluent_ui/fluent_ui.dart';
import 'package:save_my_password/screens/screens.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final List<Widget> _panes = [
    MyAccountPane(),
    BackupPane(),
    BackupPane(),
  ];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(
        selected: _selected,
        displayMode: PaneDisplayMode.compact,
        onChanged: (index) => setState(() => _selected = index),
        items: [
          PaneItem(
            icon: Icon(FluentIcons.accounts),
            title: Text('My Accounts'),
          ),
          PaneItem(
            icon: Icon(FluentIcons.archive),
            title: Text('Backup'),
          ),
          PaneItem(
            icon: Icon(FluentIcons.update_restore),
            title: Text('Restore'),
          ),
        ],
      ),
      content: NavigationBody(
        index: _selected,
        children: _panes,
      ),
    );
  }
}
