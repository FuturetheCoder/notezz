import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notezz/src/core/theme/theme_provider.dart';
import 'package:notezz/src/features/notes/domain/note.dart';
import '../note_provider.dart';
import '../widgets/note_item.dart';
import 'note_editor_screen.dart';

class NotesListScreen extends ConsumerWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notezz'),
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final isDarkMode = ref.watch(themeProvider);
              return IconButton(
                icon: Icon(
                  isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const Center(
              child: Text('No notes yet. Tap + to add one!'),
            );
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteItem(
                title: note.title,
                content: note.content,
                onTap: () => _navigateToEditScreen(context, note),
                onDelete: () => _deleteNote(ref, note.id, context),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, _) {
          final isDarkMode = ref.watch(themeProvider);
          return FloatingActionButton(
            onPressed: () => _navigateToEditScreen(context, null),
            backgroundColor: isDarkMode ? Colors.white : Colors.black,
            foregroundColor: isDarkMode ? Colors.black : Colors.white,
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }

  void _navigateToEditScreen(BuildContext context, Note? note) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(note: note),
      ),
    );
  }

  Future<void> _deleteNote(WidgetRef ref, String id, dynamic context) async {
    try {
      await ref.read(notesProvider.notifier).deleteNote(id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete note: $e')),
        );
      }
    }
  }
}
