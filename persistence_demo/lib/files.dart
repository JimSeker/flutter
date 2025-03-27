import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';

class FilesWidget extends StatefulWidget {
  const FilesWidget({super.key});

  @override
  FileState createState() => FileState();
}

// this demos how to use key-value pairs in flutter

class FileState extends State<FilesWidget> {
  String fileContents = '';

  Future<String> readFile() async {
    try {
      // This is temporary directory, which is cleared when the app is closed.
      //final dir =  await getTemporaryDirectory();
      //this is the directory where the file will be stored and continue to exist,
      // deleted only when the app is uninstalled.
      //get the path object first, which were the file will be stored.
      final dir = await getApplicationDocumentsDirectory();
      //now get a file object to read the file
      final file = File('${dir.path}/file.txt');
      // Read the file
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return 'Error reading file';
    }
  }

  Future<File> writeFile(String contents) async {
    // This is temporary directory, which is cleared when the app is closed.
    //final dir =  await getTemporaryDirectory();
    //get the path object first, which were the file will be stored.
    final dir = await getApplicationDocumentsDirectory();
    //now get a file object to write the file
    final file = File('${dir.path}/file.txt');
    //developer.log("file name is ${dir}");
    // Write the file
    return file.writeAsString(contents, mode: FileMode.append);
  }

  @override
  void initState() {
    super.initState();
    readFile().then((value) {
      setState(() {
        fileContents = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              kIsWeb
                  ? <Widget>[const Text('Not supported on web')]
                  : <Widget>[
                    //read the file.
                    ElevatedButton(
                      onPressed: () async {
                        final contents = await readFile();
                        setState(() {
                          fileContents = contents;
                        });
                      },
                      child: const Text('Read File'),
                    ),
                    //write the file.
                    ElevatedButton(
                      onPressed: () async {
                        await writeFile('$fileContents \nHello, World!');
                      },
                      child: const Text('Write File'),
                    ),
                    const Text('File contents:'),
                    Text(fileContents),
                  ],
        ),
      ),
    );
  }
}
