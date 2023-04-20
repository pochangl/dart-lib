Iterable<List<T>> permutation<T>(List<T> items) sync* {
  final length = items.length;
  if (length <= 1) {
    yield items;
    return;
  }
  for (int index = 0; index < length; index++) {
    final element = items[index];
    final prefix = items.sublist(0, index);
    final suffix = items.sublist(index + 1, length);
    final remaining = [...prefix, ...suffix];
    for (final sublist in permutation(remaining)) {
      yield [element, ...sublist];
    }
  }
}
