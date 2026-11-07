import 'model_event.dart';

/// Interface for objects that observe and respond to state changes within a [Model].
///
/// Implements the Observer pattern, decoupling model state updates from GUI views.
abstract interface class ModelListener {
  /// Invoked when an observed model modifies its state and calls `notifyChanged()`.
  ///
  /// [event] contains details and optional data payloads describing the state change.
  void modelChanged(ModelEvent event);
}
