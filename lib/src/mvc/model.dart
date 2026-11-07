import 'model_event.dart';
import 'model_listener.dart';

/// Root contract for all classes acting as the Model role in the MVC framework.
///
/// Defines the observer registration and notification interface.
abstract interface class Model {
  /// Registers a [ModelListener] to receive notifications when state transitions occur.
  void addModelListener(ModelListener listener);

  /// Unregisters an existing [ModelListener].
  void removeModelListener(ModelListener listener);

  /// Notifies all registered listeners of a model change.
  void notifyChanged(ModelEvent event);
}
