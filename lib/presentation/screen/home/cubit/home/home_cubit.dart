import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_demo/data/model/note_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final CollectionReference notesRef = FirebaseFirestore.instance.collection(
    'noteList',
  );
  Future<void> fetchNotes(String? userId) async {
    emit(HomeLoading());
    try {
      final uId = FirebaseAuth.instance.currentUser?.uid ?? 'oiuy6578900';
      final snapshot = await FirebaseFirestore.instance
          .collection('noteList')
          .where('user_id', isEqualTo: userId ?? uId)
          .orderBy('created_at', descending: true)
          .get();

      final notes = snapshot.docs.map((doc) => NoteModel.fromDoc(doc)).toList();

      emit(HomeSuccess(notes: notes));
    } catch (e) {
      emit(
        HomeFailed(
          error:
              e.toString().contains(
                'Unable to resolve host "firestore.googleapis.com"',
              )
              ? 'No internet connection. please try again'
              : e.toString(),
        ),
      );
    }
  }

  Future<void> addNote({
    required String title,
    required String content,
    required String userId,
  }) async {
    try {
      await notesRef.add({
        'title': title,
        'content': content,
        'user_id': userId,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      await fetchNotes(userId);
    } catch (e) {
      emit(
        HomeFailed(
          error:
              e.toString().contains(
                'Unable to resolve host "firestore.googleapis.com"',
              )
              ? 'No internet connection. please try again'
              : e.toString(),
        ),
      );
    }
  }

  Future<void> updateNote({
    required String id,
    required String title,
    required String content,
    required String userId,
  }) async {
    try {
      await notesRef.doc(id).update({
        'title': title,
        'content': content,
        'updated_at': FieldValue.serverTimestamp(),
      });

      await fetchNotes(userId);
    } catch (e) {
      emit(
        HomeFailed(
          error:
              e.toString().contains(
                'Unable to resolve host "firestore.googleapis.com"',
              )
              ? 'No internet connection. please try again'
              : e.toString(),
        ),
      );
    }
  }

  Future<void> deleteNote({required String id, required String userId}) async {
    try {
      await notesRef.doc(id).delete();
      await fetchNotes(userId);
    } catch (e) {
      emit(
        HomeFailed(
          error:
              e.toString().contains(
                'Unable to resolve host "firestore.googleapis.com"',
              )
              ? 'No internet connection. please try again'
              : e.toString(),
        ),
      );
    }
  }
}
