/// Generates an [Iterable] of a specified conversion way by [toElement]
/// from a [String] with a [json array structure](https://www.w3schools.com/js/js_json_arrays.asp)
///
/// Example:
/// ```dart
/// String array = '[1,2]'
/// List<int> list = stringToIterable(array, (element) => int.parse(element)).toList();
/// ```
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

/// Generates an [Iterable] of [int]
/// from a [String] with a [json array structure](https://www.w3schools.com/js/js_json_arrays.asp)
///
/// Example:
/// ```dart
/// String array = '[1,2]'
/// List<int> list = stringToIterableInt(array).toList();
/// ```
Iterable<int> stringToIterableInt(final String value) =>
    stringToIterable(value, (e) => int.parse(e));

/// Generates an [Iterable] of [double]
/// from a [String] with a [json array structure](https://www.w3schools.com/js/js_json_arrays.asp)
///
/// Example:
/// ```dart
/// String array = '[1.1, 2.1]'
/// List<double> list = stringToIterableDouble(array).toList();
/// ```
Iterable<double> stringToIterableDouble(final String value) =>
    stringToIterable(value, (e) => double.parse(e));

/// Generates an [Iterable] of [num]
/// from a [String] with a [json array structure](https://www.w3schools.com/js/js_json_arrays.asp)
///
/// Example:
/// ```dart
/// String array = '[1.1, 2]'
/// List<num> list = stringToIterableDouble(array).toList();
/// ```
Iterable<num> stringToIterableNum(final String value) =>
    stringToIterable(value, (e) => num.parse(e));

/// Generates an [Iterable] of [String]
/// from a [String] with a [json array structure](https://www.w3schools.com/js/js_json_arrays.asp)
///
/// Example:
/// ```dart
/// String array = '["string1", "string2"]'
/// List<String> list = stringToIterableString(array).toList();
/// ```
Iterable<String> stringToIterableString(final String value) =>
    stringToIterable(value, (e) => e.toString());

/// Generates an [Iterable] of [bool]
/// from a [String] with a [json array structure](https://www.w3schools.com/js/js_json_arrays.asp)
///
/// Example:
/// ```dart
/// String array = '[true, false]'
/// List<bool> list = stringToIterableBool(array).toList();
/// ```
Iterable<bool> stringToIterableBool(final String value) =>
    stringToIterable(value, (e) => e == 'true');
