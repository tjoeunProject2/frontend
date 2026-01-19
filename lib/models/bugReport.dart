class BugReport {
  final String category;
  final String name;
  final String email;
  final String title;
  final String description;
  final DateTime timestamp;

  BugReport({
    required this.category,
    required this.name,
    required this.email,
    required this.title,
    required this.description,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  // JSON 직렬화 (API 전송용)
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'name': name,
      'email': email,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // JSON 역직렬화 (API 응답 파싱용)
  factory BugReport.fromJson(Map<String, dynamic> json) {
    return BugReport(
      category: json['category'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // 이메일 본문 생성
  String toEmailBody() {
    return '''
문의 유형: $category

이름: $name
이메일: $email

제목: $title

상세 내용:
$description

---
Florit 앱에서 전송됨
전송 시각: ${timestamp.toString()}
''';
  }

  // copyWith 메서드 (필요 시 사용)
  BugReport copyWith({
    String? category,
    String? name,
    String? email,
    String? title,
    String? description,
    DateTime? timestamp,
  }) {
    return BugReport(
      category: category ?? this.category,
      name: name ?? this.name,
      email: email ?? this.email,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
