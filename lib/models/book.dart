class Book {
  final String bookId;
  final String inGameDate;
  final int? osTimestamp;
  final String entryId;
  final double lastInteracted;
  final String locationName;
  final String region;
  final bool? isExterior;

  Book({
    required this.bookId,
    required this.inGameDate,
    required this.osTimestamp,
    required this.entryId,
    required this.lastInteracted,
    required this.locationName,
    required this.region,
    required this.isExterior,
  });
  Book copyWith({
  String? bookId,
  String? inGameDate,
  int? osTimestamp,
  String? entryId,
  double? lastInteracted,
  String? locationName,
  String? region,
  bool? isExterior,
  }) {
    return Book(
      bookId: bookId ?? this.bookId,
      inGameDate: inGameDate ?? this.inGameDate,
      osTimestamp: osTimestamp ?? this.osTimestamp,
      entryId: entryId ?? this.entryId,
      lastInteracted: lastInteracted ?? this.lastInteracted,
      locationName: locationName ?? this.locationName,
      region: region ?? this.region,
      isExterior: isExterior ?? this.isExterior,
    );
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return switch(json) {
      {
        'bookId': String bookId,
        'inGameDate': String inGameDate,
        'osTimestamp': int? osTimestamp,
        'entryId': String entryId,
        'lastInteracted': double lastInteracted,
        'locationName': String locationName,
        'region': String region,
        'isExterior': bool? isExterior,
      } => Book(
          bookId: bookId,
          inGameDate: inGameDate,
          osTimestamp: osTimestamp,
          entryId: entryId,
          lastInteracted: lastInteracted,
          locationName: locationName,
          region: region,
          isExterior: isExterior,
        ),
      _ => throw FormatException('Invalid JSON format for BookDiscovery'),
    };
  }
}
