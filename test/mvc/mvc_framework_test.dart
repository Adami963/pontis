import 'package:flutter_test/flutter_test.dart';
import 'package:pontis/src/mvc/abstract_model.dart';
import 'package:pontis/src/mvc/model_event.dart';
import 'package:pontis/src/mvc/model_listener.dart';

/// Minimal concrete model used to exercise [AbstractModel].
class TestModel extends AbstractModel {}

/// Listener that records every event it receives.
class TestListener implements ModelListener {
  final List<ModelEvent> received = <ModelEvent>[];

  @override
  void modelChanged(ModelEvent event) {
    received.add(event);
  }
}

/// Listener that unregisters itself while it is being notified.
class SelfRemovingListener implements ModelListener {
  SelfRemovingListener(this.model);

  final AbstractModel model;
  int callCount = 0;

  @override
  void modelChanged(ModelEvent event) {
    callCount++;
    model.removeModelListener(this);
  }
}

void main() {
  group('AbstractModel observer registry', () {
    late TestModel model;
    late TestListener listener;

    setUp(() {
      model = TestModel();
      listener = TestListener();
    });

    test('delivers an event to a registered listener', () {
      model.addModelListener(listener);
      const event = ModelEvent(id: 1, message: 'changed', amount: 5);

      model.notifyChanged(event);

      expect(listener.received, hasLength(1));
      expect(listener.received.first, same(event));
    });

    test('stops delivering events after a listener is removed', () {
      model.addModelListener(listener);
      const event = ModelEvent(message: 'ping');

      model.notifyChanged(event);
      model.removeModelListener(listener);
      model.notifyChanged(event);

      expect(listener.received, hasLength(1));
    });

    test('does not register the same listener twice', () {
      model.addModelListener(listener);
      model.addModelListener(listener);

      model.notifyChanged(const ModelEvent(message: 'ping'));

      expect(listener.received, hasLength(1));
    });

    test('notifies every registered listener', () {
      final other = TestListener();
      model.addModelListener(listener);
      model.addModelListener(other);

      model.notifyChanged(const ModelEvent(message: 'ping'));

      expect(listener.received, hasLength(1));
      expect(other.received, hasLength(1));
    });

    test('survives a listener unregistering itself during notification', () {
      final selfRemoving = SelfRemovingListener(model);
      model.addModelListener(selfRemoving);
      model.addModelListener(listener);
      const event = ModelEvent(message: 'ping');

      expect(() => model.notifyChanged(event), returnsNormally);
      model.notifyChanged(event);

      expect(selfRemoving.callCount, equals(1));
      expect(listener.received, hasLength(2));
    });
  });
}
