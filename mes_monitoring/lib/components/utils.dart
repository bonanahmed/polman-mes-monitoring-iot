import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SetUrlDialog extends StatefulWidget {
  @override
  _SetUrlDialogState createState() => _SetUrlDialogState();
}

class _SetUrlDialogState extends State<SetUrlDialog> {
  GetStorage box = GetStorage();
  final TextEditingController _textController = TextEditingController();
  String inputValue = '';
  @override
  void initState() {
    setState(() {
      _textController.text = box.read("url");
      inputValue = box.read("url");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Atur URL Server'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _textController,
            decoration: const InputDecoration(labelText: 'Input URL'),
            onChanged: (value) {
              setState(() {
                inputValue = value;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              box.write("url", inputValue);
              Navigator.of(context).pop();
            },
            child: const Text('Submit', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class SetBoxDialog extends StatefulWidget {
  const SetBoxDialog({super.key});

  @override
  _SetBoxDialogState createState() => _SetBoxDialogState();
}

class _SetBoxDialogState extends State<SetBoxDialog> {
  final TextEditingController _textControllerWhite = TextEditingController();
  final TextEditingController _textControllerBlack = TextEditingController();
  String inputValueWhite = '0';
  String inputValueBlack = '0';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Atur URL Server'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.number,
            controller: _textControllerWhite,
            decoration:
                const InputDecoration(labelText: 'Masukkan Botol Putih'),
            onChanged: (value) {
              setState(() {
                inputValueWhite = value;
              });
            },
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: _textControllerBlack,
            decoration:
                const InputDecoration(labelText: 'Masukkan Botol Hitam'),
            onChanged: (value) {
              setState(() {
                inputValueBlack = value;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop({
                "MEMORY_BLACK":
                    int.parse(inputValueBlack != "" ? inputValueBlack : "0"),
                "MEMORY_WHITE":
                    int.parse(inputValueWhite != "" ? inputValueWhite : "0")
              });
            },
            child: const Text('Submit', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textControllerWhite.dispose();
    _textControllerBlack.dispose();
    super.dispose();
  }
}
