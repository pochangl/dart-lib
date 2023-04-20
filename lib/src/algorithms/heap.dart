import 'dart:math';

import 'package:collection/collection.dart';

class HeapItem<T> {
  HeapItem(
      {required this.priority, required this.item, required this.position});

  final int priority;
  HeapPosition position;
  final T item;
}

class HeapPosition {
  const HeapPosition({required this.level, required this.offset});
  final int level;
  final int offset;

  int get index {
    return pow(2, level).toInt() + offset - 1;
  }

  HeapPosition get left {
    return HeapPosition(level: level + 1, offset: offset * 2);
  }

  HeapPosition get right {
    return HeapPosition(level: level + 1, offset: offset * 2 + 1);
  }

  HeapPosition? get parent {
    if (level != 0) {
      return HeapPosition(level: level + -1, offset: offset ~/ 2);
    }
    return null;
  }

  HeapPosition? get previous {
    if (index == 0) {
      return null;
    } else if (offset == 0) {
      return Heap.findHeapLevel(index - 1);
    } else {
      return HeapPosition(level: level, offset: offset - 1);
    }
  }

  static const HeapPosition root = HeapPosition(level: 0, offset: 0);
}

enum Branch {
  left,
  right,
}


class Heap<T extends Comparable<dynamic>> {
  List<T> heap = [];

  static HeapPosition findHeapLevel(int index) {
    int power = (log(index + 1) / log(2)).floor();
    int first = pow(2, power).toInt() - 1;

    // 依誤差調整
    if (first > index) {
      power -= 1;
    } else if (pow(2, power + 1).toInt() - 1 < index) {
      power += 1;
    }

    first = pow(2, power).toInt() - 1; // recalculate first
    final offset = index - first;
    return HeapPosition(level: power, offset: offset);
  }

  void push(T item) {
    heap.add(item);
    final position = findHeapLevel(heap.length - 1);
    rearrangeUpward(position);
  }

  void rearrangeUpward(HeapPosition position) {
    final index = position.index;
    final parentPosition = position.parent;
    if (parentPosition == null) {
      return;
    }
    final parent = parentPosition.index;
    if (heap[index].compareTo(heap[parent]) > 0) {
      heap.swap(index, parent);
      rearrangeUpward(position.parent!);
    }
  }

  void arrangeDownward(HeapPosition position) {
    final index = position.index;
    final left = position.left.index;
    final right = position.right.index;
    Branch branch = Branch.left;
    if (left >= heap.length) {
      return;
    } else if (right < heap.length) {
      if (heap[left].compareTo(heap[right]) < 0) {
        branch = Branch.right;
      }
    }
    switch (branch) {
      case Branch.left:
        if (heap[left].compareTo(heap[index]) > 0) {
          heap.swap(left, index);
          return arrangeDownward(position.left);
        }
        break;
      case Branch.right:
        if (heap[right].compareTo(heap[index]) > 0) {
          heap.swap(right, index);
          return arrangeDownward(position.right);
        }
        break;
    }
  }

  T pop() {
    final node = heap.first;
    final last = heap.removeLast();
    if (length >= 1) {
      heap[0] = last;
      arrangeDownward(HeapPosition.root);
    }
    return node;
  }

  bool get isEmpty => heap.isEmpty;
  bool get isNotEmpty => !isEmpty;
  int get length => heap.length;
}
