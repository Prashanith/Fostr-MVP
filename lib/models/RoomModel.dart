class Room {
  final String? title,
      roomCreator,
      token,
      agenda,
      imageUrl,
      dateTime,
      id,
      lastTime,adTitle,adDescription,redirectLink,imageUrl2;
  final int? participantsCount, speakersCount;

  Room({
    this.title,
    this.participantsCount,
    this.speakersCount,
    // this.users,
    this.roomCreator,
    this.token,
    this.agenda,
    this.imageUrl,
    this.dateTime,
    this.id,
    this.lastTime,
    this.adTitle,
    this.adDescription,
    this.redirectLink,
    this.imageUrl2
  });

  factory Room.fromJson(json) {
    return Room(
      title: json['title'],
      participantsCount: json['participantsCount'],
      speakersCount: json['speakersCount'],
      roomCreator: json['roomCreator'],
      token: json['token'],
      agenda: json['agenda'],
      imageUrl: json['image'],
      dateTime: json['dateTime'],
      id: json['id'],
      lastTime: json['lastTime'],
      adTitle:json['adTitle'],
      adDescription:json['adDescription'],
      redirectLink:json['redirectLink'],
      imageUrl2:json['imageUrl2'],
    );
  }
}