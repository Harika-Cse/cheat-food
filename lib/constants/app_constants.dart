class AppConstants {
  static const String appName = 'Cheat Food';
  static const String appTagline = 'Indian Street Food, Straight to Your Soul';
  static const String appVersion = '1.0.0';

  // Currency
  static const String currencySymbol = '₹';

  // Financial Defaults (Indian Street Food Economics)
  static const double freeDeliveryThreshold = 199.0;
  static const double standardDeliveryFee = 35.0;
  static const double restaurantPackagingFee = 15.0;
  static const double gstRate = 0.05; // 5% GST

  // Firestore Collection Names
  static const String usersCollection = 'users';
  static const String foodsCollection = 'foods';
  static const String categoriesCollection = 'categories';
  static const String vendorsCollection = 'vendors';
  static const String ordersCollection = 'orders';
  static const String reviewsCollection = 'reviews';
  static const String couponsCollection = 'coupons';
  static const String addressesSubcollection = 'addresses';
  static const String favoritesSubcollection = 'favorites';

  // Category Identifiers
  static const String catChaat = 'chaat';
  static const String catSnacks = 'snacks';
  static const String catSouthIndian = 'south_indian';
  static const String catMumbai = 'mumbai_street';
  static const String catNorthIndian = 'north_indian';
  static const String catRollsMomos = 'rolls_momos';
  static const String catBeverages = 'beverages';

  // Order Statuses
  static const String statusPlaced = 'Placed';
  static const String statusConfirmed = 'Confirmed';
  static const String statusPreparing = 'Preparing';
  static const String statusOutForDelivery = 'Out for Delivery';
  static const String statusDelivered = 'Delivered';
  static const String statusCancelled = 'Cancelled';

  static const List<String> orderStatuses = [
    statusPlaced,
    statusConfirmed,
    statusPreparing,
    statusOutForDelivery,
    statusDelivered,
    statusCancelled,
  ];

  // Spice Levels
  static const String spiceMild = 'Mild';
  static const String spiceMedium = 'Medium';
  static const String spiceFiery = 'Fiery Spicy';

  static const List<String> spiceLevels = [
    spiceMild,
    spiceMedium,
    spiceFiery,
  ];

  // User Roles
  static const String roleCustomer = 'customer';
  static const String roleAdmin = 'admin';
  static const String roleVendor = 'vendor';
}
