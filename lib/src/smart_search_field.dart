import 'package:flutter/material.dart';
import 'package:flutter_smart_search/src/smart_search_controller.dart';
import 'package:flutter_smart_search/extension/visibility_extension.dart';
import 'package:flutter_smart_search/widget/no_data_view.dart';

class SmartSearchField<T> extends StatefulWidget {
  final Future<List<T>> Function(String query) fetchSuggestions;
  final void Function(T selected) onSelect;
  final String Function(T item) displayStringForOption;

  /// Optional text mappers
  final String Function(T item)? subtitleBuilder;
  final String Function(T item)? secondaryTextBuilder;

  /// Controls
  final FocusNode? focusNode;
  final TextEditingController? controller;

  /// UI
  final String hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final InputDecoration? decoration;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final BorderRadius? borderRadius;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final EdgeInsetsGeometry? contentPadding;

  /// Behavior
  final VoidCallback? onClear;
  final VoidCallback? onTap;
  final bool showFieldLoader;
  final double? maxHeight;
  final Duration? debounceDelay;

  /// Suggestions UI
  final Widget Function(T item, int index)? itemBuilder;
  final bool isSort;
  final bool isFilter;
  final Widget Function(BuildContext, int)? separatorBuilder;

  /// "No data" handling
  final Widget? noDataWidget;
  final String? noDataContent;
  final String? buttonText;
  final Color? buttonTextColor;
  final Color? containerColor;
  final Color? imageColor;
  final double? imageSize;
  final String? imageString;
  final double? textSize;

  final double topPadding;

  /// Controller for external actions
  final SmartSearchController? searchController;

  const SmartSearchField({
    super.key,
    required this.fetchSuggestions,
    required this.onSelect,
    required this.displayStringForOption,
    required this.hintText,
    this.controller,
    this.focusNode,
    this.onClear,
    this.onTap,
    this.showFieldLoader = false,
    this.maxHeight,
    this.searchController,
    this.noDataWidget,
    this.displayTextStyle,
    this.borderColor = const Color(0xFFBDBDBD),
    this.buttonTextColor,
    this.buttonText,
    this.textSize,
    this.containerColor,
    this.imageColor,
    this.noDataContent,
    this.imageSize,
    this.imageString,
    this.isSort = false,
    this.isFilter = false,
    this.topPadding = 8.0,
    this.debounceDelay,
    this.itemBuilder,
    this.style,
    this.borderRadius,
    this.decoration,
    this.hintStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.border,
    this.contentPadding,
    this.enabledBorder,
    this.focusedBorder,
    this.subtitleBuilder,
    this.secondaryTextBuilder,
    this.separatorBuilder,
  });

  final Color borderColor;
  final TextStyle? displayTextStyle;

  @override
  State<SmartSearchField<T>> createState() => _SmartSearchFieldState<T>();
}

class _SmartSearchFieldState<T> extends State<SmartSearchField<T>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  List<T> _suggestions = [];
  bool _isLoading = false;
  String _lastQuery = "";

  bool get _ownsController => widget.controller == null;
  bool get _ownsFocusNode => widget.focusNode == null;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    widget.searchController?.attach(_onClear);
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  Future<void> _onChanged(String value) async {
    _lastQuery = value;

    if (value.isEmpty) {
      setState(() => _suggestions = []);
      _focusNode.unfocus();
      return;
    }

    setState(() => _isLoading = true);

    if (widget.debounceDelay != null) {
      await Future.delayed(widget.debounceDelay!);
      if (_lastQuery != value) return; // ignore stale
    }

    try {
      var results = await widget.fetchSuggestions(value);

      if (widget.isFilter) {
        results = results
            .where((e) => widget.displayStringForOption(e)
            .toLowerCase()
            .contains(value.toLowerCase()))
            .toList();
      }

      if (widget.isSort) {
        results.sort((a, b) =>
            widget.displayStringForOption(a).compareTo(widget.displayStringForOption(b)));
      }

      if (mounted) {
        setState(() {
          _suggestions = results;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSelect(T selected) {
    _controller.text = widget.displayStringForOption(selected);
    widget.onSelect(selected);
    setState(() => _suggestions = []);
    _focusNode.unfocus();
  }

  void _onClear() {
    _controller.clear();
    setState(() => _suggestions = []);
    widget.onClear?.call();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextField(
        controller: _controller,
        style: widget.style ?? const TextStyle(fontSize: 14),
        focusNode: _focusNode,
        onChanged: _onChanged,
        decoration: widget.decoration ??
            InputDecoration(
              hintText: widget.hintText,
              hintStyle: widget.hintStyle ??
                  const TextStyle(fontSize: 12, color: Color(0xFFBDBDBD)),
              suffixIcon: _isLoading
                  ? const Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ).onVisibleKeepSpace(widget.showFieldLoader)
                  : InkWell(onTap: _onClear,
                    child: widget.suffixIcon ??
                    InkWell(
                      onTap: _onClear,
                      child: const Icon(Icons.clear, color: Colors.red),
                    ).onVisibleKeepSpace(_controller.text.isNotEmpty),
                  ),
              prefixIcon: widget.prefixIcon,
              border: widget.border ?? const OutlineInputBorder(),
              contentPadding: widget.contentPadding ?? EdgeInsets.only(left:15),
              enabledBorder: widget.enabledBorder ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: widget.borderColor, width: 1),
                  ),
              focusedBorder: widget.focusedBorder ??
                  OutlineInputBorder(
                    borderRadius: widget.borderRadius ?? BorderRadius.circular(6),
                    borderSide: BorderSide(color: widget.borderColor, width: 1),
                  ),
            ),
      ),
      if (_focusNode.hasFocus)
        Padding(
          padding: EdgeInsets.only(top: widget.topPadding),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: _isLoading
                ? const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
                : _suggestions.isEmpty
                ? NoDataView(
              onTap: widget.onTap,
              noDataWidget: widget.noDataWidget,
              buttonTextColor: widget.buttonTextColor,
              buttonText: widget.buttonText,
              containerColor: widget.containerColor,
              imageColor: widget.imageColor,
              imageSize: widget.imageSize,
              imageString: widget.imageString,
              noDataContent: widget.noDataContent,
              textSize: widget.textSize,
            ).onVisibleKeepSpace(_controller.text.trim().isNotEmpty)
                : ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: widget.maxHeight ??
                    MediaQuery.of(context).size.height * 0.4,
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final item = _suggestions[index];
                  if (widget.itemBuilder != null) {
                    return InkWell(onTap:()=>_onSelect(item), child: widget.itemBuilder!(item,index));
                  }
                  return InkWell(onTap:()=>_onSelect(item),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Padding(
                            padding: const EdgeInsets.only(
                                top: 6, left: 10, right: 8),
                            child: Text(
                              widget.displayStringForOption(item),
                              style: widget.displayTextStyle,
                            ),
                          ),
                        const Divider(),
                      ],
                    ),
                  );
                },
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                separatorBuilder: (context, index) =>
                widget.separatorBuilder?.call(context, index) ??
                    const Divider()
              ),
            ),
          ),
        ),
    ]);
  }
}
