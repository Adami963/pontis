import 'model.dart';
import 'view.dart';

/// Contract for all classes fulfilling the Controller role in MVC.
abstract interface class Controller {
  /// Attaches the managed [Model] instance.
  void setModel(Model model);

  /// Retrieves the managed [Model] instance.
  Model getModel();

  /// Attaches the managed [View] instance.
  void setView(View view);

  /// Retrieves the managed [View] instance.
  View getView();

  /// Dispatches an action command triggered by user interaction in the view.
  void operation(String option);
}
