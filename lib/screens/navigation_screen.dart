import 'package:fluent_ui/fluent_ui.dart';
import 'package:save_my_password/screens/screens.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(
        selected: 0,
        displayMode: PaneDisplayMode.compact,
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
        index: 0,
        children: [
          MyAccountPane(),
          ScaffoldPage(
            header: Text('Manage your account'),
            content: Text('Account'),
          ),
          ScaffoldPage(
            header: Text('Manage your account'),
            content: Text('Account'),
          ),
        ],
      ),
    );
  }
}
