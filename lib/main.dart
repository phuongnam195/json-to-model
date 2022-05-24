import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:json_to_model/converter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Convert JSON to model',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _jsonInputController = TextEditingController();
  final _classNameController = TextEditingController();
  final _outputController = TextEditingController();

  bool _namedOptionalParamFlag = true;
  bool _jsonSerializableFlag = true;
  bool _toStringFlag = true;
  bool _mapToListFlag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _jsonInputController,
                decoration: const InputDecoration(labelText: 'JSON'),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              TextField(
                controller: _classNameController,
                decoration: const InputDecoration(labelText: 'Class name'),
              ),
              CheckboxListTile(
                title: const Text('Named optional parameters'),
                value: _namedOptionalParamFlag,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _namedOptionalParamFlag = newValue;
                    });
                  }
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: const Text('Json serializable + build runner'),
                value: _jsonSerializableFlag,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _jsonSerializableFlag = newValue;
                    });
                  }
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: const Text('toString'),
                value: _toStringFlag,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _toStringFlag = newValue;
                    });
                  }
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: const Text('mapToList'),
                value: _mapToListFlag,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _mapToListFlag = newValue;
                    });
                  }
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              ElevatedButton(
                child: const Text('CONVERT'),
                onPressed: () {
                  _outputController.text = Converter(
                          json: _jsonInputController.text,
                          className: _classNameController.text,
                          namedOptionalParamFlag: _namedOptionalParamFlag,
                          jsonSerializableFlag: _jsonSerializableFlag,
                          toStringFlag: _toStringFlag,
                          mapToListFlag: _mapToListFlag)
                      .toModel();
                  FlutterClipboard.copy(_outputController.text).then((value) =>
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Copied"),
                      )));
                },
              ),
              TextFormField(
                controller: _outputController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                readOnly: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
