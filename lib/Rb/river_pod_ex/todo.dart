import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// A read-only description of a todo-item
@immutable
class Todo {
  const Todo({
    required this.description,
    required this.id,
    this.completed = false,
  });

  final String id;
  final String description;
  final bool completed;

  @override
  String toString() {
    return 'Todo(description: $description, completed: $completed)';
  }
}

/// An object that controls a list of [Todo].
///
/// Riverpod 3: [StateNotifier] was removed in favor of [Notifier]. Initial
/// state is exposed via [build] rather than the constructor.
class TodoList extends Notifier<List<Todo>> {
  TodoList([List<Todo>? initialTodos]) : _initialTodos = initialTodos;

  final List<Todo>? _initialTodos;

  @override
  List<Todo> build() => _initialTodos ?? [];

  void add(String description) {
    state = [
      ...state,
      Todo(
        id: _uuid.v4(),
        description: description,
      ),
    ];
    print("add item..${state}");
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: !todo.completed,
            description: todo.description,
          )
        else
          todo,
    ];
    print("toggle item..${state}");
  }

  void edit({required String id, required String description}) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: todo.completed,
            description: description,
          )
        else
          todo,
    ];
    print("Edit item..${state}");
  }

  void remove(Todo target) {
    state = state.where((todo) => todo.id != target.id).toList();
  }
}
