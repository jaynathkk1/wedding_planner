class Guest {
  final int? id;
  final String name;
  final String? email;
  final String? phone;
  final String rsvpStatus; // 'pending', 'accepted', 'declined'
  final String category; // 'family', 'friends', 'colleagues'

  Guest({
    this.id,
    required this.name,
    this.email,
    this.phone,
    this.rsvpStatus = 'pending',
    this.category = 'friends',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'rsvpStatus': rsvpStatus,
      'category': category,
    };
  }

  static Guest fromMap(Map<String, dynamic> map) {
    return Guest(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      rsvpStatus: map['rsvpStatus'] ?? 'pending',
      category: map['category'] ?? 'friends',
    );
  }

  Guest copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? rsvpStatus,
    String? category,
  }) {
    return Guest(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      rsvpStatus: rsvpStatus ?? this.rsvpStatus,
      category: category ?? this.category,
    );
  }
}
