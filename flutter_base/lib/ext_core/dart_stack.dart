/// dart 数据结构栈
class DartStack<E> {
  final List<E> _stack;
  final int capacity;
  int _top;

  DartStack(this.capacity)
      : _top = -1,
        _stack = List<E>(capacity);
  // DartStack()
  //     : _top = -1,
  //       _stack = List<E>();

  bool get isEmpty => _top == -1;
  bool get isFull => _top == capacity - 1;
  int get size => _top + 1;

  void push(E e) {
    if (isFull) throw StackOverFlowException;
    _stack[++_top] = e;
  }

  E pop() {
    if (isEmpty) throw StackEmptyException;
    return _stack[_top--];
  }

  void clearAndPush(E e) {
    // _stack.clear();
    _top = -1;
    push(e);
  }

  E get top {
    if (isEmpty) throw StackEmptyException;
    return _stack[_top];
  }
}

class StackOverFlowException implements Exception {
  const StackOverFlowException();
  String toString() => 'StackOverFlowException';
}

class StackEmptyException implements Exception {
  const StackEmptyException();
  String toString() => 'StackEmptyException';
}

void main() {
  var stack = DartStack<int>(10);
  for (var i = 0; i < stack.capacity; i++) stack.push(i * i);
  print(stack.top);

  var sbuff = StringBuffer();
  while (!stack.isEmpty) sbuff.write('${stack.pop()} ');
  print(sbuff.toString());
}
