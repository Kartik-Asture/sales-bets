class Event {
  final String id;
  final String title;
  final String description;
  final String teamAId;
  final String teamBId;
  final DateTime startTime;
  final DateTime endTime;
  final bool isLive;
  final String? streamUrl;
  final String? winnerTeamId;
  final EventStatus status;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.teamAId,
    required this.teamBId,
    required this.startTime,
    required this.endTime,
    this.isLive = false,
    this.streamUrl,
    this.winnerTeamId,
    this.status = EventStatus.upcoming,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'teamAId': teamAId,
      'teamBId': teamBId,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'isLive': isLive,
      'streamUrl': streamUrl,
      'winnerTeamId': winnerTeamId,
      'status': status.name,
    };
  }

  static Event fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? 'Unknown Event',
      description: map['description']?.toString() ?? 'No description available',
      teamAId: map['teamAId']?.toString() ?? '',
      teamBId: map['teamBId']?.toString() ?? '',
      startTime: DateTime.fromMillisecondsSinceEpoch(
        (map['startTime'] as num?)?.toInt() ?? 0,
      ),
      endTime: DateTime.fromMillisecondsSinceEpoch(
        (map['endTime'] as num?)?.toInt() ?? 0,
      ),
      isLive: map['isLive'] as bool? ?? false,
      streamUrl: map['streamUrl']?.toString(),
      winnerTeamId: map['winnerTeamId']?.toString(),
      status: EventStatus.values.firstWhere(
        (e) => e.name == (map['status']?.toString() ?? 'upcoming'),
        orElse: () => EventStatus.upcoming,
      ),
    );
  }
}

enum EventStatus { upcoming, live, completed, cancelled }
