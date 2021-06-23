import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef panStart = void Function(DragStartDetails details);
typedef panUpdate = void Function(DragUpdateDetails details);
typedef panEnd = void Function(List<int> list, Offset details);
typedef MultiSelectWidgetBuilder = Widget Function(
    BuildContext context, int index, bool selected);

class MultiSelectGridView extends StatefulWidget {
  const MultiSelectGridView({
    Key key,
    this.padding = const EdgeInsets.only(left: 40.0, right: 40.0, top: 40.0),
    @required this.itemCount,
    @required this.itemBuilder,
    @required this.gridDelegate,
    @required this.onPanEnd,
    @required this.onPanUpdate,
    @required this.onPanStart,
  }) : super(key: key);

  final panUpdate onPanUpdate;
  final panStart onPanStart;
  final panEnd onPanEnd;
  final EdgeInsetsGeometry padding;
  final int itemCount;
  final MultiSelectWidgetBuilder itemBuilder;
  final SliverGridDelegate gridDelegate;

  @override
  _MultiSelectGridViewState createState() => _MultiSelectGridViewState();
}

class _MultiSelectGridViewState extends State<MultiSelectGridView> {
  // ignore: deprecated_member_use
  final _elements = List<_MultiSelectChildElement>();

  bool _isSelecting = false;
  int _startIndex = -1;
  int _endIndex = -1;
  var selected = false;
  int mem = -1;
  List<int> selectedItems = [];

  Offset endDetails;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.itemCount,
        itemBuilder: (BuildContext context, int index) {
          selected = selectedItems.contains(index) &&
                  (_startIndex != -1 && _endIndex != -1)
              ? true
              : false;

          return _MultiSelectChild(
            index: index,
            child: widget.itemBuilder(context, index, selected),
          );
        },
        gridDelegate: widget.gridDelegate,
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    final startIndex = _findMultiSelectChildFromOffset(details.localPosition);
    _setSelection(startIndex, startIndex);
    widget.onPanStart(details);
    setState(() => _isSelecting = (startIndex != -1));
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isSelecting) {
      _findMultiSelectChildFromOffset(details.localPosition);
      endDetails = details.globalPosition;
      widget.onPanUpdate(details);
      setState(() {});
    }
  }

  void _onPanEnd(DragEndDetails details) {
    widget.onPanEnd(selectedItems, endDetails);
    selectedItems = [];
    mem = -1;
    setState(() => _isSelecting = false);
  }

  void _setSelection(int start, int end) {
    _startIndex = start;
    _endIndex = end;
  }

  int _findMultiSelectChildFromOffset(Offset offset) {
    final ancestor = context.findRenderObject();
    for (_MultiSelectChildElement element in List.from(_elements)) {
      if (element.containsOffset(ancestor, offset) &&
          mem != element.widget.index) {
        if (selectedItems.contains(element.widget.index)) {
          while (selectedItems[selectedItems.length - 1] !=
              element.widget.index) selectedItems.removeLast();
        } else
          selectedItems.add(element.widget.index);

        mem = element.widget.index;
        AssetsAudioPlayer.playAndForget(Audio(
          "assets/sounds/slime.mp3",
        ));
        print(element.widget.index);
        return element.widget.index;
      }
    }
    return -1;
  }
}

class _MultiSelectChild extends ProxyWidget {
  const _MultiSelectChild({
    Key key,
    @required this.index,
    @required Widget child,
  }) : super(key: key, child: child);

  final int index;

  @override
  _MultiSelectChildElement createElement() => _MultiSelectChildElement(this);
}

class _MultiSelectChildElement extends ProxyElement {
  _MultiSelectChildElement(_MultiSelectChild widget) : super(widget);

  @override
  _MultiSelectChild get widget => super.widget;

  _MultiSelectGridViewState _ancestorState;

  @override
  void mount(Element parent, newSlot) {
    super.mount(parent, newSlot);
    _ancestorState = findAncestorStateOfType<_MultiSelectGridViewState>();
    _ancestorState?._elements?.add(this);
  }

  @override
  void unmount() {
    super.unmount();
  }

// return true if the finger is on the object
  bool containsOffset(RenderObject ancestor, Offset offset) {
    final RenderBox box = renderObject;
    final rect = box.localToGlobal(Offset.zero, ancestor: ancestor) & box.size;
    return rect.contains(offset);
  }

  @override
  void notifyClients(covariant ProxyWidget oldWidget) {}
}
