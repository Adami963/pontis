import 'controller.dart';
import 'model.dart';
import 'view.dart';

/// Abstract base implementation of [Controller] managing Model and View references.
abstract class AbstractController implements Controller {
  late Model _model;
  late View _view;

  @override
  void setModel(Model model) => _model = model;

  @override
  Model getModel() => _model;

  @override
  void setView(View view) => _view = view;

  @override
  View getView() => _view;

  @override
  void operation(String option);
}
