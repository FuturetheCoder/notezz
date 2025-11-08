import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/note.dart';

class NoteRepository {
  static const _key = 'notes';
  final SharedPreferences _prefs;

  NoteRepository(this._prefs);

  Future<List<Note>> getNotes() async {
    final notesJson = _prefs.getStringList(_key) ?? [];
    return notesJson
        .map((noteJson) => Note.fromJson(jsonDecode(noteJson)))
        .toList();
  }

  Future<void> saveNotes(List<Note> notes) async {
    final notesJson = notes.map((note) => jsonEncode(note.toJson())).toList();
    await _prefs.setStringList(_key, notesJson);
  }

  Future<void> addNote(Note note) async {
    final notes = await getNotes();
    notes.add(note);
    await saveNotes(notes);
  }

  Future<void> updateNote(Note updatedNote) async {
    final notes = await getNotes();
    final index = notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      notes[index] = updatedNote;
      await saveNotes(notes);
    }
  }

  Future<void> deleteNote(String id) async {
    final notes = await getNotes();
    notes.removeWhere((note) => note.id == id);
    await saveNotes(notes);
  }
}

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  throw UnimplementedError('NoteRepositoryProvider was not initialized');
});
