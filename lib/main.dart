import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:my_collections/models/mc_db.dart';
import 'package:my_collections/models/mc_local_storage.dart';
import 'package:my_collections/models/mc_model.dart';
import 'package:my_collections/views/collection_list/collection_list.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MCDB.init();
  await MCLocalStorage.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => MCModel(),
      child: const MyCollectionsApp(),
    ),
  );
}

class MyCollectionsApp extends StatelessWidget {
  static final _defaultLightColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blueGrey,
  );
  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blueGrey,
    brightness: Brightness.dark,
  );

  const MyCollectionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp(
        title: 'My Collections',
        theme: ThemeData(
          colorScheme: lightDynamic ?? _defaultLightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkDynamic ?? _defaultDarkColorScheme,
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const CollectionList(),
      ),
    );
  }
}
