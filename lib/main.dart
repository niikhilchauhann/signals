import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

import 'config/api/network_provider.dart';
import 'core/export.dart';
import 'features/cache_service/data/repository/cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }
  await CacheService.init();
  await Hive.initFlutter();
  await Hive.openBox('cache');

  await Hive.openBox<List>('watchlist_box');
  // await Supabase.initialize(
  //   url: dotenv.env['SUPABASE_URL'] ?? '',
  //   anonKey:  dotenv.env['ANON_KEY'] ?? '',
  // );
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseMessaging.instance.setAutoInitEnabled(true);
  // FirebaseFirestore.instance.settings = const Settings(
  //   persistenceEnabled: true,
  //   cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  // );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final authState = ref.watch(authStateProvider);
    return MaterialApp(
      title: 'Signals - Analyze. Trade.',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      home: ConnectivityWrapper(child: AppStructure()),

      // authState.when(
      //   data:
      //       (user) => ConnectivityWrapper(
      //         child: (user == null ? PreRegisterationScreen() : AppStructure()),
      //       ),
      //   loading:
      //       () => Scaffold(body: Center(child: CircularProgressIndicator())),
      //   error:
      //       (err, stack) => Scaffold(body: Center(child: Text("Error: $err"))),
      // ),
    );
  }
}
