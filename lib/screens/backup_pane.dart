import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:save_my_password/bloc/bloc.dart';
import 'package:save_my_password/models/account.dart';

class BackupPane extends StatefulWidget {
  const BackupPane({Key? key}) : super(key: key);

  @override
  _BackupPaneState createState() => _BackupPaneState();
}

class _BackupPaneState extends State<BackupPane> {
  final List<Account> _accounts = [];
  late AccountBloc _accountBloc;

  @override
  void initState() {
    _accountBloc = BlocProvider.of(context);

    AccountState state = _accountBloc.state;
    if (state is AccountGetsDataSuccess) {
      _accounts.addAll(state.accounts);
    }

    super.initState();
  }

  Future<void> _onBackupAction() async {
    DateFormat format = DateFormat('dd-MM-yyyy');
    String date = format.format(DateTime.now());

    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Save file to',
      type: FileType.custom,
      allowedExtensions: ['csv'],
      fileName: 'my-account-backup ($date).csv',
    );

    if (outputFile != null) {
      List<List<String>> rows = [
        ['Account', 'Email', 'Password'],
        ..._accounts.map((e) => [e.account, e.email, e.password]).toList(),
      ];
      String convert = ListToCsvConverter().convert(rows);

      try {
        File file = File(outputFile);
        await file.writeAsString(convert);

        _showContentDialog(outputFile);
      } catch (e) {
        log(e.toString(), name: '_onBackupAction');

        _showContentDialog(outputFile, isSuccess: false);
      }
    }
  }

  void _showContentDialog(String path, {bool isSuccess = true}) {
    showDialog(
      context: context,
      builder: (context) {
        return ContentDialog(
          title: Text(isSuccess ? 'Success export' : 'Failed export'),
          content: RichText(
            text: TextSpan(
              text: isSuccess
                  ? 'File saved to '
                  : 'Something wrong when export file to ',
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: path,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          actions: [
            Button(
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                backgroundColor: ButtonState.all<Color>(Colors.blue.light),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: PageHeader(title: Text('Backup your account')),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Export file to .csv format'),
          const SizedBox(height: 10.0),
          Button(
            child: Text('Save to'),
            onPressed: _onBackupAction,
          ),
        ],
      ),
    );
  }
}
