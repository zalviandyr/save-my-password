import 'package:fluent_ui/fluent_ui.dart';

class RestoreBehaviorDialog extends StatefulWidget {
  final void Function(bool isFullRestore) onOk;

  const RestoreBehaviorDialog({
    Key? key,
    required this.onOk,
  }) : super(key: key);

  @override
  _RestoreBehaviorDialogState createState() => _RestoreBehaviorDialogState();
}

class _RestoreBehaviorDialogState extends State<RestoreBehaviorDialog> {
  bool _fullRestore = true;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text('Restore behavior'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose restore behavior'),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Checkbox(
                checked: _fullRestore,
                onChanged: (value) {
                  print(value);
                  setState(() => _fullRestore = value!);
                },
                content: Text('Full restore'),
              ),
              const SizedBox(width: 5.0),
              Tooltip(
                message: 'Delete old data and re-create it',
                style: TooltipThemeData(
                  showDuration: Duration(milliseconds: 0),
                  waitDuration: Duration(milliseconds: 0),
                ),
                child: Icon(FluentIcons.info),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                checked: !_fullRestore,
                onChanged: (value) => setState(() => _fullRestore = !value!),
                content: Text('Partial restore'),
              ),
              const SizedBox(width: 5.0),
              Tooltip(
                message: 'Just add new data in .csv file',
                style: TooltipThemeData(
                  showDuration: Duration(milliseconds: 0),
                  waitDuration: Duration(milliseconds: 0),
                ),
                child: Icon(FluentIcons.info),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Button(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        Button(
          child: Text(
            'Ok',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);

            widget.onOk(_fullRestore);
          },
          style: ButtonStyle(
            backgroundColor: ButtonState.all<Color>(Colors.blue.light),
          ),
        ),
      ],
    );
  }
}
