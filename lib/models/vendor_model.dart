class VendorModel {
  final String id;
  final String name;
  final String address;
  final String locality;
  final String city;
  final double rating;
  final int ratingCount;
  final String imageUrl;
  final String phone;
  final bool isOpen;
  final String speciality;
  final double? latitude;
  final double? longitude;

  const VendorModel({
    required this.id,
    required this.name,
    required this.address,
    required this.locality,
    this.city = 'Delhi / Mumbai / Bangalore',
    this.rating = 4.6,
    this.ratingCount = 150,
    required this.imageUrl,
    required this.phone,
    this.isOpen = true,
    required this.speciality,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'locality': locality,
      'city': city,
      'rating': rating,
      'ratingCount': ratingCount,
      'imageUrl': imageUrl,
      'phone': phone,
      'isOpen': isOpen,
      'speciality': speciality,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory VendorModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return VendorModel(
      id: id ?? map['id'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      locality: map['locality'] ?? '',
      city: map['city'] ?? 'Delhi / Mumbai / Bangalore',
      rating: (map['rating'] as num?)?.toDouble() ?? 4.6,
      ratingCount: (map['ratingCount'] as num?)?.toInt() ?? 100,
      imageUrl: map['imageUrl'] ?? '',
      phone: map['phone'] ?? '',
      isOpen: map['isOpen'] ?? true,
      speciality: map['speciality'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
    );
  }

  VendorModel copyWith({
    String? name,
    String? address,
    String? locality,
    String? city,
    double? rating,
    int? ratingCount,
    String? imageUrl,
    String? phone,
    bool? isOpen,
    String? speciality,
    double? latitude,
    double? longitude,
  }) {
    return VendorModel(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
      locality: locality ?? this.locality,
      city: city ?? this.city,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      imageUrl: imageUrl ?? this.imageUrl,
      phone: phone ?? this.phone,
      isOpen: isOpen ?? this.isOpen,
      speciality: speciality ?? this.speciality,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
