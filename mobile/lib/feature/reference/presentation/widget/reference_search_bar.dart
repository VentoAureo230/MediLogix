import 'dart:async';

import 'package:flutter/material.dart';

/// Text field wired for a debounced search: [onChanged] fires only after
/// [debounce] of inactivity, keeping the API from being hammered per keystroke.
class ReferenceSearchBar extends StatefulWidget {
  const ReferenceSearchBar({
    super.key,
    required this.onChanged,
    this.debounce = const Duration(milliseconds: 400),
    this.initialValue,
  });

  final ValueChanged<String> onChanged;
  final Duration debounce;
  final String? initialValue;

  @override
  State<ReferenceSearchBar> createState() => _ReferenceSearchBarState();
}

class _ReferenceSearchBarState extends State<ReferenceSearchBar> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onTyped(String value) {
    _timer?.cancel();
    _timer = Timer(widget.debounce, () => widget.onChanged(value));
    setState(() {}); // Rebuild for the clear-button visibility.
  }

  void _clear() {
    _timer?.cancel();
    _controller.clear();
    widget.onChanged('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        onChanged: _onTyped,
        decoration: InputDecoration(
          hintText: 'Rechercher (nom ou CIP13)',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clear,
                ),
          isDense: true,
        ),
      ),
    );
  }
}
