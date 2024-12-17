import 'package:camera_app/data/models/entry.dart';

abstract class AppState {}

class Idle extends AppState {}

class Loading<T extends AppState> extends AppState {}

class CameraReadyState extends AppState {}

class AudioReadyState extends AppState {}

class ChangePageState extends AppState {}

class ShowEntryState extends AppState {
  final Entry entry;

  ShowEntryState({required this.entry});
}

class AddPhotoState extends AppState {
  final Entry entry;

  AddPhotoState({required this.entry});
}

class DeletePhotoSuccessful extends AppState {}

class DeletePhotoEntrySuccessful extends AppState {}

class DeleteAudioSuccessful extends AppState {}

class DeleteAudioEntrySuccessful extends AppState {}

class DeleteAllWithoutFileState extends AppState {}

class GotAllPhotos extends AppState {
  final List<Entry> entries;

  GotAllPhotos({required this.entries});
}

class AddAudioState extends AppState {
  final Entry entry;

  AddAudioState({required this.entry});
}

class GotAllAudio extends AppState {
  final List<Entry> entries;

  GotAllAudio({required this.entries});
}
