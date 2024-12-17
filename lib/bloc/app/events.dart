import 'package:camera_app/data/models/entry.dart';

abstract class AppEvent {}

class GetAllPhotosEvent extends AppEvent {}

class TakingPhotoEvent extends AppEvent {}

class ChangePageEvent extends AppEvent {}

class ShowEntryEvent extends AppEvent {
  final Entry entry;

  ShowEntryEvent({required this.entry});
}

class AddPhotoEvent extends AppEvent {
  final Entry entry;

  AddPhotoEvent({required this.entry});
}

class DeletePhotoEvent extends AppEvent {
  final Entry entry;

  DeletePhotoEvent({required this.entry});
}

class DeleteAllWithoutPhotoEvent extends AppEvent {}

class GetAllAudioEvent extends AppEvent {}

class TakingAudioEvent extends AppEvent {}

class AddAudioEvent extends AppEvent {
  final Entry entry;

  AddAudioEvent({required this.entry});
}

class DeleteAudioEvent extends AppEvent {
  final Entry entry;

  DeleteAudioEvent({required this.entry});
}

class DeleteAllWithoutAudioEvent extends AppEvent {}

class DeletePhotoEntryEvent extends AppEvent {
  final int id;

  DeletePhotoEntryEvent({required this.id});
}

class DeleteAudioEntryEvent extends AppEvent {
  final int id;

  DeleteAudioEntryEvent({required this.id});
}
