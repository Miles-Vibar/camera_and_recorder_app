import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app/bloc.dart';
import '../bloc/app/state.dart';

class TakePhotoScreen extends StatelessWidget {
  const TakePhotoScreen({
    super.key,
    required this.initializeControllerFuture,
    required this.controller,
  });

  final Future<void> initializeControllerFuture;
  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {},
      child: Scaffold(
        body: FutureBuilder(
          future: initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(controller);
            } else {
              return ColoredBox(
                color: Theme.of(context).colorScheme.surface,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}