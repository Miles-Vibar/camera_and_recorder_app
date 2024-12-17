import 'package:camera_app/bloc/app/events.dart';
import 'package:camera_app/bloc/app/state.dart';
import 'package:camera_app/data/repositories/audio_repository.dart';
import 'package:camera_app/data/repositories/photo_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(Idle()) {
    on<GetAllPhotosEvent>((event, emit) async {
      emit(Loading<GotAllPhotos>());
      PhotoRepository photoRepository = PhotoRepository();
      final photos = await photoRepository.getAll();
      emit(GotAllPhotos(entries: photos));
    });
    on<ChangePageEvent>((event, emit) {
      emit(ChangePageState());
      emit(Idle());
    });
    on<TakingPhotoEvent>((event, emit) {
      emit(Loading<CameraReadyState>());
      emit(CameraReadyState());
    });
    on<ShowEntryEvent>((event, emit) {
      emit(ShowEntryState(entry: event.entry));
    });
    on<AddPhotoEvent>((event, emit) async {
      emit(Loading<AddPhotoState>());
      PhotoRepository photoRepository = PhotoRepository();
      final entry = await photoRepository.add(event.entry);
      emit(AddPhotoState(entry: entry));
    });
    on<GetAllAudioEvent>((event, emit) async {
      emit(Loading<GotAllAudio>());
      AudioRepository audioRepository = AudioRepository();
      final audio = await audioRepository.getAll();
      emit(GotAllAudio(entries: audio));
    });
    on<TakingAudioEvent>((event, emit) {
      emit(Loading<AudioReadyState>());
      emit(AudioReadyState());
    });
    on<AddAudioEvent>((event, emit) async {
      emit(Loading<AddAudioState>());
      AudioRepository audioRepository = AudioRepository();
      final entry = await audioRepository.add(event.entry);
      emit(AddAudioState(entry: entry));
    });
    on<DeletePhotoEvent>((event, emit) async {
      emit(Loading<DeletePhotoSuccessful>());
      PhotoRepository photoRepository = PhotoRepository();
      await photoRepository.deleteFile(event.entry);
      emit(DeletePhotoSuccessful());
      add(GetAllPhotosEvent());
    });
    on<DeletePhotoEntryEvent>((event, emit) async {
      emit(Loading<DeletePhotoEntrySuccessful>());
      PhotoRepository photoRepository = PhotoRepository();
      await photoRepository.deleteEntry(event.id);
      emit(DeletePhotoEntrySuccessful());
      add(GetAllPhotosEvent());
    });
    on<DeleteAllWithoutPhotoEvent>((event, emit) async {
      emit(Loading<DeleteAllWithoutFileState>());
      PhotoRepository photoRepository = PhotoRepository();
      await photoRepository.deleteAllWithoutFile();
      emit(DeleteAllWithoutFileState());
      add(GetAllPhotosEvent());
    });
    on<DeleteAudioEvent>((event, emit) async {
      emit(Loading<DeleteAudioSuccessful>());
      AudioRepository audioRepository = AudioRepository();
      await audioRepository.deleteFile(event.entry);
      emit(DeleteAudioSuccessful());
      add(GetAllAudioEvent());
    });
    on<DeleteAudioEntryEvent>((event, emit) async {
      emit(Loading<DeleteAudioEntrySuccessful>());
      AudioRepository audioRepository = AudioRepository();
      await audioRepository.deleteEntry(event.id);
      emit(DeleteAudioEntrySuccessful());
      add(GetAllAudioEvent());
    });
    on<DeleteAllWithoutAudioEvent>((event, emit) async {
      emit(Loading<DeleteAllWithoutFileState>());
      AudioRepository audioRepository = AudioRepository();
      await audioRepository.deleteAllWithoutFile();
      emit(DeleteAllWithoutFileState());
      add(GetAllAudioEvent());
    });
  }
}