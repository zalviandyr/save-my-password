import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_my_password/bloc/bloc.dart';
import 'package:save_my_password/models/account.dart';
import 'package:save_my_password/widgets/widgets.dart';

class RestorePane extends StatefulWidget {
  const RestorePane({Key? key}) : super(key: key);

  @override
  _RestorePaneState createState() => _RestorePaneState();
}

class _RestorePaneState extends State<RestorePane> {
  late AccountBloc _accountBloc;
  late File _selectedFile;

  @override
  void initState() {
    _accountBloc = BlocProvider.of(context);

    super.initState();
  }

  Future<void> _onOpenFileAction() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Open file',
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      _selectedFile = File(result.files.single.path!);

      _showRestoreBehaviorDialog();
    }
  }

  Future<void> _restoreAction(bool isFullRestore) async {
    String str = await _selectedFile.readAsString();
    List<List> list = CsvToListConverter().convert(str);

    // remove header
    list.removeAt(0);

    List<Account> accounts = [];

    for (var item in list) {
      accounts
          .add(Account(account: item[0], email: item[1], password: item[2]));
    }

    _accountBloc.add(
        AccountRestoreData(accounts: accounts, isFullRestore: isFullRestore));
  }

  void _showRestoreBehaviorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return RestoreBehaviorDialog(
          onOk: (isFullRestore) => _restoreAction(isFullRestore),
        );
      },
    );
  }

  void _showContentDialog({bool isSuccess = true}) {
    showDialog(
      context: context,
      builder: (context) {
        return ContentDialog(
          title: Text(isSuccess ? 'Success restore' : 'Failed restore'),
          content: RichText(
            text: TextSpan(
              text: isSuccess
                  ? 'Data restored '
                  : 'Something wrong when backup file',
              style: DefaultTextStyle.of(context).style,
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

  void _accountListener(BuildContext context, AccountState state) {
    if (state is AccountGetsDataSuccess) {
      _showContentDialog();
    }

    if (state is AccountError) {
      _showContentDialog(isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: _accountListener,
      child: ScaffoldPage.withPadding(
        header: PageHeader(title: Text('Restore your account')),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose file .csv to restore your account'),
            const SizedBox(height: 10.0),
            Button(
              child: Text('Open file'),
              onPressed: _onOpenFileAction,
            ),
          ],
        ),
      ),
    );
  }
}
