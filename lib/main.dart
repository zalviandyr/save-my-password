import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:save_my_password/bloc/account_bloc.dart';
import 'package:save_my_password/screens/screens.dart';
import 'package:save_my_password/services/database.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependency Injection
  final AppDatabase database =
      await $FloorAppDatabase.databaseBuilder('save_my_password.db').build();
  GetIt.I.registerSingleton<AppDatabase>(database);

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowMinSize(Size(1000, 600));
    setWindowMaxSize(Size(1000, 600));
    setWindowTitle('Save My Password');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AccountBloc()),
      ],
      child: FluentApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Save My Password',
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        home: NavigationScreen(),
      ),
    );
  }
}
