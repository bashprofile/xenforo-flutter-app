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
  String custom_title;
  bool is_admin;
  int solutions;
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
      this.custom_title,
      this.is_admin,
      this.about,
      this.solutions});
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
        custom_title: json['custom_title'],
        is_admin: json['is_admin'],
        solutions: json['CMTV_QT_best_answer_count']);
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
    this.custom_title = map['custom_title'];
    this.avatar_urls = map['avatar_urls'];
    this.is_admin = map['is_admin'];
    this.solutions = map['CMTV_QT_best_answer_count'];
  }
}
