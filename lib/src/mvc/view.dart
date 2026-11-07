import 'controller.dart';
import 'model.dart';
import 'model_listener.dart';

/// Contract for presentation components fulfilling the View role in MVC.
///
/// Views implement [ModelListener] to receive push notifications when model state updates.
abstract interface class View implements ModelListener {
  /// Attaches the controlling [Controller] instance.
  void setController(Controller controller);

  /// Retrieves the attached [Controller] instance.
  Controller getController();

  /// Attaches the observed [Model] instance and registers this view as a listener.
  void setModel(Model model);

  /// Retrieves the observed [Model] instance.
  Model getModel();
}
