import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'src/features/notes/data/note_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // Override the noteRepositoryProvider with the actual implementation
  final container = ProviderContainer(
    overrides: [
      noteRepositoryProvider.overrideWithValue(NoteRepository(sharedPreferences)),
    ],
  );
  
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}
