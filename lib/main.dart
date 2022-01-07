import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:movies_app/providers/movie_provider.dart';
import 'package:movies_app/screens/screens.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {

  const AppState({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider(), lazy: false)
      ],
      child: const MyApp(),
    );
  }

}

class MyApp extends StatelessWidget {

  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies App',
      initialRoute: 'home',
      routes: {
        'home' : (_) => const HomeScreen(),
        'details' : (_) => const DetailsScreen()
      },
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          color: Colors.indigo,
          elevation: 0
        )
      ),
    );
  }

}
