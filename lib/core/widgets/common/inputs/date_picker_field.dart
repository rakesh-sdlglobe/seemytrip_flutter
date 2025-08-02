import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A form field that shows a date picker when tapped
class DatePickerField extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? labelText;
  final String? hintText;
  final String? Function(DateTime?)? validator;
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final bool filled;
  final Widget? prefixIcon;
  final DateFormat? dateFormat;
  final String? initialValue;
  final TextEditingController? controller;

  DatePickerField({
    Key? key,
    this.initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    required this.onDateSelected,
    this.labelText = 'Select Date',
    this.hintText = 'Tap to select a date',
    this.validator,
    this.enabled = true,
    this.contentPadding,
    this.fillColor,
    this.filled = true,
    this.prefixIcon,
    this.dateFormat,
    this.initialValue,
    this.controller,
  })  : firstDate = firstDate ?? DateTime(1900),
        lastDate = lastDate ?? DateTime(2100),
        super(key: key);

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late final TextEditingController _controller;
  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    
    // Set initial date
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate;
      _controller.text = _dateFormat.format(widget.initialDate!);
    } else if (widget.initialValue != null) {
      try {
        _selectedDate = _dateFormat.parse(widget.initialValue!);
        _controller.text = widget.initialValue!;
      } catch (e) {
        debugPrint('Error parsing initial date: $e');
      }
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!widget.enabled) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: widget.firstDate!,
      lastDate: widget.lastDate!,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Theme.of(context).cardColor,
              onSurface: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87,
            ),
            dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = _dateFormat.format(picked);
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextFormField(
      controller: _controller,
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        filled: widget.filled,
        fillColor: widget.fillColor ?? theme.cardColor,
        contentPadding: widget.contentPadding ?? const EdgeInsets.all(16.0),
        border: _buildBorder(theme),
        enabledBorder: _buildBorder(theme),
        focusedBorder: _buildBorder(theme, color: theme.primaryColor),
        disabledBorder: _buildBorder(theme, color: theme.disabledColor),
        prefixIcon: widget.prefixIcon ?? const Icon(Icons.calendar_today, size: 20.0),
        suffixIcon: _selectedDate != null
            ? IconButton(
                icon: const Icon(Icons.clear, size: 20.0),
                onPressed: widget.enabled
                    ? () {
                        setState(() {
                          _selectedDate = null;
                          _controller.clear();
                        });
                        widget.onDateSelected(DateTime(0));
                      }
                    : null,
              )
            : null,
      ),
      validator: (value) {
        if (widget.validator != null) {
          return widget.validator!(_selectedDate);
        }
        return null;
      },
      enabled: widget.enabled,
    );
  }

  InputBorder _buildBorder(ThemeData theme, {Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(
        color: color ?? theme.dividerColor,
        width: 1.0,
      ),
    );
  }
}
