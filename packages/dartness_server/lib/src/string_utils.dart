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


/// Given a [value] with a [type] return the value with the correct type.
dynamic stringToType(final String? value, final Type type) {
  if (value == null) {
    return null;
  }
  if (type == num) {
    return num.parse(value);
  } else if (type == int) {
    return int.parse(value);
  } else if (type == double) {
    return double.parse(value);
  } else if (type == bool) {
    return value == 'true';
  } else if (type == DateTime) {
    return DateTime.parse(value);
  } else if (type == List<int>) {
    return stringToIterableInt(value).toList();
  } else if (type == List<double>) {
    return stringToIterableDouble(value).toList();
  } else if (type == List<bool>) {
    return stringToIterableBool(value).toList();
  } else if (type == List<String>) {
    return stringToIterableString(value).toList();
  } else if (type == List<Object>) {
    return stringToIterableString(value).toList();
  } else if (type == Set<int>) {
    return stringToIterableInt(value).toSet();
  } else if (type == Set<double>) {
    return stringToIterableDouble(value).toSet();
  } else if (type == Set<bool>) {
    return stringToIterableBool(value).toSet();
  } else if (type == Set<String>) {
    return stringToIterableString(value).toSet();
  } else if (type == Set<Object>) {
    return stringToIterableString(value).toSet();
  } else {
    return value;
  }
}