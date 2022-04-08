class DayEventModel {
  DayEventModel({
    required this.id,
    this.cultureTitle,
    required this.date,
    this.concertTitle,
    this.concertLocation,
    this.sportEvents,
    this.cultureEvents,
    this.concertGroups,
  });
  late final int id;
  late final String? cultureTitle;
  late final DateTime? date;
  late final String? concertTitle;
  late final String? concertLocation;
  late final List<SportEvent>? sportEvents;
  late final List<CultureEvent>? cultureEvents;
  late final List<ConcertGroups>? concertGroups;

  DayEventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cultureTitle = json['cultureTitle'];
    date = DateTime.parse(json['date']).toLocal();
    concertTitle = json['concertTitle'];
    concertLocation = json['concertLocation'];
    sportEvents = List.from(json['sportEvents'])
        .map((e) => SportEvent.fromJson(e))
        .toList();
    cultureEvents = List.from(json['cultureEvents'])
        .map((e) => CultureEvent.fromJson(e))
        .toList();
    concertGroups = List.from(json['concertGroups'])
        .map((e) => ConcertGroups.fromJson(e))
        .toList();
  }
}

class SportEvent {
  SportEvent({
    required this.id,
    required this.title,
    required this.startTime,
    required this.location,
    required this.price,
    required this.registrationLink,
    required this.team,
    required this.description,
  });
  late final int id;
  late final String title;
  late final DateTime? startTime;
  late final String location;
  late final double? price;
  late final String? registrationLink;
  late final String? team;
  late final List<String>? description;
  late final List<String>? imageUrls;

  SportEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    startTime = DateTime.parse(json['startTime']);

    location = json['location'];
    price = json['price'];
    registrationLink = json['registrationLink'];
    team = json['team'];
    description = List.castFrom<dynamic, String>(json['description']);
    imageUrls = json['imageUrls'] != null
        ? List.castFrom<dynamic, String>(json['imageUrls'])
        : null;
  }
}

class CultureEvent {
  CultureEvent({
    required this.id,
    required this.title,
    required this.startTime,
    required this.dayTitle,
    required this.description,
  });
  late final int id;
  late final String title;
  late final String? dayTitle;
  late final DateTime? startTime;
  late final List<String>? description;

  CultureEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    dayTitle = json['dayTitle'];
    startTime = DateTime.parse(json['startTime']);
    description = List.castFrom<dynamic, String>(json['description']);
  }
}

class ConcertEvent {
  ConcertEvent({
    required this.concertName,
    required this.concertLocation,
    required this.date,
    required this.concertGroups,
  });

  late final String concertName;
  late final String concertLocation;
  late final DateTime date;
  late final List<ConcertGroups> concertGroups;

  ConcertEvent.fromJson(Map<String, dynamic> json) {
    concertName = json['concertName'];
    concertLocation = json['concertLocation'];
    date = DateTime.parse(json['date']);
    concertGroups = List.from(json['concertGroups'])
        .map((e) => ConcertGroups.fromJson(e))
        .toList();
  }
}

class ConcertGroups {
  ConcertGroups({
    required this.id,
    required this.place,
    required this.musicGroup,
    required this.titleSize,
  });
  late final int? id;
  late final int place;
  late final String musicGroup;
  late final String titleSize;

  ConcertGroups.fromJson(Map<String, dynamic> json) {
    id = json['concertGroupId'];
    place = json['place'];
    musicGroup = json['musicGroup'];
    titleSize = json['titleSize'];
  }
}
