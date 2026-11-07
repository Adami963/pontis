import 'model.dart';
import 'model_event.dart';
import 'model_listener.dart';

/// Abstract root class of the Model hierarchy, providing observer management.
///
/// Concrete business models (e.g., FlashcardModel, CurriculumModel) extend this class
/// and call [notifyChanged] whenever internal state updates occur.
abstract class AbstractModel implements Model {
  /// Collection of registered [ModelListener] observers.
  final List<ModelListener> _listeners = <ModelListener>[];

  @override
  void addModelListener(ModelListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  @override
  void removeModelListener(ModelListener listener) {
    _listeners.remove(listener);
  }

  @override
  void notifyChanged(ModelEvent event) {
    // Clone list during iteration to prevent concurrent modification if a listener unregisters
    final List<ModelListener> targets = List<ModelListener>.of(_listeners);
    for (final ModelListener listener in targets) {
      listener.modelChanged(event);
    }
  }
}
