import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/category_model.dart';
import '../models/food_item_model.dart';
import '../models/vendor_model.dart';
import '../models/order_model.dart';
import '../models/coupon_model.dart';
import '../models/address_model.dart';
import '../models/review_model.dart';
import '../constants/app_constants.dart';
import 'firebase_service.dart';
import 'mock_data_service.dart';

class FirestoreService {
  final FirebaseFirestore? _db =
      FirebaseService.isLive ? FirebaseFirestore.instance : null;
  final MockDataService _mock = MockDataService();

  // --- Categories ---
  Future<List<CategoryModel>> getCategories() async {
    if (FirebaseService.isLive && _db != null) {
      try {
        final snapshot = await _db!
            .collection(AppConstants.categoriesCollection)
            .orderBy('displayOrder')
            .get();
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs
              .map((doc) => CategoryModel.fromMap(doc.data(), id: doc.id))
              .toList();
        }
      } catch (e) {
        debugPrint('[FirestoreService getCategories] $e');
      }
    }
    return _mock.categories;
  }

  // --- Vendors ---
  Future<List<VendorModel>> getVendors() async {
    if (FirebaseService.isLive && _db != null) {
      try {
        final snapshot =
            await _db!.collection(AppConstants.vendorsCollection).get();
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs
              .map((doc) => VendorModel.fromMap(doc.data(), id: doc.id))
              .toList();
        }
      } catch (e) {
        debugPrint('[FirestoreService getVendors] $e');
      }
    }
    return _mock.vendors;
  }

  // --- Food Items ---
  Future<List<FoodItem>> getFoods() async {
    if (FirebaseService.isLive && _db != null) {
      try {
        final snapshot =
            await _db!.collection(AppConstants.foodsCollection).get();
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs
              .map((doc) => FoodItem.fromMap(doc.data(), id: doc.id))
              .toList();
        }
      } catch (e) {
        debugPrint('[FirestoreService getFoods] $e');
      }
    }
    return _mock.foods;
  }

  Future<void> addFoodItem(FoodItem food) async {
    _mock.addFoodItem(food);
    if (FirebaseService.isLive && _db != null) {
      try {
        await _db!
            .collection(AppConstants.foodsCollection)
            .doc(food.id)
            .set(food.toMap());
      } catch (e) {
        debugPrint('[FirestoreService addFoodItem] $e');
      }
    }
  }

  Future<void> updateFoodItem(FoodItem food) async {
    _mock.updateFoodItem(food);
    if (FirebaseService.isLive && _db != null) {
      try {
        await _db!
            .collection(AppConstants.foodsCollection)
            .doc(food.id)
            .update(food.toMap());
      } catch (e) {
        debugPrint('[FirestoreService updateFoodItem] $e');
      }
    }
  }

  Future<void> deleteFoodItem(String foodId) async {
    _mock.deleteFoodItem(foodId);
    if (FirebaseService.isLive && _db != null) {
      try {
        await _db!
            .collection(AppConstants.foodsCollection)
            .doc(foodId)
            .delete();
      } catch (e) {
        debugPrint('[FirestoreService deleteFoodItem] $e');
      }
    }
  }

  Future<void> toggleFoodAvailability(String foodId) async {
    _mock.toggleFoodAvailability(foodId);
    if (FirebaseService.isLive && _db != null) {
      try {
        final doc = await _db!
            .collection(AppConstants.foodsCollection)
            .doc(foodId)
            .get();
        if (doc.exists) {
          final current = doc.data()?['isAvailable'] ?? true;
          await _db!
              .collection(AppConstants.foodsCollection)
              .doc(foodId)
              .update({'isAvailable': !current});
        }
      } catch (e) {
        debugPrint('[FirestoreService toggleFoodAvailability] $e');
      }
    }
  }

  // --- Orders ---
  Future<List<OrderModel>> getOrdersForUser(String userId) async {
    if (FirebaseService.isLive && _db != null) {
      try {
        final snapshot = await _db!
            .collection(AppConstants.ordersCollection)
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .get();
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs
              .map((doc) => OrderModel.fromMap(doc.data(), id: doc.id))
              .toList();
        }
      } catch (e) {
        debugPrint('[FirestoreService getOrdersForUser] $e');
      }
    }
    return _mock.orders;
  }

  Future<List<OrderModel>> getAllOrders() async {
    if (FirebaseService.isLive && _db != null) {
      try {
        final snapshot = await _db!
            .collection(AppConstants.ordersCollection)
            .orderBy('createdAt', descending: true)
            .get();
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs
              .map((doc) => OrderModel.fromMap(doc.data(), id: doc.id))
              .toList();
        }
      } catch (e) {
        debugPrint('[FirestoreService getAllOrders] $e');
      }
    }
    return _mock.orders;
  }

  Future<OrderModel> placeOrder(OrderModel order) async {
    _mock.addOrder(order);
    if (FirebaseService.isLive && _db != null) {
      try {
        await _db!
            .collection(AppConstants.ordersCollection)
            .doc(order.id)
            .set(order.toMap());
      } catch (e) {
        debugPrint('[FirestoreService placeOrder Live] $e');
      }
    }
    return order;
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    _mock.updateOrderStatus(orderId, newStatus);
    if (FirebaseService.isLive && _db != null) {
      try {
        await _db!
            .collection(AppConstants.ordersCollection)
            .doc(orderId)
            .update({'status': newStatus});
      } catch (e) {
        debugPrint('[FirestoreService updateOrderStatus] $e');
      }
    }
  }

  // --- Addresses ---
  Future<List<AddressModel>> getAddresses(String userId) async {
    if (FirebaseService.isLive && _db != null) {
      try {
        final snapshot = await _db!
            .collection(AppConstants.usersCollection)
            .doc(userId)
            .collection(AppConstants.addressesSubcollection)
            .get();
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs
              .map((doc) => AddressModel.fromMap(doc.data(), id: doc.id))
              .toList();
        }
      } catch (e) {
        debugPrint('[FirestoreService getAddresses] $e');
      }
    }
    return _mock.addresses;
  }

  Future<void> saveAddress(AddressModel address) async {
    _mock.addAddress(address);
    if (FirebaseService.isLive && _db != null) {
      try {
        await _db!
            .collection(AppConstants.usersCollection)
            .doc(address.userId)
            .collection(AppConstants.addressesSubcollection)
            .doc(address.id)
            .set(address.toMap());
      } catch (e) {
        debugPrint('[FirestoreService saveAddress] $e');
      }
    }
  }

  Future<void> deleteAddress(String userId, String addressId) async {
    _mock.deleteAddress(addressId);
    if (FirebaseService.isLive && _db != null) {
      try {
        await _db!
            .collection(AppConstants.usersCollection)
            .doc(userId)
            .collection(AppConstants.addressesSubcollection)
            .doc(addressId)
            .delete();
      } catch (e) {
        debugPrint('[FirestoreService deleteAddress] $e');
      }
    }
  }

  // --- Coupons ---
  Future<List<CouponModel>> getCoupons() async {
    if (FirebaseService.isLive && _db != null) {
      try {
        final snapshot =
            await _db!.collection(AppConstants.couponsCollection).get();
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs
              .map((doc) => CouponModel.fromMap(doc.data()))
              .toList();
        }
      } catch (e) {
        debugPrint('[FirestoreService getCoupons] $e');
      }
    }
    return _mock.coupons;
  }

  // --- Reviews ---
  Future<List<ReviewModel>> getReviews(String foodId) async {
    return _mock.getReviewsForFood(foodId);
  }

  Future<void> addReview(ReviewModel review) async {
    _mock.addReview(review);
  }

  // --- Seed Initial Cloud Data Helper ---
  Future<void> seedInitialDataToFirestore() async {
    if (!FirebaseService.isLive || _db == null) return;
    try {
      final batch = _db!.batch();
      for (final cat in _mock.categories) {
        batch.set(
            _db!.collection(AppConstants.categoriesCollection).doc(cat.id),
            cat.toMap());
      }
      for (final v in _mock.vendors) {
        batch.set(
            _db!.collection(AppConstants.vendorsCollection).doc(v.id),
            v.toMap());
      }
      for (final f in _mock.foods) {
        batch.set(
            _db!.collection(AppConstants.foodsCollection).doc(f.id), f.toMap());
      }
      for (final c in _mock.coupons) {
        batch.set(
            _db!.collection(AppConstants.couponsCollection).doc(c.code),
            c.toMap());
      }
      await batch.commit();
      debugPrint('[FirestoreService] Successfully seeded all data to Firestore.');
    } catch (e) {
      debugPrint('[FirestoreService Seed Error] $e');
    }
  }
}
