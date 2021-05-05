import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:save_my_password/bloc/account_bloc.dart';
import 'package:save_my_password/event_state/event_state.dart';
import 'package:save_my_password/models/account_model.dart';
import 'package:save_my_password/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _currentValue;
  late List<AccountModel> _accounts;
  late AccountBloc _accountBloc;

  @override
  void initState() {
    super.initState();

    _accounts = [];
    _accountBloc = BlocProvider.of<AccountBloc>(context);
  }

  void _showDialog(String title, String body, VoidCallback onPressed) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: Theme.of(context).textTheme.bodyText1),
          content: Text(body, style: Theme.of(context).textTheme.bodyText1),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onPressed();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: Text('Yes', style: Theme.of(context).textTheme.bodyText1),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No', style: Theme.of(context).textTheme.bodyText1),
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar({bool isError = false}) {
    AccountState state = _accountBloc.state;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        state.toString(),
        style: Theme.of(context).textTheme.bodyText1,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: isError ? Colors.red : Theme.of(context).accentColor,
    ));
  }

  void _onSelectedRow(AccountModel accountModel) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return Wrap(children: [
          FormModalBottomSheet(
            accountModel: accountModel,
            onEditPressed: (accountModel) {
              _showDialog(
                'Update',
                'Are you sure to update it ?',
                () =>
                    _accountBloc.add(AccountUpdateData(account: accountModel)),
              );
            },
            onDeletePressed: (accountModel) {
              _showDialog(
                'Delete',
                'Are you sure to delete it ?',
                () =>
                    _accountBloc.add(AccountDeleteData(account: accountModel)),
              );
            },
          ),
        ]);
      },
    );
  }

  void _onChanged(String? value) {
    setState(() => _currentValue = value);

    if (value == 'All') {
      _accountBloc.add(AccountGetsData());
    } else {
      _accountBloc.add(AccountGetsData(isAll: false, accountFilter: value!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: FormInput(
                onPressed:
                    (String account, String username, String password) async {
                  AccountModel accountModel = AccountModel(
                    account: account,
                    username: username,
                    password: password,
                  );

                  _accountBloc.add(AccountSaveData(account: accountModel));
                },
                onBackupPressed: () async {
                  String? path = await FilesystemPicker.open(
                    context: context,
                    title: 'Save to folder',
                    rootDirectory: (await getDownloadsDirectory())!,
                    fsType: FilesystemType.folder,
                    pickText: 'Save file backup to this folder',
                    folderIconColor: Theme.of(context).accentColor,
                  );

                  if (path != null)
                    _accountBloc.add(AccountBackupData(path: path));
                },
                onRestorePressed: () async {
                  String? path = await FilesystemPicker.open(
                    context: context,
                    allowedExtensions: ['.csv'],
                    title: 'Choose file to restore',
                    rootDirectory: (await getDownloadsDirectory())!,
                    fsType: FilesystemType.file,
                    folderIconColor: Theme.of(context).accentColor,
                    fileTileSelectMode: FileTileSelectMode.wholeTile,
                  );

                  if (path != null)
                    _accountBloc.add(AccountRestoreData(filePath: path));
                },
              ),
            ),
            const SizedBox(height: 10.0),
            const Divider(height: 10.0),
            const SizedBox(height: 10.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  isExpanded: true,
                  value: _currentValue,
                  hint: Text('Account filter'),
                  onChanged: _onChanged,
                  style: Theme.of(context).textTheme.bodyText1,
                  items: [
                    DropdownMenuItem(
                      child: Text('All',
                          style: Theme.of(context).textTheme.bodyText1),
                      value: 'All',
                    ),
                  ]..addAll(_accounts.map((e) {
                      return DropdownMenuItem(
                        child: Text(e.account,
                            style: Theme.of(context).textTheme.bodyText1),
                        value: e.account,
                      );
                    })),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const Divider(height: 10.0),
            BlocConsumer<AccountBloc, AccountState>(
              listener: (context, state) {
                if (state is AccountModifyDataSuccess) {
                  _showSnackbar();
                }

                if (state is AccountError) _showSnackbar(isError: true);

                if (state is AccountGetsDataSuccess)
                  setState(() =>
                      _accounts = state.filterAccountModels.toSet().toList());
              },
              builder: (context, state) {
                if (state is AccountGetsDataSuccess)
                  return Expanded(
                    child: Scrollbar(
                      isAlwaysShown: true,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          DataTable(
                            headingRowColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).accentColor),
                            dataRowHeight: 30.0,
                            headingRowHeight: 30.0,
                            showCheckboxColumn: false,
                            columnSpacing: 10.0,
                            horizontalMargin: 10.0,
                            showBottomBorder: true,
                            columns: [
                              DataColumn(label: Text('Account')),
                              DataColumn(label: Text('Username')),
                              DataColumn(label: Text('Password')),
                            ],
                            rows: state.accountModels.map((value) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(value.account)),
                                  DataCell(Text(value.username)),
                                  DataCell(Text(
                                    value.password,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                ],
                                onSelectChanged: (_) => _onSelectedRow(value),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                  );

                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
