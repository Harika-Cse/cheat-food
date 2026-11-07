class AddressModel {
  final String id;
  final String userId;
  final String label; // 'Home', 'Work', 'Other'
  final String recipientName;
  final String recipientPhone;
  final String houseFlatBlock;
  final String areaColonyStreet;
  final String? landmark;
  final String city;
  final String pincode;
  final bool isDefault;
  final double? latitude;
  final double? longitude;

  const AddressModel({
    required this.id,
    required this.userId,
    this.label = 'Home',
    required this.recipientName,
    required this.recipientPhone,
    required this.houseFlatBlock,
    required this.areaColonyStreet,
    this.landmark,
    this.city = 'Delhi',
    required this.pincode,
    this.isDefault = false,
    this.latitude,
    this.longitude,
  });

  String get fullAddress {
    final parts = [
      houseFlatBlock,
      areaColonyStreet,
      if (landmark != null && landmark!.isNotEmpty) 'Near $landmark',
      city,
      pincode,
    ];
    return parts.join(', ');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'label': label,
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
      'houseFlatBlock': houseFlatBlock,
      'areaColonyStreet': areaColonyStreet,
      'landmark': landmark,
      'city': city,
      'pincode': pincode,
      'isDefault': isDefault,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return AddressModel(
      id: id ?? map['id'] ?? '',
      userId: map['userId'] ?? '',
      label: map['label'] ?? 'Home',
      recipientName: map['recipientName'] ?? '',
      recipientPhone: map['recipientPhone'] ?? '',
      houseFlatBlock: map['houseFlatBlock'] ?? '',
      areaColonyStreet: map['areaColonyStreet'] ?? '',
      landmark: map['landmark'],
      city: map['city'] ?? 'Delhi',
      pincode: map['pincode'] ?? '',
      isDefault: map['isDefault'] ?? false,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
    );
  }

  AddressModel copyWith({
    String? label,
    String? recipientName,
    String? recipientPhone,
    String? houseFlatBlock,
    String? areaColonyStreet,
    String? landmark,
    String? city,
    String? pincode,
    bool? isDefault,
    double? latitude,
    double? longitude,
  }) {
    return AddressModel(
      id: id,
      userId: userId,
      label: label ?? this.label,
      recipientName: recipientName ?? this.recipientName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      houseFlatBlock: houseFlatBlock ?? this.houseFlatBlock,
      areaColonyStreet: areaColonyStreet ?? this.areaColonyStreet,
      landmark: landmark ?? this.landmark,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      isDefault: isDefault ?? this.isDefault,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
