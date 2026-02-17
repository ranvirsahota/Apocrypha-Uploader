
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:apocrypha_uploader/services/authentication.dart';
import 'package:apocrypha_uploader/models/book.dart';
import 'package:apocrypha_uploader/services/parse_file.dart';
import 'package:apocrypha_uploader/button.dart';
import 'package:apocrypha_uploader/services/apocrypha_api.dart';
import 'package:openid_client/openid_client_io.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Book>? bookDiscoveries;
  late final TextEditingController _filePathController;
  late final ApocryphaApi _apocryphaApi;
  late TokenResponse _accessToken; // Store the access token after login

  @override
  void initState() {
    super.initState();
    bookDiscoveries = [];
    _filePathController = TextEditingController();
    _apocryphaApi = ApocryphaApi();
  }

  @override
  void dispose() {
    _filePathController.dispose();
    super.dispose();
  }

  void fileRead(String filePath) async {
    final bookDiscoveriesList = await ParseFile().parse(File(filePath));

      setState(() {
        bookDiscoveries = bookDiscoveriesList;
      });
  }

  void removeDiscovery(int index) {
    setState(() {
      bookDiscoveries!.removeAt(index);
    });
  }

  Future<void> login() async {
    final credential = await authenticate(Uri.parse('https://dev-gmkle75qnno7401s.eu.auth0.com'),
                                    'tHyaL1mE7VbWQlipvkH6ShstRHVcSiGx',
                                    ['openid', 'profile', 'email']);
    _accessToken = await credential.getTokenResponse();
    print('Login successful');
  }
    


  void pickFile() async {
    // ** DEVELOPMENT CODE ONLY - NOT FIT FOR PRODUCTION **
    // If not on Windows, skip file picking and use a hardcoded path for development purposes
    if (!Platform.isWindows) {
      _filePathController.text = 'File picking not supported on this platform.';
      fileRead('/mnt/c/Users/Ranvir/Documents/My Games/OpenMW/openmw.log');
      return;
    }
    
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    late String filePath;
    if (result != null) {
      filePath = result.files.single.path!;
      fileRead(filePath);
      // You can now use the file path to read the file or perform other operations
    } else { filePath = 'No file selected'; }

    _filePathController.text = filePath;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Column(
          children: [
            ElevatedButton(
              onPressed: login, // Replace with login function
              child: const Text('Login'),
            ),
            TextField(
              enabled: false,
              controller: _filePathController,
              decoration: InputDecoration(
                labelText: 'Selected File',
                //hintText: 'No file selected',
              ),
            ),

            ElevatedButton(
              onPressed: pickFile,
              child: const Text('Pick Log File'),
            ),
            Expanded(
              child: ListView.builder(
              itemCount: bookDiscoveries!.length,
              itemBuilder: (context, index) {
                if (bookDiscoveries == null || bookDiscoveries!.isEmpty) {
                  return const ListTile(
                    title: Text('No book discoveries found.'),
                  );
                }
                final discovery = bookDiscoveries![index];
                return ListTile(
                  title: Text('${discovery.bookId} '),
                  subtitle: Text('In Game Date: ${discovery.inGameDate}, OS: ${discovery.osTimestamp}'),
                  leading: Button(icon: Icons.upload, onPressed: () => _apocryphaApi.uploadDiscovery(
                    _accessToken.accessToken!,
                    discovery.bookId, discovery.inGameDate, discovery.osTimestamp)),
                  trailing: Button(icon: Icons.close, onPressed: () => removeDiscovery(index)),
                );

              },
            ))
          ],
        ),
      );
  }
}