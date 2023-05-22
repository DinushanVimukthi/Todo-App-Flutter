import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/home.dart';
import 'package:todo/login.dart';
import 'package:todo/register.dart';
import 'package:todo/themeProvider.dart';
import 'package:todo/user.dart';

import 'Data/loginData.dart';
import 'Todo.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserProvider()),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: const Home())
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{



  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    const ColorScheme _colorScheme = ColorScheme(
      primary: Color.fromARGB(228, 113, 0, 112),
      primaryVariant: Colors.blueAccent,
      secondary: Colors.blue,
      secondaryVariant: Colors.blueAccent,
      surface: Colors.white,
      background: Color.fromARGB(255, 243, 242, 236),
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    );

    return MaterialApp(
      showSemanticsDebugger: false,
      theme: ThemeData.from(
        colorScheme: _colorScheme,
      ).copyWith(
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Open Sans',
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => LoginData.isLogged() ? const MyApp() : LoginApp(),
        '/login': (context) => !LoginData.isLogged() ? LoginApp() : const MyApp(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }

}
