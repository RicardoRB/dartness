class Foo {
  const Foo(this.value);

  final String value;

  Map<String, dynamic> toJson() {
    return {
      'value': value,
    };
  }

  Foo.fromJson(Map<String, dynamic> json) : value = json['value'];
}
