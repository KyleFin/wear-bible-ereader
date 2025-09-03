import 'package:flutter/material.dart';
import 'package:rotary_scrollbar/rotary_scrollbar.dart';

// TODO: Scroll bar is squished when Home icon is displayed (after double tap)
// TODO: Handle straight scroll bar for square watch faces? (None in WearOS 3?)
class RotaryScrollable extends StatefulWidget {
  const RotaryScrollable({required this.childBuilder, super.key});

  final Widget Function(ScrollController) childBuilder;

  @override
  State<RotaryScrollable> createState() => _RotaryScrollableState();
}

class _RotaryScrollableState extends State<RotaryScrollable> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotaryScrollbar(
      controller: scrollController,
      child: widget.childBuilder(scrollController),
    );
  }
}
