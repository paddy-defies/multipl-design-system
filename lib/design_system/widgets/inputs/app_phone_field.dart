import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Country code model.
class CountryCode {
  const CountryCode({
    required this.flag,
    required this.dialCode,
    required this.name,
  });

  final String flag;
  final String dialCode;
  final String name;
}

/// Default list of common country codes.
const List<CountryCode> _kDefaultCountries = [
  CountryCode(flag: '🇮🇳', dialCode: '+91', name: 'India'),
  CountryCode(flag: '🇺🇸', dialCode: '+1', name: 'United States'),
  CountryCode(flag: '🇬🇧', dialCode: '+44', name: 'United Kingdom'),
  CountryCode(flag: '🇦🇪', dialCode: '+971', name: 'UAE'),
  CountryCode(flag: '🇸🇬', dialCode: '+65', name: 'Singapore'),
  CountryCode(flag: '🇦🇺', dialCode: '+61', name: 'Australia'),
  CountryCode(flag: '🇨🇦', dialCode: '+1', name: 'Canada'),
  CountryCode(flag: '🇩🇪', dialCode: '+49', name: 'Germany'),
];

/// Multipl Design System v5.0 — Phone number input with country selector.
///
/// ```dart
/// AppPhoneField(
///   label: 'Phone number',
///   onChanged: (code, number) => print('$code $number'),
/// )
/// ```
class AppPhoneField extends StatefulWidget {
  const AppPhoneField({
    super.key,
    this.label = 'Phone number',
    this.placeholder = 'Enter phone number',
    this.initialCountry = const CountryCode(flag: '🇮🇳', dialCode: '+91', name: 'India'),
    this.countries = _kDefaultCountries,
    this.onChanged,
  });

  final String label;
  final String placeholder;
  final CountryCode initialCountry;
  final List<CountryCode> countries;
  final void Function(CountryCode country, String number)? onChanged;

  @override
  State<AppPhoneField> createState() => _AppPhoneFieldState();
}

class _AppPhoneFieldState extends State<AppPhoneField> {
  late CountryCode _selected;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = widget.initialCountry;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showPicker() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _CountryPicker(
        countries: widget.countries,
        selected: _selected,
        onSelect: (c) {
          setState(() => _selected = c);
          widget.onChanged?.call(c, _controller.text);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.label, style: AppTextStyles.labelLarge),
        const SizedBox(height: AppSpacing.s8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgWhite,
            border: Border.all(color: AppColors.formBorderNormal),
            borderRadius: AppRadius.input,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: _showPicker,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s12,
                    vertical: AppSpacing.s14,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_selected.flag, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: AppSpacing.s6),
                      Text(
                        _selected.dialCode,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s4),
                      const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.txMid),
                    ],
                  ),
                ),
              ),
              Container(width: 1, height: 28, color: AppColors.formBorderNormal),
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: AppTextStyles.bodyLarge,
                  onChanged: (v) => widget.onChanged?.call(_selected, v),
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.txLight),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s12,
                      vertical: AppSpacing.s14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CountryPicker extends StatefulWidget {
  const _CountryPicker({
    required this.countries,
    required this.selected,
    required this.onSelect,
  });

  final List<CountryCode> countries;
  final CountryCode selected;
  final ValueChanged<CountryCode> onSelect;

  @override
  State<_CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<_CountryPicker> {
  late List<CountryCode> _filtered;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = widget.countries;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _filter(String q) {
    setState(() {
      _filtered = q.isEmpty
          ? widget.countries
          : widget.countries
              .where((c) =>
                  c.name.toLowerCase().contains(q.toLowerCase()) ||
                  c.dialCode.contains(q))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s24,
      ),
      child: Column(
        children: [
          Text('Select Country', style: AppTextStyles.h4),
          const SizedBox(height: AppSpacing.s12),
          TextField(
            controller: _search,
            onChanged: _filter,
            decoration: InputDecoration(
              hintText: 'Search country…',
              prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.txMid),
              filled: true,
              fillColor: AppColors.neutral100,
              border: OutlineInputBorder(
                borderRadius: AppRadius.input,
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final c = _filtered[i];
                final isSelected = c.dialCode == widget.selected.dialCode &&
                    c.name == widget.selected.name;
                return ListTile(
                  leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
                  title: Text(c.name, style: AppTextStyles.bodyLarge),
                  trailing: Text(
                    c.dialCode,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.txMid,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.brandYellow,
                  onTap: () => widget.onSelect(c),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
