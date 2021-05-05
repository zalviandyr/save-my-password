import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_my_password/bloc/account_bloc.dart';
import 'package:save_my_password/screens/screens.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    setWindowMinSize(Size(600, 600));
    setWindowMaxSize(Size(600, 600));
    setWindowTitle('Save My Password');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Save My Password',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF282C34),
        accentColor: Color(0xFF1D1F23),
      ),
      home: BlocProvider(
        create: (context) => AccountBloc(),
        child: HomeScreen(),
      ),
    );
  }
}
