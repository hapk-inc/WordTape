import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'enum.g.dart';

enum ScreenSize { mobile, tab, pc }

enum ValidateAuth { renovation, notLogged, guest, loggedIn, inGame }

enum NeedToDo { plain, find }

enum AppEnv { dev, prod }

enum RiddleState { launch, resume, completed }

@Riverpod(keepAlive: true, dependencies: [])
ScreenSize size(SizeRef ref) => ScreenSize.mobile;

@Riverpod(keepAlive: true, dependencies: [])
AppEnv appEnv(AppEnvRef ref) => kDebugMode ? AppEnv.dev : AppEnv.prod;
