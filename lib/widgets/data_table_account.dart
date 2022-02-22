import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_my_password/bloc/bloc.dart';
import 'package:save_my_password/models/account.dart';
import 'package:save_my_password/validators/field_validator.dart';

class DataTableAccount extends StatefulWidget {
  final ScrollController scrollController;
  final Function(Account account) onUpdate;
  final Function(Account account) onDelete;

  const DataTableAccount({
    Key? key,
    required this.scrollController,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  _DataTableAccountState createState() => _DataTableAccountState();
}

class _DataTableAccountState extends State<DataTableAccount> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<List<Account>> _accountsNotifier = ValueNotifier([]);
  final GlobalKey<FormState> _key = GlobalKey();
  List<Account> _accountsBase = [];

  @override
  void dispose() {
    _accountController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _onUpdateAction(Account account) {
    if (_key.currentState!.validate()) {
      account.account = _accountController.text.trim();
      account.email = _emailController.text.trim();
      account.password = _passwordController.text.trim();

      Navigator.pop(context);

      widget.onUpdate(account);
    }
  }

  void _onDeleteAction(Account account) {
    Navigator.pop(context);

    widget.onDelete(account);
  }

  void _onAccountDialogAction(Account account) {
    _accountController.text = account.account;
    _emailController.text = account.email;
    _passwordController.text = account.password;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return ContentDialog(
          title: Text('Modify your account'),
          content: Form(
            key: _key,
            child: Column(
              children: [
                TextFormBox(
                  controller: _accountController,
                  header: 'Account',
                  validator: FieldValidator.required,
                ),
                TextFormBox(
                  controller: _emailController,
                  header: 'Email or username',
                  validator: FieldValidator.required,
                  suffix: IconButton(
                    icon: Icon(FluentIcons.copy),
                    onPressed: () => Clipboard.setData(
                        ClipboardData(text: _emailController.text)),
                  ),
                ),
                TextFormBox(
                  controller: _passwordController,
                  header: 'Password',
                  validator: FieldValidator.required,
                  suffix: IconButton(
                    icon: Icon(FluentIcons.copy),
                    onPressed: () => Clipboard.setData(
                        ClipboardData(text: _passwordController.text)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Button(
              onPressed: () => _onUpdateAction(account),
              child: Text('Update'),
            ),
            Button(
              onPressed: () {
                Navigator.pop(context);

                _onDeleteDialogAction(account);
              },
              style: ButtonStyle(
                backgroundColor: ButtonState.all<Color>(Colors.red.light),
              ),
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onDeleteDialogAction(Account account) {
    showDialog(
      context: context,
      builder: (context) {
        return ContentDialog(
          title: Text('Delete account'),
          content: Text('Are you sure to delete it ?'),
          actions: [
            Button(
              child: Text('Yes'),
              onPressed: () => _onDeleteAction(account),
            ),
            Button(
              child: Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);

                _onAccountDialogAction(account);
              },
              style: ButtonStyle(
                backgroundColor: ButtonState.all<Color>(Colors.blue.light),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onSearchChanged(String value) {
    List<Account> accounts = _accountsBase
        .where(
          (element) =>
              element.account.contains(value) || element.email.contains(value),
        )
        .toList();

    _accountsNotifier.value = value.isEmpty ? _accountsBase : accounts;
  }

  void _accountListener(BuildContext context, AccountState state) {
    if (state is AccountGetsDataSuccess) {
      _accountsNotifier.value = state.accounts;
      _accountsBase = state.accounts;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      scrollController: widget.scrollController,
      children: [
        TextBox(
          placeholder: 'Search saved account',
          header: 'Search',
          expands: true,
          maxLines: null,
          onChanged: _onSearchChanged,
        ),
        const SizedBox(height: 20.0),
        BlocListener<AccountBloc, AccountState>(
          listener: _accountListener,
          child: material.Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            child: ValueListenableBuilder<List<Account>>(
              valueListenable: _accountsNotifier,
              builder: (context, accounts, child) {
                return DataTable2(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        width: 1,
                        color: Color.fromRGBO(0, 0, 0, 0.08),
                      ),
                    ),
                    dataRowHeight: 35.0,
                    border: TableBorder.symmetric(
                      inside: BorderSide(
                        width: 1,
                        color: Color.fromRGBO(0, 0, 0, 0.08),
                      ),
                    ),
                    headingRowHeight: 40.0,
                    columns: [
                      DataColumn2(
                        label: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Account',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      DataColumn2(
                        label: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                    rows: accounts.map((e) {
                      return DataRow2(
                        onTap: () => _onAccountDialogAction(e),
                        cells: [
                          material.DataCell(Text(e.account)),
                          material.DataCell(Text(e.email)),
                        ],
                      );
                    }).toList()
                    // rows: (state is AccountGetsDataSuccess)
                    //     ? state.accounts.map((e) {
                    //         return DataRow2(
                    //           onTap: () => _onAccountDialogAction(e),
                    //           cells: [
                    //             material.DataCell(Text(e.account)),
                    //             material.DataCell(Text(e.email)),
                    //           ],
                    //         );
                    //       }).toList()
                    //     : [],
                    );
              },
            ),
          ),
        ),
        // BlocConsumer<AccountBloc, AccountState>(
        //   listener: _accountListener,
        //   builder: (context, state) {
        //     return ;
        //   },
        // ),
      ],
    );
  }
}
