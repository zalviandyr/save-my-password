import 'package:fluent_ui/fluent_ui.dart';
import 'package:save_my_password/validators/field_validator.dart';

class AddAccount extends StatefulWidget {
  final Function(String account, String email, String password) onSave;
  final ScrollController scrollController;

  const AddAccount({
    Key? key,
    required this.onSave,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _saveFocus = FocusNode();
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  void dispose() {
    _accountController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _saveAction() {
    if (_key.currentState!.validate()) {
      String account = _accountController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      widget.onSave(account, email, password);

      _resetAction();
    }
  }

  void _resetAction() {
    _key.currentState!.reset();

    _accountController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: ScaffoldPage.scrollable(
        scrollController: widget.scrollController,
        children: [
          TextFormBox(
            controller: _accountController,
            placeholder: 'Your account',
            header: 'Account',
            validator: FieldValidator.required,
            onFieldSubmitted: (value) => _emailFocus.requestFocus(),
          ),
          const SizedBox(height: 10.0),
          TextFormBox(
            focusNode: _emailFocus,
            controller: _emailController,
            placeholder: 'Your email or username',
            header: 'Email or Username',
            validator: FieldValidator.required,
            onFieldSubmitted: (value) => _passwordFocus.requestFocus(),
          ),
          const SizedBox(height: 10.0),
          TextFormBox(
            focusNode: _passwordFocus,
            controller: _passwordController,
            placeholder: 'Your password',
            header: 'Password',
            validator: FieldValidator.required,
            onFieldSubmitted: (value) => _saveFocus.requestFocus(),
          ),
          const SizedBox(height: 25.0),
          Row(
            children: [
              Expanded(
                child: Button(
                  focusNode: _saveFocus,
                  child: Text('Save'),
                  onPressed: _saveAction,
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Button(
                  child: Text('Reset'),
                  onPressed: _resetAction,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
