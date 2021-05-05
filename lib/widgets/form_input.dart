import 'package:flutter/material.dart';
import 'package:save_my_password/widgets/widgets.dart';

class FormInput extends StatefulWidget {
  final Function(String account, String username, String password) onPressed;
  final VoidCallback onBackupPressed;
  final VoidCallback onRestorePressed;

  FormInput({
    Key? key,
    required this.onPressed,
    required this.onBackupPressed,
    required this.onRestorePressed,
  }) : super(key: key);

  @override
  _FormInputState createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  late TextEditingController _accountController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    _accountController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _accountController,
          hintText: 'Account',
        ),
        const SizedBox(height: 10.0),
        CustomTextField(
          controller: _usernameController,
          hintText: 'Username',
        ),
        const SizedBox(height: 10.0),
        CustomTextField(
          controller: _passwordController,
          hintText: 'Password',
        ),
        const SizedBox(height: 10.0),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                onPressed: () {
                  if (_accountController.text.isNotEmpty &&
                      _usernameController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty) {
                    widget.onPressed(
                      _accountController.text,
                      _usernameController.text,
                      _passwordController.text,
                    );

                    _accountController.text = '';
                    _usernameController.text = '';
                    _passwordController.text = '';
                  }
                },
                child: Text('Simpan'),
              ),
            ),
            const Spacer(),
            Container(
              width: MediaQuery.of(context).size.width * 0.15,
              child: ElevatedButton(
                onPressed: widget.onBackupPressed,
                child: Icon(Icons.backup_outlined),
              ),
            ),
            const SizedBox(width: 10.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.15,
              child: ElevatedButton(
                onPressed: widget.onRestorePressed,
                child: Icon(Icons.restore_outlined),
              ),
            ),
          ],
        )
      ],
    );
  }
}
