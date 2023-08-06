import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yt_downloader_v2/models/app_state.dart';
import 'package:yt_downloader_v2/reducers/app_reducer.dart';
import 'package:yt_downloader_v2/screens/home_page.dart';
import 'package:redux/redux.dart';

import 'middleware/download_creator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp(
    store: Store<AppState>(appReducer,
        initialState: AppState(downloadList: []),
        middleware: [downloadCreatorMiddleware]),
  ));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
            cardTheme: const CardTheme(elevation: 0.0),
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
              TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
              TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
              TargetPlatform.windows: ZoomPageTransitionsBuilder(),
              TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
              TargetPlatform.linux: ZoomPageTransitionsBuilder(),
            }),
            textTheme:
                GoogleFonts.rubikTextTheme().apply(bodyColor: Colors.white)),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}
