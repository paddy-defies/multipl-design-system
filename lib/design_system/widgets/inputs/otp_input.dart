import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// OTP box visual state.
enum _OtpBoxState { empty, active, complete }

/// Multipl Design System v5.0 — 6-box OTP input.
///
/// Boxes auto-advance on digit entry.
/// - Empty: neutral border
/// - Active: gold border
/// - Complete: teal border
///
/// ```dart
/// OtpInput(
///   length: 6,
///   onCompleted: (code) => _verify(code),
/// )
/// ```
class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
    this.autoFocus = true,
  });

  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool autoFocus;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    for (var node in _focusNodes) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get _currentValue =>
      _controllers.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      // Handle paste: distribute across boxes
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
      for (int i = 0; i < widget.length && i < digits.length; i++) {
        _controllers[i].text = digits[i];
      }
      final nextEmpty = _controllers.indexWhere((c) => c.text.isEmpty);
      final focusIndex = nextEmpty == -1 ? widget.length - 1 : nextEmpty;
      _focusNodes[focusIndex].requestFocus();
      setState(() {});
    } else if (value.isNotEmpty) {
      _controllers[index].text = value;
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
      setState(() {});
    }

    final current = _currentValue;
    widget.onChanged?.call(current);
    if (current.length == widget.length) {
      widget.onCompleted?.call(current);
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      setState(() {});
    }
  }

  _OtpBoxState _stateFor(int index) {
    if (_controllers[index].text.isNotEmpty) return _OtpBoxState.complete;
    if (_focusNodes[index].hasFocus) return _OtpBoxState.active;
    return _OtpBoxState.empty;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (i) {
        return _OtpBox(
          controller: _controllers[i],
          focusNode: _focusNodes[i],
          boxState: _stateFor(i),
          autofocus: widget.autoFocus && i == 0,
          onChanged: (v) => _onChanged(i, v),
          onKeyEvent: (e) => _onKeyEvent(i, e),
        );
      }),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.boxState,
    required this.onChanged,
    required this.onKeyEvent,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final _OtpBoxState boxState;
  final ValueChanged<String> onChanged;
  final ValueChanged<KeyEvent> onKeyEvent;
  final bool autofocus;

  Color get _borderColor {
    switch (boxState) {
      case _OtpBoxState.active:
        return AppColors.gold;
      case _OtpBoxState.complete:
        return AppColors.teal;
      case _OtpBoxState.empty:
        return AppColors.formBorderNormal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: onKeyEvent,
      child: SizedBox(
        width: 50,
        height: 60,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: AppColors.formBg,
            border: Border.all(color: _borderColor, width: 1.5),
            borderRadius: AppRadius.mAll,
          ),
          child: Center(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: autofocus,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1),
              ],
              style: AppTextStyles.h4.copyWith(color: AppColors.txDark),
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
