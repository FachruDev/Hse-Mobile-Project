import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unauthorized_signal.g.dart';

@Riverpod(keepAlive: true)
class UnauthorizedSignal extends _$UnauthorizedSignal {
  @override
  int build() => 0;

  void publish() => state = state + 1;
}
