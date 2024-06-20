import 'package:collection/collection.dart';

extension StringExtension on String {
  /// Generates an [Iterable] of a specified conversion way by [toElement]
  /// from a [String] with a [json array structure](https://www.w3schools.com/js/js_json_arrays.asp)
  ///
  /// Example:
  /// ```dart
  /// String array = '[1,2]'
  /// List<int> list = stringToIterable(array, (element) => int.parse(element)).toList();
  /// ```
  Iterable<T> stringToIterable<T>(final T Function(String e) toElement) {
    return replaceAll("[", "").replaceAll("]", "").split(",").map<T>(toElement);
  }

  /// Generates an [Iterable] of [int]
  /// from a [String] with a [json array structure](https://www.w3schools.com/js/js_json_arrays.asp)
  ///
  /// Example:
  /// ```dart
  /// String array = '[1,2]'
  /// List<int> list = stringToIterableInt(array).toList();
  /// ```
  Iterable<int> stringToIterableInt() => stringToIterable((e) => int.parse(e));

  /// Generates an [Iterable] of [double]
  /// from a [String] with a [json array structure](https://www.w3schools.com/js/js_json_arrays.asp)
  ///
  /// Example:
  /// ```dart
  /// String array = '[1.1, 2.1]'
  /// List<double> list = stringToIterableDouble(array).toList();
  /// ```
  Iterable<double> stringToIterableDouble() =>
      stringToIterable((e) => double.parse(e));

  /// Generates an [Iterable] of [num]
  /// from a [String] with a [json array structure](https://www.w3schools.com/js/js_json_arrays.asp)
  ///
  /// Example:
  /// ```dart
  /// String array = '[1.1, 2]'
  /// List<num> list = stringToIterableDouble(array).toList();
  /// ```
  Iterable<num> stringToIterableNum(final String value) =>
      stringToIterable((e) => num.parse(e));

  /// Generates an [Iterable] of [String]
  /// from a [String] with a [json array structure](https://www.w3schools.com/js/js_json_arrays.asp)
  ///
  /// Example:
  /// ```dart
  /// String array = '["string1", "string2"]'
  /// List<String> list = stringToIterableString(array).toList();
  /// ```
  Iterable<String> stringToIterableString() =>
      stringToIterable((e) => e.toString());

  /// Generates an [Iterable] of [bool]
  /// from a [String] with a [json array structure](https://www.w3schools.com/js/js_json_arrays.asp)
  ///
  /// Example:
  /// ```dart
  /// String array = '[true, false]'
  /// List<bool> list = stringToIterableBool(array).toList();
  /// ```
  Iterable<bool> stringToIterableBool() =>
      stringToIterable((e) => bool.tryParse(e)).nonNulls;

  /// Returns the [type] with the correct type.
  dynamic stringToType(final Type type) {
    if (type == num) {
      return num.parse(this);
    } else if (type == int) {
      return int.parse(this);
    } else if (type == double) {
      return double.parse(this);
    } else if (type == bool) {
      return bool.tryParse(this);
    } else if (type == DateTime) {
      return DateTime.parse(this);
    } else if (type == List<int>) {
      return stringToIterableInt().toList();
    } else if (type == List<double>) {
      return stringToIterableDouble().toList();
    } else if (type == List<bool>) {
      return stringToIterableBool().toList();
    } else if (type == List<String>) {
      return stringToIterableString().toList();
    } else if (type == List<Object>) {
      return stringToIterableString().toList();
    } else if (type == Set<int>) {
      return stringToIterableInt().toSet();
    } else if (type == Set<double>) {
      return stringToIterableDouble().toSet();
    } else if (type == Set<bool>) {
      return stringToIterableBool().toSet();
    } else if (type == Set<String>) {
      return stringToIterableString().toSet();
    } else if (type == Set<Object>) {
      return stringToIterableString().toSet();
    } else {
      return this;
    }
  }
}
