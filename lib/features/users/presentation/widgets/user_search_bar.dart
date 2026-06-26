import 'package:flutter/material.dart';
import '../../../../core/common/common.dart';
import '../../../../core/utils/utils.dart';

// user search
class UserSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  // user search bar constructor
  const UserSearchBar({
    super.key,
    required this.onChanged,
    this.hintText = 'Search users by name, username, or email...',
  });

  @override
  State<UserSearchBar> createState() => _UserSearchBarState();
}

class _UserSearchBarState extends State<UserSearchBar> {
  final _controller = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 300);
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _isFocused
              ? context.colorScheme.surface
              : context.colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
          border: Border.all(
            color: _isFocused
                ? context.colorScheme.primary
                : context.colorScheme.outlineVariant.withValues(alpha: 0.7),
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: _isFocused
                  ? context.colorScheme.primary
                  : context.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged('');
                      setState(() {});
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onChanged: (value) {
            setState(() {});
            _debouncer.run(() => widget.onChanged(value));
          },
        ),
      ),
    );
  }
}
