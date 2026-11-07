import 'package:flutter/material.dart';
import '../models/address_model.dart';
import '../services/firestore_service.dart';

class LocationProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<AddressModel> _addresses = [];
  AddressModel? _selectedAddress;
  bool _isLoading = false;

  List<AddressModel> get addresses => _addresses;
  AddressModel? get selectedAddress => _selectedAddress;
  bool get isLoading => _isLoading;

  String get displayAddressLabel {
    if (_selectedAddress != null) {
      return '${_selectedAddress!.label}: ${_selectedAddress!.areaColonyStreet}, ${_selectedAddress!.city}';
    }
    return 'Select Delivery Address';
  }

  Future<void> loadAddresses(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _addresses = await _firestoreService.getAddresses(userId);
      if (_addresses.isNotEmpty) {
        _selectedAddress = _addresses.firstWhere(
          (a) => a.isDefault,
          orElse: () => _addresses.first,
        );
      }
    } catch (e) {
      debugPrint('[LocationProvider Error] $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectAddress(AddressModel address) {
    _selectedAddress = address;
    notifyListeners();
  }

  Future<void> addAddress(AddressModel address) async {
    _isLoading = true;
    notifyListeners();

    await _firestoreService.saveAddress(address);
    if (address.isDefault) {
      for (int i = 0; i < _addresses.length; i++) {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
      _selectedAddress = address;
    }
    _addresses.add(address);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateAddress(AddressModel address) async {
    _isLoading = true;
    notifyListeners();

    await _firestoreService.saveAddress(address);
    final idx = _addresses.indexWhere((a) => a.id == address.id);
    if (idx != -1) {
      if (address.isDefault) {
        for (int i = 0; i < _addresses.length; i++) {
          _addresses[i] = _addresses[i].copyWith(isDefault: false);
        }
        _selectedAddress = address;
      }
      _addresses[idx] = address;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteAddress(String userId, String addressId) async {
    _isLoading = true;
    notifyListeners();

    await _firestoreService.deleteAddress(userId, addressId);
    _addresses.removeWhere((a) => a.id == addressId);
    if (_selectedAddress?.id == addressId) {
      _selectedAddress = _addresses.isNotEmpty ? _addresses.first : null;
    }
    _isLoading = false;
    notifyListeners();
  }
}
