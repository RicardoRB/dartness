Iterable<T> stringToIterable<T>(
  final String value,
  final T Function(String e) toElement,
) {
  return value
      .replaceAll("[", "")
      .replaceAll("]", "")
      .split(",")
      .map<T>(toElement);
}

Iterable<int> stringToIterableInt(final String value) =>
    stringToIterable(value, (e) => int.parse(e));

Iterable<double> stringToIterableDouble(final String value) =>
    stringToIterable(value, (e) => double.parse(e));

Iterable<num> stringToIterableNum(final String value) =>
    stringToIterable(value, (e) => num.parse(e));

Iterable<String> stringToIterableString(final String value) =>
    stringToIterable(value, (e) => e.toString());

Iterable<bool> stringToIterableBool(final String value) =>
    stringToIterable(value, (e) => e == 'true');
