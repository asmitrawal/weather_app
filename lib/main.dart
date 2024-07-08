import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weather_app/repository/location_repository.dart';
import 'package:weather_app/repository/supabase_repository.dart';
import 'package:weather_app/repository/weather_repository.dart';
import 'package:weather_app/ui/weather_screen.dart';

const supabaseUrl = 'https://kmluxqbvebugwpnwzdxt.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImttbHV4cWJ2ZWJ1Z3dwbnd6ZHh0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAzNjA3MzUsImV4cCI6MjAzNTkzNjczNX0.vzRqNM_eS1ohnkW3rmiltXCfBiIbCxQKkoBNFJbeWsg';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          fontFamily: GoogleFonts.raleway().fontFamily,
          useMaterial3: true,
        ),
        home: MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
              create: (context) => LocationRepository(),
            ),
            RepositoryProvider(
              create: (context) => WeatherRepository(),
            ),
            RepositoryProvider(
              create: (context) => SupabaseRepository(),
            ),
          ],
          child: WeatherScreen(),
        ),
      ),
    );
  }
}
