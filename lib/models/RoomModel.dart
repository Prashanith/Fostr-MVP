class Room {
  final String? title, roomCreator, token, agenda, imageUrl, dateTime;
  final int? participantsCount, speakersCount;

  Room(
      {this.title,
      this.participantsCount,
      this.speakersCount,
      // this.users,
      this.roomCreator,
      this.token,
      this.agenda,
      this.imageUrl,
      this.dateTime});

  factory Room.fromJson(json) {
    return Room(
      title: json['title'],
      participantsCount: json['participantsCount'],
      speakersCount: json['speakersCount'],
      roomCreator: json['roomCreator'],
      token: json['token'],
      agenda: json['agenda'],
      imageUrl: json['image'],
      dateTime: json['dateTime']
    );
  }
}