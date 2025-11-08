import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/note_repository.dart';
import '../domain/note.dart';

final notesProvider = StateNotifierProvider<NotesNotifier, AsyncValue<List<Note>>>(
  (ref) {
    final repository = ref.watch(noteRepositoryProvider);
    return NotesNotifier(repository);
  },
);

class NotesNotifier extends StateNotifier<AsyncValue<List<Note>>> {
  final NoteRepository _repository;

  NotesNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      state = const AsyncValue.loading();
      final notes = await _repository.getNotes();
      state = AsyncValue.data(notes);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addNote(Note note) async {
    try {
      await _repository.addNote(note);
      await _loadNotes();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await _repository.updateNote(note);
      await _loadNotes();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _repository.deleteNote(id);
      await _loadNotes();
    } catch (e) {
      rethrow;
    }
  }
}
