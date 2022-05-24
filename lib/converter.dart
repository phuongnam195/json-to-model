import 'package:json_to_model/attribute.dart';

class Converter {
  String json;
  final String className;
  final bool namedOptionalParamFlag;
  final bool jsonSerializableFlag;
  final bool toStringFlag;
  final bool mapToListFlag;
  List<Attribute> _attributes = [];

  Converter(
      {required this.json,
      required this.className,
      required this.namedOptionalParamFlag,
      required this.jsonSerializableFlag,
      required this.toStringFlag,
      required this.mapToListFlag}) {
    _attributes = _getAtributes();
  }

  String toModel() {
    return _toImport() +
        _toClass(_toDeclaration() +
            _toConstructor() +
            _toJsonSerializable() +
            _toToString() +
            _toMapToList());
  }

  String _toImport() {
    String result = '';
    if (jsonSerializableFlag) {
      result += "import 'package:json_annotation/json_annotation.dart';\n\n";
      result += "part '.g.dart';\n\n";
      result += "@JsonSerializable()\n";
    }
    return result;
  }

  String _toClass(String content) {
    String result = '';
    result += "class " + className + " {\n";
    result += content;
    result += '}';

    return result;
  }

  String _toDeclaration() {
    String result = '';
    for (var attr in _attributes) {
      result += attr.declare();
    }
    result += '\n';
    return result;
  }

  String _toConstructor() {
    String result = '';
    result += className + '(';
    if (namedOptionalParamFlag) {
      result += '{';
    }
    result += '\n';
    for (var attr in _attributes) {
      result += attr.constructor(namedOptionalParamFlag);
    }
    if (namedOptionalParamFlag) {
      result += '}';
    }
    result += ');\n\n';

    return result;
  }

  String _toJsonSerializable() {
    if (!jsonSerializableFlag) return '';
    String result =
        '  factory $className.fromJson(Map<String, dynamic> json) =>';
    result += '\n';
    result += "      _\$${className}FromJson(json);";
    result += '\n\n';
    result += "  Map<String, dynamic> toJson() => _\$${className}ToJson(this);";
    result += '\n\n';
    return result;
  }

  String _toToString() {
    if (!toStringFlag) return '';
    String result = '  @override\n';
    result += '  String toString() {\n';
    result += '    return \'$className{';
    result += _attributes
        .map((attr) => attr.name + ': \$' + attr.name)
        .toList()
        .join(', ');
    result += "}';\n";
    result += '  }\n\n';

    return result;
  }

  String _toMapToList() {
    String result = '  @override\n';
    result += '  List<$className> mapToList(List<dynamic> maps) {\n';
    result +=
        '    return maps.map((data) => $className.fromJson(data)).toList();\n';
    result += '  }\n';

    return result;
  }

  List<Attribute> _getAtributes() {
    List<Attribute> result = [];

    // "shopName": "Ngọc Ngà Đăng",
    // a        b   c            d

    while (true) {
      int a = json.indexOf("\"");
      if (a == -1) {
        break;
      }
      int b = json.indexOf("\"", a + 1);
      if (b == -1) {
        break;
      }
      final name = json.substring(a + 1, b);

      int c = b + 1;
      while (json[c] == ' ' || json[c] == ':') {
        c++;
      }

      int d = c;
      var type = DataType.String;
      if (json[c] != '"') {
        type = DataType.int;
        d = json.indexOf(',', c + 1) - 1;
        if (json.substring(c + 1, d + 1).contains('.')) {
          type = DataType.double;
        }
      } else {
        c += 1;
        d = c;
        do {
          d = json.indexOf('"', d);
        } while (json[d - 1] == '\\');
      }

      json = json.substring(d + 2);

      result.add(Attribute(type, name));
    }

    return result;
  }
}
