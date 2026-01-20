import 'dart:async';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final String hintText;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final Function(String)? onSearch;
  final Duration debounceDuration;

  const SearchWidget({
    super.key,
    this.hintText = '어떤 생활인지요? (예. 꽃말)',
    this.onTap,
    this.controller,
    this.onSearch,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  Timer? _debounce;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      if (_controller.text.isNotEmpty && widget.onSearch != null) {
        widget.onSearch!(_controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome_outlined,
            color: const Color(0xFF7C4DFF),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: const Color(0xFF9E9E9E),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF212121),
              ),
              onTap: widget.onTap,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                _debounce?.cancel();
                if (widget.onSearch != null) widget.onSearch!(value);
              },
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: const Color(0xFF7C4DFF),
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                _debounce?.cancel();
                if (widget.onSearch != null) {
                  widget.onSearch!(_controller.text);
                }
              },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF7C4DFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '찾기',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
            ),
          ),
        ],
      ),
    );
  }
}
