import 'dart:math';
import 'package:test/test.dart';
import 'package:dart_lib/dart_lib.dart';

class Position {
  const Position(
      {required this.level, required this.index, required this.offset});
  final int level;
  final int index;
  final int offset;
}

Iterable<Position> positionGenerator() sync* {
  int level = 0;

  while (level < 55) {
    final first = pow(2, level).toInt() - 1;
    final length = pow(2, level).toInt();
    final last = first + length - 1;
    yield Position(index: first, offset: 0, level: level);
    yield Position(index: last, offset: length - 1, level: level);
    level += 1;
  }
}

void main() {
  group('findHeapLevel', () {
    test('test if this works', () {
      final position = positionGenerator().iterator..moveNext();
      for (final pos in positionGenerator()) {
        final calculated = Heap.findHeapLevel(pos.index);
        expect(calculated.level, equals(pos.level));
        expect(calculated.offset, equals(pos.offset));
        expect(calculated.index, equals(pos.index));
        position.moveNext();
      }
    });
  });
  group('Heap', () {
    test('test push pop', () {
      final heap = Heap<int>();
      heap.push(1);
      final value = heap.pop();
      expect(value, 1);
    });

    test('test isEmpty', () {
      final heap = Heap<int>();
      expect(heap.isEmpty, equals(true));
      heap.push(1);
      expect(heap.isEmpty, equals(false));
      heap.pop();
      expect(heap.isEmpty, equals(true));
    });

    test('test first is max', () {
      final values = [1, 2, 3, 4, 5, 6, 7];
      final heap = Heap<int>();
      for (final value in values) {
        heap.push(value);
        expect(heap.heap.first, equals(value));
      }
    }, timeout: const Timeout(Duration(seconds: 1)));

    test('test sort longer', () {
      final result = [7, 6, 5, 4, 3, 2, 1];
      final heap = Heap<int>();
      result.forEach(heap.push);
      final output = <int>[];
      while (heap.isNotEmpty) {
        output.add(heap.pop());
      }
      expect(output, equals(result));
    }, timeout: const Timeout(Duration(seconds: 1)));

    test('test sort exhaustive', () {
      final result = [7, 6, 5, 4, 3, 2, 1];
      for (final list in permutation(result)) {
        final heap = Heap<int>();
        list.forEach(heap.push);
        final output = <int>[];

        while (heap.isNotEmpty) {
          output.add(heap.pop());
        }
        expect(output, equals(result));
      }
    }, timeout: const Timeout(Duration(seconds: 1)));
  });
}
