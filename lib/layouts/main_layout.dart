import 'package:camera/camera.dart';
import 'package:camera_app/widgets/delete_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as path;

import '../bloc/app/bloc.dart';
import '../bloc/app/events.dart';
import '../bloc/app/state.dart';
import '../data/models/entry.dart';
import '../main.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({
    super.key,
    required this.child,
    required this.title,
    required this.cameras,
    // required this.camera,
  });

  final Widget child;
  final String title;
  final List<CameraDescription> cameras;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int index = 0;
  String name = '';
  bool inPhotos = true;

  late Future<void> _initializeControllerFuture;
  final AudioRecorder audioRecorder = AudioRecorder();
  late CameraController _controller;

  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setIndex(int value) {
    setState(() {
      index = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc()..add(GetAllPhotosEvent()),
      child: BlocConsumer<AppBloc, AppState>(
        listener: (BuildContext context, Object? state) {
          if (state is GotAllAudio || state is GotAllPhotos) {
            setState(() {
              inPhotos = state is GotAllPhotos;
            });
          }
        },
        builder: (BuildContext context, state) => Scaffold(
          appBar: AppBar(
            leading:
                (state is GotAllAudio || state is Idle || state is GotAllPhotos)
                    ? null
                    : IconButton(
                        onPressed: () {
                          context.pop();
                          context.read<AppBloc>().add(ChangePageEvent());
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
            title: Text(widget.title),
            actions: [
              IconButton(onPressed: () async {
                var result = await showDialog(context: context, builder: (context) => const DeleteAlertDialog(isEntry: true));

                if (!result || !context.mounted) return;

                if (inPhotos) {
                  context.read<AppBloc>().add(DeleteAllWithoutPhotoEvent());
                } else {
                  context.read<AppBloc>().add(DeleteAllWithoutAudioEvent());
                }
              }, icon: const Icon(Icons.folder_delete))
            ],
          ),
          body: widget.child,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (state is CameraReadyState) {
                await _initializeControllerFuture;
                final image = await _controller.takePicture();
                if (!context.mounted) return;
                context.read<AppBloc>().add(
                      AddPhotoEvent(
                        entry: Entry(
                          name: image.name,
                          path: image.path,
                          isDeleted: false,
                        ),
                      ),
                    );
                context.pop();
              } else if (state is AudioReadyState) {
                if (isRecording) {
                  final filePath = await audioRecorder.stop();

                  if (!context.mounted) return;

                  context.read<AppBloc>().add(
                        AddAudioEvent(
                          entry: Entry(
                            name: name,
                            path: filePath ?? '',
                            isDeleted: filePath == null,
                          ),
                        ),
                      );
                  context.pop();
                } else {
                  if (await audioRecorder.hasPermission()) {
                    final directory = await getApplicationDocumentsDirectory();
                    name = '${DateTime.now().millisecondsSinceEpoch}.wav';
                    final filePath = path.join(directory.path, name);
                    await audioRecorder.start(const RecordConfig(),
                        path: filePath);
                    setState(() {
                      isRecording = true;
                    });
                  }
                }
              } else {
                if (widget.title.toLowerCase() == 'photos') {
                  context.go(
                    '/photos/takePhoto',
                    extra: Extra(
                      initialize: _initializeControllerFuture,
                      controller: _controller,
                    ),
                  );
                  context.read<AppBloc>().add(TakingPhotoEvent());
                } else {
                  context.go(
                    '/audio/takeAudio',
                  );
                  context.read<AppBloc>().add(TakingAudioEvent());
                }
              }
            },
            // context.read<AppBloc>().add(index == 0 ? AddPhotoEvent() : AddAudioEvent()),
            shape: const CircleBorder(),
            child: Icon(
              state is CameraReadyState
                  ? Icons.camera_alt
                  : state is AudioReadyState
                      ? !isRecording
                          ? Icons.mic
                          : Icons.stop
                      : Icons.add,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            onTap: (value) {
              setIndex(value);
              context.read<AppBloc>().add(ChangePageEvent());
              if (index == 0) {
                context.go('/photos');
              } else {
                context.go('/audio');
              }
              setState(() {
                isRecording = false;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.photo),
                label: 'Photos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.record_voice_over),
                label: 'Audio',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
