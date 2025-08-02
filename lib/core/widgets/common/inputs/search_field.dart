import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_text_field.dart';

/// A search field with a search icon and clear button
class SearchField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final bool enabled;
  final Color? fillColor;
  final bool filled;
  final EdgeInsetsGeometry? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final Duration debounceDuration;
  final ValueChanged<String>? onDebounced;

  const SearchField({
    Key? key,
    this.controller,
    this.hintText = 'Search...',
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.autoFocus = false,
    this.enabled = true,
    this.fillColor,
    this.filled = true,
    this.contentPadding,
    this.inputFormatters,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.onDebounced,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    // Only dispose the controller if we created it
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value) {
    // Call the immediate onChanged callback if provided
    widget.onChanged?.call(value);

    // Handle debouncing
    if (widget.onDebounced != null) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(widget.debounceDuration, () {
        widget.onDebounced!(value);
      });
    }
  }

  void _onClear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onDebounced?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppTextField(
      controller: _controller,
      hintText: widget.hintText,
      onChanged: _onChanged,
      onSubmitted: widget.onSubmitted,
      keyboardType: TextInputType.text,
      textInputAction: widget.textInputAction ?? TextInputAction.search,
      autoFocus: widget.autoFocus,
      enabled: widget.enabled,
      fillColor: widget.fillColor,
      filled: widget.filled,
      contentPadding: widget.contentPadding,
      inputFormatters: widget.inputFormatters,
      prefixIcon: const Icon(Icons.search, size: 24.0),
      suffixIcon: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _controller,
        builder: (context, value, child) {
          return value.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20.0),
                  onPressed: _onClear,
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
