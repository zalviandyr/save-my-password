import 'package:flutter/material.dart';
import 'package:save_my_password/models/account_model.dart';
import 'package:save_my_password/widgets/widgets.dart';

class FormModalBottomSheet extends StatefulWidget {
  final AccountModel accountModel;
  final Function(AccountModel) onEditPressed;
  final Function(AccountModel) onDeletePressed;

  const FormModalBottomSheet({
    Key? key,
    required this.accountModel,
    required this.onEditPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  _FormModalBottomSheetState createState() => _FormModalBottomSheetState();
}

class _FormModalBottomSheetState extends State<FormModalBottomSheet> {
  late TextEditingController _accountController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    _accountController = TextEditingController()
      ..text = widget.accountModel.account;
    _usernameController = TextEditingController()
      ..text = widget.accountModel.username;
    _passwordController = TextEditingController()
      ..text = widget.accountModel.password;
  }

  @override
  void dispose() {
    super.dispose();

    _accountController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Account Detail',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit_outlined),
                onPressed: () {
                  Navigator.pop(context);

                  AccountModel accountModel = AccountModel(
                    id: widget.accountModel.id,
                    account: _accountController.text,
                    username: _usernameController.text,
                    password: _passwordController.text,
                  );

                  widget.onEditPressed(accountModel);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  Navigator.pop(context);

                  widget.onDeletePressed(widget.accountModel);
                },
              ),
              IconButton(
                icon: Icon(Icons.close_outlined),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          CustomTextField(
            controller: _accountController,
            copied: true,
          ),
          const SizedBox(height: 10.0),
          CustomTextField(
            controller: _usernameController,
            copied: true,
          ),
          const SizedBox(height: 10.0),
          CustomTextField(
            controller: _passwordController,
            copied: true,
          ),
        ],
      ),
    );
  }
}
