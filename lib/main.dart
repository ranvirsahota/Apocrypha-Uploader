import 'package:apocrypha_uploader/models/book.dart';
import 'package:apocrypha_uploader/services/parse_file.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

import 'package:apocrypha_uploader/services/authentication.dart';

class MainApp extends StatefulWidget {

  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<BookDiscovery> bookDiscoveries = [];
  Future<void> login() async {
    var userInfo = await authenticate(Uri.parse('https://dev-gmkle75qnno7401s.eu.auth0.com'),
                                      'tHyaL1mE7VbWQlipvkH6ShstRHVcSiGx',
                                      ['openid', 'profile', 'email']);
    print(userInfo);
  }

  void fileRead() async {
    const filePath = '/mnt/c/Users/Ranvir/Documents/My Games/OpenMW/openmw.log';
    final bookDiscoveriesList = await ParseFile(filePath).parse(File(filePath));

      setState(() {
        bookDiscoveries.clear();
        bookDiscoveries.addAll(bookDiscoveriesList);
      });
  }

  @override
  Widget build(BuildContext context) {
    fileRead();
    return MaterialApp(
      home: Scaffold(
        body:  Column(
          children: [
            ElevatedButton(
              onPressed: login, // Replace with login function
              child: const Text('Login'),
            ),
            Expanded(
              child: ListView.builder(
              itemCount: bookDiscoveries.length,
              itemBuilder: (context, index) {
                final discovery = bookDiscoveries[index];
                return ListTile(
                  title: Text('${discovery.bookId} '),
                  subtitle: Text('In Game Date: ${discovery.inGameDate}, OS: ${discovery.osTimestamp}'),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MainApp());
}