import 'package:flutter/material.dart';
import 'package:my_browser/provider.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';

enum SearchEngine { Google, Yahoo, Bing, DuckDuckGo }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => mirrorWallProvider())
      ],
      child: Consumer<mirrorWallProvider>(builder: (context, provider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
          ),
          home: MyHomePage(),
        );
      }),
    );
  }
}
