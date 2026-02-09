import 'dart:io';
import 'dart:convert';
import 'package:apocrypha_uploader/models/book.dart';

enum ParseState {
  idle,
  inBooksTrackedBlock,
}

class ParseFile {
  final String filePath;
  ParseState state = ParseState.idle;

  ParseFile(this.filePath);

  String stripEnvelope(String line) {
    final idx = line.indexOf(']:');
    if (idx == -1) return line.trim();
    return line.substring(idx + 2).trim();
  }

  Future<List<BookDiscovery>> parse(File file) async {
  final discoveries = <BookDiscovery>[];

  BookDiscovery? current;
  ParseState state = ParseState.idle;

  await for (final line in file
      .openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter())) {

    final msg = stripEnvelope(line);

    if (msg == 'BOOKS TRACKED START') {
      state = ParseState.inBooksTrackedBlock;
      continue;
    }

    if (msg == 'BOOKS TRACKED END') {
      if (current != null) {
        discoveries.add(current);
        current = null;
      }
      state = ParseState.idle;
      continue;
    }

    if (state != ParseState.inBooksTrackedBlock) continue;

    // ---- inside block ----

    if (msg.startsWith('Book ID:')) {
      if (current != null) {
        discoveries.add(current); // previous book
      }
      current = BookDiscovery(
        bookId: msg.split('\t').last,
        inGameDate: '',
        osTimestamp: null,
        entryId: '',
        lastInteracted: 0,
        locationName: '',
        region: '',
        isExterior: null,
      );
      continue;
    }

    if (current == null) continue;

    if (msg.startsWith('In-Game Discovered On:')) {
      current = current.copyWith(
        inGameDate: msg.split('\t').last,
      );
    } else if (msg.startsWith('OS Time Discovered On:')) {
      final val = msg.split('\t').last;
      current = current.copyWith(
        osTimestamp: val == 'nil' ? null : int.parse(val),
      );
    } else if (msg.startsWith('Entry ID:')) {
      current = current.copyWith(entryId: msg.split('\t').last);
    } else if (msg.startsWith('Last Interacted:')) {
      current = current.copyWith(
        lastInteracted: double.parse(msg.split('\t').last),
      );
    } else if (msg.startsWith('Name:')) {
      current = current.copyWith(locationName: msg.split('\t').last);
    } else if (msg.startsWith('Region:')) {
      current = current.copyWith(region: msg.split('\t').last);
    } else if (msg.startsWith('Is Exterior:')) {
      final v = msg.split('\t').last;
      current = current.copyWith(
        isExterior: v == 'nil' ? null : v == 'true',
      );
    }
  }

  return discoveries;
}

}