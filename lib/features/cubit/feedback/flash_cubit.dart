import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

enum FlashType { success, error, info }

class FlashState {
  final String message;
  final FlashType type;
  final bool visible;
  final int count;

  const FlashState({
    this.message = '',
    this.type = FlashType.info,
    this.visible = false,
    this.count = 1,
  });

  FlashState copyWith({
    String? message,
    FlashType? type,
    bool? visible,
    int? count,
  }) {
    return FlashState(
      message: message ?? this.message,
      type: type ?? this.type,
      visible: visible ?? this.visible,
      count: count ?? this.count,
    );
  }
}

class FlashCubit extends Cubit<FlashState> {
  FlashCubit() : super(const FlashState());

  Timer? _hideTimer;

  void show(FlashType type, String message, {int durationMs = 3500}) {
    _hideTimer?.cancel();

    final isSame = state.type == type &&
                   state.message == message &&
                   state.visible;

    emit(state.copyWith(
      message: message,
      type: type,
      visible: true,
      count: isSame ? state.count + 1 : 1,
    ));

    // ✅ calls hide() not close()
    _hideTimer = Timer(Duration(milliseconds: durationMs), hide);
  }

  void success(String message) => show(FlashType.success, message);
  void error(String message)   => show(FlashType.error, message);
  void info(String message)    => show(FlashType.info, message);

  // ✅ renamed from close() to hide() — close() is reserved by Cubit
  void hide() {
    _hideTimer?.cancel();
    emit(state.copyWith(visible: false));
  }

  @override
  Future<void> close() async {
    _hideTimer?.cancel(); // ✅ just cancel timer, then let Cubit close normally
    return super.close();
  }
}