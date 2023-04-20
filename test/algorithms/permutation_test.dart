import 'package:dart_lib/dart_lib.dart';
import 'package:test/test.dart';

void main() {
  group('permutation', () {
    test('[1, 2]', () {
      expect(
          permutation([1, 2]).toList(),
          equals([
            [1, 2],
            [2, 1]
          ]));
    });
    test('[1, 2, 3]', () {
      expect(
          permutation([1, 2, 3]).toList(),
          equals([
            [1, 2, 3],
            [1, 3, 2],
            [2, 1, 3],
            [2, 3, 1],
            [3, 1, 2],
            [3, 2, 1],
          ]));
    });
  });
}
