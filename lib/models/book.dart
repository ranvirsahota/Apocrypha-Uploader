class BookDiscovery {
  final String bookId;
  final String inGameDate;
  final int? osTimestamp;
  final String entryId;
  final double lastInteracted;
  final String locationName;
  final String region;
  final bool? isExterior;

  BookDiscovery({
    required this.bookId,
    required this.inGameDate,
    required this.osTimestamp,
    required this.entryId,
    required this.lastInteracted,
    required this.locationName,
    required this.region,
    required this.isExterior,
  });
  BookDiscovery copyWith({
  String? bookId,
  String? inGameDate,
  int? osTimestamp,
  String? entryId,
  double? lastInteracted,
  String? locationName,
  String? region,
  bool? isExterior,
}) {
  return BookDiscovery(
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

}
