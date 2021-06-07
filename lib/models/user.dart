class User {
  String username;
  String about;
  int registerDate;
  int lastSeen;
  int id;
  int reactionScore;
  int messageCount;
  dynamic custom_fields;
  bool can_converse;
  dynamic avatar_urls;
  int question_solution_count;
  User(
      {this.question_solution_count,
      this.username,
      this.registerDate,
      this.id,
      this.reactionScore,
      this.messageCount,
      this.lastSeen,
      this.can_converse,
      this.custom_fields,
      this.avatar_urls,
      this.about});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      question_solution_count: json['question_solution_count'],
      username: json['username'],
      registerDate: json['register_date'],
      id: json['user_id'],
      reactionScore: json['reaction_score'],
      messageCount: json['message_count'],
      lastSeen: json['last_activity'],
      about: json['about'],
      can_converse: json['can_converse'],
      custom_fields: json['custom_fields'],
      avatar_urls: json['avatar_urls'],
    );
  }
  User.fromMap(Map<String, dynamic> map) {
    print(map);
    this.question_solution_count = map['question_solution_count'];
    this.username = map['username'];
    this.registerDate = map['register_date'];
    this.id = map['user_id'];
    this.reactionScore = map['reaction_score'];
    this.messageCount = map['message_count'];
    this.lastSeen = map['last_activity'];
    this.about = map['about'];
    this.can_converse = map['can_converse'];
    this.custom_fields = map['custom_fields'];
    this.avatar_urls = map['avatar_urls'];
  }
}
