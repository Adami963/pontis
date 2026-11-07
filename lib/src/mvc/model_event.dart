import 'abstract_model.dart';

/// Encapsulates change notifications dispatched from a [Model] to registered [ModelListener]s.
///
/// Analogous to the Java MVC `ModelEvent`. Carries the originating model source,
/// an event identifier, an explanatory message, and optional contextual payloads.
class ModelEvent {
  /// The model instance that generated this event.
  final AbstractModel? source;

  /// An integer identifying the specific event or action category.
  final int id;

  /// A descriptive message associated with the event.
  final String message;

  /// An optional numeric payload (e.g., progress value, score, or count).
  final int amount;

  /// Constructs a [ModelEvent].
  const ModelEvent({
    this.source,
    this.id = 0,
    this.message = '',
    this.amount = 0,
  });
}
