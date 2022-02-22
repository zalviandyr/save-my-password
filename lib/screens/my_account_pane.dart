import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_my_password/bloc/bloc.dart';
import 'package:save_my_password/models/account.dart';
import 'package:save_my_password/widgets/widgets.dart';

class MyAccountPane extends StatefulWidget {
  const MyAccountPane({Key? key}) : super(key: key);

  @override
  _MyAccountPaneState createState() => _MyAccountPaneState();
}

class _MyAccountPaneState extends State<MyAccountPane> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  late AccountBloc _accountBloc;

  @override
  void initState() {
    _accountBloc = BlocProvider.of(context);

    _accountBloc.add(AccountGetsData());

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController2.dispose();

    super.dispose();
  }

  void _onSaveAction(String account, String email, String password) {
    Account accountData = Account(
      account: account,
      email: email,
      password: password,
    );

    _accountBloc.add(AccountSaveData(account: accountData));
  }

  void _onUpdateAction(Account account) {
    _accountBloc.add(AccountUpdateData(account: account));
  }

  void _onDeleteAction(Account account) {
    _accountBloc.add(AccountDeleteData(account: account));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(title: Text('Manage your account')),
      content: Row(
        children: [
          Flexible(
            child: AddAccount(
              onSave: _onSaveAction,
              scrollController: _scrollController,
            ),
          ),
          Flexible(
            child: DataTableAccount(
              scrollController: _scrollController2,
              onUpdate: _onUpdateAction,
              onDelete: _onDeleteAction,
            ),
          ),
        ],
      ),
    );
  }
}
