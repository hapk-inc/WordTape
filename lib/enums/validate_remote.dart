import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'validate_remote.g.dart';

enum ValidateRemote { yes, no, failed }

@Riverpod(keepAlive: true)
class RemoteNotifier extends _$RemoteNotifier {
  @override
  ValidateRemote build() => ValidateRemote.no;
}
