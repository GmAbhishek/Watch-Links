import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const MethodChannel _channel = MethodChannel('wear');

class Wear {
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

/// Shape of a Wear device
enum Shape { square, round }

/// Ambient modes for a Wear device
enum Mode { active, ambient }

/// An inherited widget that holds the shape of the Watch
class InheritedShape extends InheritedWidget {
  const InheritedShape({
    super.key,
    required this.shape,
    required super.child,
  });

  final Shape shape;

  static InheritedShape of(BuildContext context) {
    final InheritedShape? result =
    context.dependOnInheritedWidgetOfExactType<InheritedShape>();
    assert(result != null, 'No InheritedShape found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(InheritedShape old) => shape != old.shape;
}

/// Builds a child for a WatchShapeBuilder
typedef WatchShapeBuilder = Widget Function(
    BuildContext context,
    Shape shape,
    );

/// Builder widget for watch shapes
class WatchShape extends StatefulWidget {
  const WatchShape({super.key, required this.builder});

  final WatchShapeBuilder builder;

  @override
  State<WatchShape> createState() => _WatchShapeState();
}

class _WatchShapeState extends State<WatchShape> {
  Shape shape = Shape.round;

  @override
  void initState() {
    super.initState();
    _setShape();
  }

  /// Sets the watch face shape
  Future<void> _setShape() async {
    shape = await _getShape();
    setState(() {});
  }

  /// Fetches the shape of the watch face
  Future<Shape> _getShape() async {
    try {
      final int result = await _channel.invokeMethod<int>('getShape') ?? 0;
      return result == 1 ? Shape.square : Shape.round;
    } on PlatformException catch (e) {
      // Default to round
      debugPrint('Error detecting shape: $e');
      return Shape.round;
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, shape);
}

/// Builds a child for AmbientModeBuilder
typedef AmbientModeWidgetBuilder = Widget Function(
    BuildContext context,
    Mode mode,
    );

/// Widget that listens for when a Wear device enters full power or ambient mode,
/// and provides this in a builder. It optionally takes an update function that's
/// called every time the watch triggers an ambient update request. If an update
/// function is passed in, this widget will not perform an update itself.
class AmbientMode extends StatefulWidget {
  const AmbientMode({super.key, required this.builder, this.update});

  final AmbientModeWidgetBuilder builder;
  final VoidCallback? update;

  @override
  State<AmbientMode> createState() => _AmbientModeState();
}

class _AmbientModeState extends State<AmbientMode> {
  Mode ambientMode = Mode.active;

  @override
  void initState() {
    super.initState();

    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'enter':
          setState(() => ambientMode = Mode.ambient);
          break;
        case 'update':
          if (widget.update != null) {
            widget.update!();
          } else {
            setState(() => ambientMode = Mode.ambient);
          }
          break;
        case 'exit':
          setState(() => ambientMode = Mode.active);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, ambientMode);
}
