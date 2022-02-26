import 'dart:math';

extension ListX<E> on List<E> {
  static final _random = Random();

  E randomElement() {
    return elementAt(_random.nextInt(length));
  }
}
