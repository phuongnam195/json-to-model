enum DataType { String, int, double }

class Attribute {
  final DataType type;
  final String name;

  Attribute(this.type, this.name);

  String get strType => type.toString().split('.').last;

  String declare() {
    return '  ' + strType + ' ' + name + ';\n';
  }

  String constructor([bool required = false]) {
    return '      ' + (required ? 'required ' : '') + 'this.' + name + ',\n';
  }
}
