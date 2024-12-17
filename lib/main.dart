import 'package:camera/camera.dart';
import 'package:camera_app/pages/audio_details_screen.dart';
import 'package:camera_app/pages/audio_screen.dart';
import 'package:camera_app/pages/photo_details_screen.dart';
import 'package:camera_app/pages/photo_screen.dart';
import 'package:camera_app/pages/take_photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'layouts/main_layout.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  String getTitle(BuildContext context) =>
      '${GoRouterState.of(context).uri.toString().substring(1)[0].toUpperCase()}${GoRouterState.of(context).uri.toString().substring(2)}';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: '/photos',
        routes: [
          ShellRoute(
            routes: [
              GoRoute(
                path: '/photos',
                name: '/photos',
                routes: [
                  GoRoute(
                    path: '/takePhoto',
                    builder: (context, state) {
                      Extra extra = state.extra as Extra;
                      return ColoredBox(
                        color: Theme.of(context).colorScheme.surface,
                        child: TakePhotoScreen(
                          initializeControllerFuture: extra.initialize,
                          controller: extra.controller,
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: '/:photoId',
                    builder: (context, state) => PhotoDetailsScreen(
                      id: int.tryParse(state.pathParameters['photoId'] ?? '') ??
                          0,
                    ),
                  ),
                ],
                builder: (context, state) => ColoredBox(
                  color: Theme.of(context).colorScheme.surface,
                  child: const Center(
                    child: PhotoScreen(),
                  ),
                ),
              ),
              GoRoute(
                path: '/audio',
                routes: [
                  GoRoute(
                    path: '/takeAudio',
                    builder: (context, state) => ColoredBox(
                      color: Theme.of(context).colorScheme.surface,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Press the record button to start recording...',
                            style: TextStyle(
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GoRoute(
                    path: '/:audioId',
                    builder: (context, state) => AudioDetailsScreen(
                      id: int.tryParse(state.pathParameters['audioId'] ?? '') ??
                          0,
                    ),
                  ),
                ],
                builder: (context, state) => ColoredBox(
                  color: Theme.of(context).colorScheme.surface,
                  child: const AudioScreen(),
                ),
              ),
            ],
            builder: (context, state, child) => MainLayout(
              title: getTitle(context),
              cameras: _cameras,
              child: child,
            ),
          ),
        ],
      ),
      title: 'Flutter Demo',
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        }),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

class Extra {
  final Future<void> initialize;
  final CameraController controller;

  Extra({
    required this.initialize,
    required this.controller,
  });
}
