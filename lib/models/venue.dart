class Venue {
  final int? id;
  final String name;
  final String location;
  final String priceRange;
  final int capacity;
  final double rating;
  final List<String> amenities;
  final String description;
  final List<String> imageUrls; // Changed to List<String> for multiple images

  Venue({
    this.id,
    required this.name,
    required this.location,
    required this.priceRange,
    required this.capacity,
    this.rating = 4.0,
    this.amenities = const [],
    this.description = '',
    this.imageUrls = const [], // Multiple image URLs
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'priceRange': priceRange,
      'capacity': capacity,
      'rating': rating,
      'amenities': amenities.join(','),
      'description': description,
      'imageUrls': imageUrls.join(','), // Store as comma-separated string
    };
  }

  static Venue fromMap(Map<String, dynamic> map) {
    return Venue(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      priceRange: map['priceRange'],
      capacity: map['capacity'],
      rating: map['rating']?.toDouble() ?? 4.0,
      amenities: map['amenities']?.split(',') ?? [],
      description: map['description'] ?? '',
      imageUrls: map['imageUrls']?.split(',') ?? [], // Parse from comma-separated string
    );
  }
}
