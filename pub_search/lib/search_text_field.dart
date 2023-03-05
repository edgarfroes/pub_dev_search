import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({
    super.key,
    this.controller,
    this.focusNode,
    required this.onChanged,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function(String) onChanged;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  void initState() {
    super.initState();

    _startSearchController = SimpleAnimation(
      'start_search',
      autoplay: false,
    );

    _finishSearchController = SimpleAnimation(
      'finish_search',
      autoplay: false,
    );

    Future<void> sleepBeforeResizing() async {
      await Future.delayed(const Duration(milliseconds: 400));
    }

    _focusNode.addListener(() async {
      if (_controller.text.isNotEmpty) {
        return;
      }

      if (_focusNode.hasFocus) {
        _finishSearchController.reset();
        _finishSearchController.apply(_artboard as RuntimeArtboard, 0);
        _finishSearchController.isActive = false;

        _startSearchController.isActive = true;

        await sleepBeforeResizing();

        setState(() {
          _expanded = _focusNode.hasFocus || _controller.text.isNotEmpty;
          _showSearchIcon = false;
          _cursorColor = null;
        });

        return;
      }

      _startSearchController.reset();
      _startSearchController.apply(_artboard as RuntimeArtboard, 0);
      _startSearchController.isActive = false;

      setState(() {
        _showSearchIcon = true;
        _cursorColor = Colors.transparent;
      });

      _finishSearchController.isActive = true;

      await sleepBeforeResizing();

      setState(() {
        _expanded = false;
      });
    });
  }

  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final SimpleAnimation _startSearchController;
  late final SimpleAnimation _finishSearchController;
  late final Artboard _artboard;
  Color? _cursorColor;
  bool _expanded = false;
  bool _showSearchIcon = true;

  static const closedWidth = 55.0;
  static const expandedWidth = 237.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: _expanded ? expandedWidth : closedWidth,
      height: closedWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(closedWidth),
        border: Border.all(
          color: theme.primaryColor,
          width: 2,
        ),
      ),
      child: Stack(
        fit: StackFit.loose,
        alignment: _expanded
            ? AlignmentDirectional.centerStart
            : AlignmentDirectional.center,
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            cursorColor: _cursorColor,
            cursorWidth: 2.3,
            cursorHeight: 17.3,
            onChanged: widget.onChanged,
            maxLines: _expanded ? null : 1,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 23.1,
              ),
            ),
          ),
          Positioned(
            left: 14,
            child: GestureDetector(
              onTap: _focusNode.requestFocus,
              child: SizedBox(
                width: 20,
                height: 20,
                child: AnimatedOpacity(
                  duration: Duration.zero,
                  opacity: _showSearchIcon ? 1 : 0,
                  child: RiveAnimation.asset(
                    'assets/search_to_cursor_animation.riv',
                    controllers: [
                      _startSearchController,
                      _finishSearchController,
                    ],
                    onInit: (Artboard artboard) {
                      _artboard = artboard;
                    },
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
