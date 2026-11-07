import 'dart:async';
import '../models/category_model.dart';
import '../models/food_item_model.dart';
import '../models/vendor_model.dart';
import '../models/coupon_model.dart';
import '../models/order_model.dart';
import '../models/address_model.dart';
import '../models/review_model.dart';
import '../constants/app_constants.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal() {
    _initializeData();
  }

  final List<CategoryModel> _categories = [];
  final List<VendorModel> _vendors = [];
  final List<FoodItem> _foods = [];
  final List<CouponModel> _coupons = [];
  final List<OrderModel> _orders = [];
  final List<AddressModel> _addresses = [];
  final Map<String, List<ReviewModel>> _reviews = {};
  final Set<String> _favoriteIds = {'food_pani_puri', 'food_vada_pav', 'food_chole_bhature'};

  List<CategoryModel> get categories => List.unmodifiable(_categories);
  List<VendorModel> get vendors => List.unmodifiable(_vendors);
  List<FoodItem> get foods => List.unmodifiable(_foods);
  List<CouponModel> get coupons => List.unmodifiable(_coupons);
  List<OrderModel> get orders => List.unmodifiable(_orders);
  List<AddressModel> get addresses => List.unmodifiable(_addresses);
  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  void _initializeData() {
    // 1. Categories
    _categories.addAll([
      const CategoryModel(
        id: AppConstants.catChaat,
        name: 'Chaat',
        description: 'Tangy, spicy, crispy bursts of authentic street flavours',
        iconEmoji: '🍲',
        imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=600&q=80',
        displayOrder: 1,
      ),
      const CategoryModel(
        id: AppConstants.catMumbai,
        name: 'Mumbai Street Food',
        description: 'Iconic spicy pavs, bhajis, and misal from the streets of Mumbai',
        iconEmoji: '🍔',
        imageUrl: 'https://images.unsplash.com/photo-1606491956689-2ea866880c84?auto=format&fit=crop&w=600&q=80',
        displayOrder: 2,
      ),
      const CategoryModel(
        id: AppConstants.catNorthIndian,
        name: 'North Indian Street Food',
        description: 'Rich, wholesome chole bhature, parathas & kulchas',
        iconEmoji: '🥘',
        imageUrl: 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=600&q=80',
        displayOrder: 3,
      ),
      const CategoryModel(
        id: AppConstants.catSouthIndian,
        name: 'South Indian Street Food',
        description: 'Crispy dosas, fluffy idlis, and golden vadas with coconut chutney',
        iconEmoji: '🥞',
        imageUrl: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
        displayOrder: 4,
      ),
      const CategoryModel(
        id: AppConstants.catSnacks,
        name: 'Snacks & Pakodas',
        description: 'Freshly fried hot samosas, kachoris, and crunchy pakodas',
        iconEmoji: '🥟',
        imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=600&q=80',
        displayOrder: 5,
      ),
      const CategoryModel(
        id: AppConstants.catRollsMomos,
        name: 'Rolls & Momos',
        description: 'Steaming street momos and spicy layered kathi rolls',
        iconEmoji: '🌯',
        imageUrl: 'https://images.unsplash.com/photo-1625220194771-7ebdea0b70b9?auto=format&fit=crop&w=600&q=80',
        displayOrder: 6,
      ),
      const CategoryModel(
        id: AppConstants.catBeverages,
        name: 'Street Beverages',
        description: 'Cooling sugarcane juice, cutting chai, spicy masala sodas & lassi',
        iconEmoji: '🥤',
        imageUrl: 'https://images.unsplash.com/photo-1546173159-315724a31696?auto=format&fit=crop&w=600&q=80',
        displayOrder: 7,
      ),
    ]);

    // 2. Vendors
    _vendors.addAll([
      const VendorModel(
        id: 'vendor_sharma_chaat',
        name: 'Sharma Chaat Bhandar',
        address: 'Shop 14, Chandni Chowk, Old Delhi',
        locality: 'Chandni Chowk',
        city: 'Delhi',
        rating: 4.8,
        ratingCount: 380,
        imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=600&q=80',
        phone: '+91 98110 23456',
        speciality: 'Pani Puri & Aloo Tikki',
        latitude: 28.6562,
        longitude: 77.2310,
      ),
      const VendorModel(
        id: 'vendor_sardar_pav_bhaji',
        name: 'Sardar Pav Bhaji Center',
        address: '166-A, Tardeo Road, Mumbai',
        locality: 'Tardeo',
        city: 'Mumbai',
        rating: 4.9,
        ratingCount: 520,
        imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=600&q=80',
        phone: '+91 98201 98765',
        speciality: 'Amul Butter Pav Bhaji & Vada Pav',
        latitude: 18.9712,
        longitude: 72.8155,
      ),
      const VendorModel(
        id: 'vendor_anand_dosa',
        name: 'Anand Tiffin & Dosa Stall',
        address: '8th Cross, Sampige Road, Malleswaram',
        locality: 'Malleswaram',
        city: 'Bangalore',
        rating: 4.7,
        ratingCount: 290,
        imageUrl: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=600&q=80',
        phone: '+91 94480 12345',
        speciality: 'Crispy Benne Masala Dosa & Podi Idli',
        latitude: 13.0031,
        longitude: 77.5700,
      ),
      const VendorModel(
        id: 'vendor_kolkata_rolls',
        name: 'Kolkata Kathi Roll Junction',
        address: '42, Park Street Near Camac St',
        locality: 'Park Street',
        city: 'Kolkata',
        rating: 4.6,
        ratingCount: 240,
        imageUrl: 'https://images.unsplash.com/photo-1559339352-11d035aa65de?auto=format&fit=crop&w=600&q=80',
        phone: '+91 98300 54321',
        speciality: 'Flaky Egg & Paneer Kathi Rolls',
        latitude: 22.5510,
        longitude: 88.3526,
      ),
      const VendorModel(
        id: 'vendor_punjab_rasoi',
        name: 'Amritsari Chole Kulche Corner',
        address: 'Near Town Hall, Amritsar',
        locality: 'Heritage Street',
        city: 'Amritsar',
        rating: 4.9,
        ratingCount: 460,
        imageUrl: 'https://images.unsplash.com/photo-1543007630-9710e4a00a20?auto=format&fit=crop&w=600&q=80',
        phone: '+91 98150 78901',
        speciality: 'Stuffed Chur Chur Kulcha & Chole',
        latitude: 31.6200,
        longitude: 74.8765,
      ),
      const VendorModel(
        id: 'vendor_banaras_refreshment',
        name: 'Banaras Lassi & Juice Hub',
        address: 'Near Godowlia Chowk, Varanasi',
        locality: 'Godowlia',
        city: 'Varanasi',
        rating: 4.8,
        ratingCount: 310,
        imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=600&q=80',
        phone: '+91 94500 11223',
        speciality: 'Malai Rabdi Lassi & Fresh Sugarcane Juice',
        latitude: 25.3109,
        longitude: 83.0104,
      ),
    ]);

    // 3. Street Food Items (Authentic Indian Street Foods)
    _foods.addAll([
      // CHAAT
      FoodItem(
        id: 'food_pani_puri',
        name: 'Gol Gappe / Pani Puri (6 Pcs)',
        description: 'Crispy hollow puris loaded with spiced mashed potatoes, black chickpeas, sweet tamarind chutney, and fiery mint-coriander water.',
        categoryId: AppConstants.catChaat,
        categoryName: 'Chaat',
        price: 60.0,
        discountPrice: 49.0,
        imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceFiery,
        vendorId: 'vendor_sharma_chaat',
        vendorName: 'Sharma Chaat Bhandar',
        rating: 4.9,
        ratingCount: 340,
        preparationTimeMinutes: 10,
        isBestSeller: true,
        isTrending: true,
        isRecommended: true,
        customizations: const [
          FoodCustomization(
            title: 'Water Choice',
            isMultipleChoice: false,
            isRequired: true,
            options: [
              FoodCustomizationOption(name: 'Teekha (Spicy Mint Water)', extraPrice: 0),
              FoodCustomizationOption(name: 'Meetha (Sweet Tamarind Water)', extraPrice: 0),
              FoodCustomizationOption(name: 'Mixed (Khatta Meetha Balance)', extraPrice: 0),
              FoodCustomizationOption(name: 'Hing Jeera Special Water', extraPrice: 5),
            ],
          ),
          FoodCustomization(
            title: 'Add-ons',
            isMultipleChoice: true,
            options: [
              FoodCustomizationOption(name: 'Extra 2 Sukha Puris', extraPrice: 15),
              FoodCustomizationOption(name: 'Extra Sweet Chutney Cup', extraPrice: 10),
            ],
          ),
        ],
      ),
      FoodItem(
        id: 'food_bhel_puri',
        name: 'Mumbai Chowpatty Bhel Puri',
        description: 'Crispy puffed rice tossed with sev, boiled potatoes, chopped onions, raw mango slices, spicy green chutney, and zesty lemon juice.',
        categoryId: AppConstants.catChaat,
        categoryName: 'Chaat',
        price: 70.0,
        discountPrice: null,
        imageUrl: 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceMedium,
        vendorId: 'vendor_sharma_chaat',
        vendorName: 'Sharma Chaat Bhandar',
        rating: 4.7,
        ratingCount: 180,
        preparationTimeMinutes: 8,
        isBestSeller: false,
        isTrending: true,
        isRecommended: false,
        customizations: const [
          FoodCustomization(
            title: 'Style',
            options: [
              FoodCustomizationOption(name: 'Geela Bhel (With tangy chutney)', extraPrice: 0),
              FoodCustomizationOption(name: 'Sukha Bhel (Dry & super crunchy)', extraPrice: 0),
            ],
          ),
        ],
      ),
      FoodItem(
        id: 'food_aloo_tikki',
        name: 'Kurkuri Dahi Aloo Tikki Chaat',
        description: 'Golden shallow-fried spiced potato patties served over creamy chilled sweetened curd, topped with tamarind sauce, mint chutney, roasted cumin, and pomegranate.',
        categoryId: AppConstants.catChaat,
        categoryName: 'Chaat',
        price: 90.0,
        discountPrice: 79.0,
        imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceMedium,
        vendorId: 'vendor_sharma_chaat',
        vendorName: 'Sharma Chaat Bhandar',
        rating: 4.8,
        ratingCount: 220,
        preparationTimeMinutes: 12,
        isBestSeller: true,
        isTrending: false,
        isRecommended: true,
        customizations: const [
          FoodCustomization(
            title: 'Extra Toppings',
            isMultipleChoice: true,
            options: [
              FoodCustomizationOption(name: 'Extra Thick Sweet Dahi', extraPrice: 15),
              FoodCustomizationOption(name: 'Nylon Sev & Beetroot Garnish', extraPrice: 10),
            ],
          ),
        ],
      ),
      FoodItem(
        id: 'food_papdi_chaat',
        name: 'Old Delhi Dahi Papdi Chaat',
        description: 'Crisp fried flour crackers piled high with potatoes, chickpeas, whipped yoghurt, red chilli powder, chaat masala, and fresh coriander.',
        categoryId: AppConstants.catChaat,
        categoryName: 'Chaat',
        price: 85.0,
        imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceMild,
        vendorId: 'vendor_sharma_chaat',
        vendorName: 'Sharma Chaat Bhandar',
        rating: 4.7,
        ratingCount: 160,
        preparationTimeMinutes: 10,
        isBestSeller: false,
        isTrending: false,
        isRecommended: true,
      ),

      // MUMBAI STREET FOOD
      FoodItem(
        id: 'food_vada_pav',
        name: 'Classic Mumbai Vada Pav (2 Pcs)',
        description: 'The heartbeat of Mumbai! Batata vada with spicy garlic dry chutney and fried green chillies tucked inside butter-toasted ladi pav.',
        categoryId: AppConstants.catMumbai,
        categoryName: 'Mumbai Street Food',
        price: 50.0,
        discountPrice: 40.0,
        imageUrl: 'https://images.unsplash.com/photo-1606491956689-2ea866880c84?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceFiery,
        vendorId: 'vendor_sardar_pav_bhaji',
        vendorName: 'Sardar Pav Bhaji Center',
        rating: 4.9,
        ratingCount: 650,
        preparationTimeMinutes: 10,
        isBestSeller: true,
        isTrending: true,
        isRecommended: true,
        customizations: const [
          FoodCustomization(
            title: 'Pav Variation',
            options: [
              FoodCustomizationOption(name: 'Regular Amul Butter Toast', extraPrice: 0),
              FoodCustomizationOption(name: 'Cheese Burst Vada Pav', extraPrice: 25),
              FoodCustomizationOption(name: 'Schezwan Mayo Vada Pav', extraPrice: 15),
            ],
          ),
          FoodCustomization(
            title: 'Chilli Preference',
            options: [
              FoodCustomizationOption(name: '2 Salted Fried Green Chillies', extraPrice: 0),
              FoodCustomizationOption(name: 'Extra Lahsun Chutney Powder', extraPrice: 10),
            ],
          ),
        ],
      ),
      FoodItem(
        id: 'food_pav_bhaji',
        name: 'Special Amul Butter Pav Bhaji',
        description: 'Thick, rich, spiced vegetable mash simmered on an open tawa with heaps of melted Amul butter, served with two buttery pavs, chopped onions, and lime.',
        categoryId: AppConstants.catMumbai,
        categoryName: 'Mumbai Street Food',
        price: 150.0,
        discountPrice: 135.0,
        imageUrl: 'https://images.unsplash.com/photo-1606491956689-2ea866880c84?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceMedium,
        vendorId: 'vendor_sardar_pav_bhaji',
        vendorName: 'Sardar Pav Bhaji Center',
        rating: 4.9,
        ratingCount: 480,
        preparationTimeMinutes: 15,
        isBestSeller: true,
        isTrending: true,
        isRecommended: true,
        customizations: const [
          FoodCustomization(
            title: 'Cheese Level',
            options: [
              FoodCustomizationOption(name: 'Original Butter Pav Bhaji', extraPrice: 0),
              FoodCustomizationOption(name: 'Loaded Amul Cheese Grate', extraPrice: 35),
            ],
          ),
          FoodCustomization(
            title: 'Extra Pavs',
            options: [
              FoodCustomizationOption(name: 'Extra Pair of Butter Pav (2 Pcs)', extraPrice: 25),
            ],
          ),
        ],
      ),
      FoodItem(
        id: 'food_misal_pav',
        name: 'Kolhapuri Teekha Misal Pav',
        description: 'Fiery sprouted bean curry bathed in red kat/rassa, layered with crispy farsan, fresh onions, coriander, served with fresh pav.',
        categoryId: AppConstants.catMumbai,
        categoryName: 'Mumbai Street Food',
        price: 110.0,
        imageUrl: 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceFiery,
        vendorId: 'vendor_sardar_pav_bhaji',
        vendorName: 'Sardar Pav Bhaji Center',
        rating: 4.8,
        ratingCount: 190,
        preparationTimeMinutes: 12,
        isBestSeller: false,
        isTrending: true,
        isRecommended: false,
      ),

      // NORTH INDIAN STREET FOOD
      FoodItem(
        id: 'food_chole_bhature',
        name: 'Amritsari Pindi Chole Bhature (2 Pcs)',
        description: 'Balloon-fluffy, golden bhature served with deeply spiced dark Pindi chole, pickled amla, raw onions, and tangy mint chutney.',
        categoryId: AppConstants.catNorthIndian,
        categoryName: 'North Indian Street Food',
        price: 140.0,
        discountPrice: 120.0,
        imageUrl: 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceMedium,
        vendorId: 'vendor_punjab_rasoi',
        vendorName: 'Amritsari Chole Kulche Corner',
        rating: 4.9,
        ratingCount: 510,
        preparationTimeMinutes: 15,
        isBestSeller: true,
        isTrending: true,
        isRecommended: true,
        customizations: const [
          FoodCustomization(
            title: 'Bhatura Type',
            options: [
              FoodCustomizationOption(name: 'Classic Fluffy Bhatura', extraPrice: 0),
              FoodCustomizationOption(name: 'Paneer Stuffed Bhatura', extraPrice: 30),
            ],
          ),
          FoodCustomization(
            title: 'Beverage Pairing',
            options: [
              FoodCustomizationOption(name: 'Add Sweet Patiala Lassi', extraPrice: 40),
            ],
          ),
        ],
      ),
      FoodItem(
        id: 'food_aloo_paratha',
        name: 'Dhaba Style Aloo Pyaaz Paratha',
        description: 'Tandoor-crisped flatbread stuffed with spiced mashed potatoes, ginger, and green chillies, crowned with white homemade butter.',
        categoryId: AppConstants.catNorthIndian,
        categoryName: 'North Indian Street Food',
        price: 95.0,
        imageUrl: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceMedium,
        vendorId: 'vendor_punjab_rasoi',
        vendorName: 'Amritsari Chole Kulche Corner',
        rating: 4.7,
        ratingCount: 160,
        preparationTimeMinutes: 15,
        isBestSeller: false,
        isTrending: false,
        isRecommended: true,
      ),

      // SOUTH INDIAN STREET FOOD
      FoodItem(
        id: 'food_masala_dosa',
        name: 'Crispy Butter Masala Dosa',
        description: 'Golden fermented rice crepe smeared with fiery red garlic chutney, filled with fragrant potato masala, served with piping hot sambar & fresh coconut chutney.',
        categoryId: AppConstants.catSouthIndian,
        categoryName: 'South Indian Street Food',
        price: 110.0,
        discountPrice: 95.0,
        imageUrl: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceMedium,
        vendorId: 'vendor_anand_dosa',
        vendorName: 'Anand Tiffin & Dosa Stall',
        rating: 4.9,
        ratingCount: 420,
        preparationTimeMinutes: 12,
        isBestSeller: true,
        isTrending: true,
        isRecommended: true,
        customizations: const [
          FoodCustomization(
            title: 'Dosa Style',
            options: [
              FoodCustomizationOption(name: 'Traditional Butter Masala', extraPrice: 0),
              FoodCustomizationOption(name: 'Mysore Cheese Masala Dosa', extraPrice: 30),
              FoodCustomizationOption(name: 'Guntur Podi Ghee Dosa', extraPrice: 20),
            ],
          ),
        ],
      ),
      FoodItem(
        id: 'food_idli_sambar',
        name: 'Button Ghee Podi Idlis (12 Pcs)',
        description: 'Mini steamed rice cakes tossed in aromatic gunpowder spice (podi) and desi ghee, accompanied by tomato chutney and drumstick sambar.',
        categoryId: AppConstants.catSouthIndian,
        categoryName: 'South Indian Street Food',
        price: 80.0,
        imageUrl: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceMild,
        vendorId: 'vendor_anand_dosa',
        vendorName: 'Anand Tiffin & Dosa Stall',
        rating: 4.8,
        ratingCount: 210,
        preparationTimeMinutes: 8,
        isBestSeller: false,
        isTrending: false,
        isRecommended: true,
      ),
      FoodItem(
        id: 'food_mysore_bonda',
        name: 'Hot Mysore Bonda with Chutney (4 Pcs)',
        description: 'Crispy outer shell, cloud-soft inside fried dumplings made with yoghurt, ginger, cumin, and curry leaves.',
        categoryId: AppConstants.catSouthIndian,
        categoryName: 'South Indian Street Food',
        price: 65.0,
        imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceMedium,
        vendorId: 'vendor_anand_dosa',
        vendorName: 'Anand Tiffin & Dosa Stall',
        rating: 4.6,
        ratingCount: 130,
        preparationTimeMinutes: 10,
      ),

      // SNACKS & PAKODAS
      FoodItem(
        id: 'food_samosa',
        name: 'Punjabi Aloo Samosa (2 Pcs)',
        description: 'Crisp pastry triangles stuffed with spiced potatoes, green peas, cashews, and freshly ground garam masala, served with imli chutney.',
        categoryId: AppConstants.catSnacks,
        categoryName: 'Snacks & Pakodas',
        price: 40.0,
        discountPrice: 30.0,
        imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceMedium,
        vendorId: 'vendor_sharma_chaat',
        vendorName: 'Sharma Chaat Bhandar',
        rating: 4.9,
        ratingCount: 390,
        preparationTimeMinutes: 8,
        isBestSeller: true,
        isTrending: true,
        isRecommended: true,
      ),
      FoodItem(
        id: 'food_mirchi_bajji',
        name: 'Andhra Mirchi Bajji (4 Pcs)',
        description: 'Large mild green chillies stuffed with tangy ajwain and tamarind pulp, dipped in spiced chickpea batter and golden fried.',
        categoryId: AppConstants.catSnacks,
        categoryName: 'Snacks & Pakodas',
        price: 55.0,
        imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceFiery,
        vendorId: 'vendor_sharma_chaat',
        vendorName: 'Sharma Chaat Bhandar',
        rating: 4.7,
        ratingCount: 140,
        preparationTimeMinutes: 10,
      ),
      FoodItem(
        id: 'food_onion_pakoda',
        name: 'Kanda / Onion Pakoda (Plate)',
        description: 'Ultra-crunchy sliced onion fritters seasoned with carom seeds, ginger, and curry leaves. Best street food companion for monsoon evenings.',
        categoryId: AppConstants.catSnacks,
        categoryName: 'Snacks & Pakodas',
        price: 60.0,
        imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceMedium,
        vendorId: 'vendor_sardar_pav_bhaji',
        vendorName: 'Sardar Pav Bhaji Center',
        rating: 4.8,
        ratingCount: 195,
        preparationTimeMinutes: 10,
        isBestSeller: false,
        isTrending: false,
        isRecommended: true,
      ),

      // ROLLS & MOMOS
      FoodItem(
        id: 'food_veg_momos',
        name: 'Steamed Himalayan Veg Momos (8 Pcs)',
        description: 'Delicate dumplings stuffed with minced cabbage, carrots, spring onions, and garlic, served with fiery red chilli dipping sauce.',
        categoryId: AppConstants.catRollsMomos,
        categoryName: 'Rolls & Momos',
        price: 90.0,
        discountPrice: 79.0,
        imageUrl: 'https://images.unsplash.com/photo-1625220194771-7ebdea0b70b9?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceFiery,
        vendorId: 'vendor_kolkata_rolls',
        vendorName: 'Kolkata Kathi Roll Junction',
        rating: 4.8,
        ratingCount: 310,
        preparationTimeMinutes: 12,
        isBestSeller: true,
        isTrending: true,
        isRecommended: true,
        customizations: const [
          FoodCustomization(
            title: 'Preparation',
            options: [
              FoodCustomizationOption(name: 'Steamed Classic', extraPrice: 0),
              FoodCustomizationOption(name: 'Deep Fried Crunchy Momos', extraPrice: 15),
              FoodCustomizationOption(name: 'Tandoori Kurkure Tossed', extraPrice: 30),
            ],
          ),
        ],
      ),
      FoodItem(
        id: 'food_paneer_roll',
        name: 'Kolkata Paneer Kathi Roll',
        description: 'Layered flaky paratha wrapped around tandoori marinated paneer cubes, crunchy peppers, sliced onions, chaat masala, and spicy green dip.',
        categoryId: AppConstants.catRollsMomos,
        categoryName: 'Rolls & Momos',
        price: 120.0,
        imageUrl: 'https://images.unsplash.com/photo-1625220194771-7ebdea0b70b9?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceMedium,
        vendorId: 'vendor_kolkata_rolls',
        vendorName: 'Kolkata Kathi Roll Junction',
        rating: 4.8,
        ratingCount: 260,
        preparationTimeMinutes: 12,
        isBestSeller: false,
        isTrending: true,
        isRecommended: true,
        customizations: const [
          FoodCustomization(
            title: 'Add Cheese',
            options: [
              FoodCustomizationOption(name: 'Melted Mozzarella Layer', extraPrice: 25),
            ],
          ),
        ],
      ),
      FoodItem(
        id: 'food_egg_roll',
        name: 'Double Egg Street Roll',
        description: 'Paratha crisped on the tawa with two whisked eggs, filled with lime-cured onions, fresh green chillies, and signature roll masala.',
        categoryId: AppConstants.catRollsMomos,
        categoryName: 'Rolls & Momos',
        price: 90.0,
        imageUrl: 'https://images.unsplash.com/photo-1625220194771-7ebdea0b70b9?auto=format&fit=crop&w=800&q=80',
        isVeg: false,
        spiceLevel: AppConstants.spiceMedium,
        vendorId: 'vendor_kolkata_rolls',
        vendorName: 'Kolkata Kathi Roll Junction',
        rating: 4.7,
        ratingCount: 215,
        preparationTimeMinutes: 10,
        isBestSeller: true,
        isTrending: false,
        isRecommended: false,
      ),

      // BEVERAGES
      FoodItem(
        id: 'food_sugarcane_juice',
        name: 'Fresh Cold Sugarcane Juice',
        description: 'Freshly pressed cane juice infused with spicy crushed ginger, fresh mint leaves, black salt, and a generous squeeze of fresh lemon.',
        categoryId: AppConstants.catBeverages,
        categoryName: 'Street Beverages',
        price: 45.0,
        discountPrice: 35.0,
        imageUrl: 'https://images.unsplash.com/photo-1546173159-315724a31696?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceMild,
        vendorId: 'vendor_banaras_refreshment',
        vendorName: 'Banaras Lassi & Juice Hub',
        rating: 4.9,
        ratingCount: 380,
        preparationTimeMinutes: 5,
        isBestSeller: true,
        isTrending: true,
        isRecommended: true,
        customizations: const [
          FoodCustomization(
            title: 'Ice Level',
            options: [
              FoodCustomizationOption(name: 'Chilled with Crushed Ice', extraPrice: 0),
              FoodCustomizationOption(name: 'Without Ice (Pure Extract)', extraPrice: 5),
            ],
          ),
        ],
      ),
      FoodItem(
        id: 'food_masala_soda',
        name: 'Chilled Jeera Masala Soda',
        description: 'Fizzy carbonated street soda mixed with roasted cumin seeds, black salt, amchur, mint syrup, and fresh lime juice.',
        categoryId: AppConstants.catBeverages,
        categoryName: 'Street Beverages',
        price: 40.0,
        imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceMedium,
        vendorId: 'vendor_banaras_refreshment',
        vendorName: 'Banaras Lassi & Juice Hub',
        rating: 4.7,
        ratingCount: 160,
        preparationTimeMinutes: 5,
        isBestSeller: false,
        isTrending: false,
        isRecommended: true,
      ),
      FoodItem(
        id: 'food_mango_lassi',
        name: 'Kesar Mango Malai Lassi',
        description: 'Velvety sweet curd blended with Alphonso mango pulp, fragrant saffron strands, topped with heavy clotted malai and chopped pistachios.',
        categoryId: AppConstants.catBeverages,
        categoryName: 'Street Beverages',
        price: 75.0,
        imageUrl: 'https://images.unsplash.com/photo-1546173159-315724a31696?auto=format&fit=crop&w=800&q=80',
        isVeg: true,
        spiceLevel: AppConstants.spiceMild,
        vendorId: 'vendor_banaras_refreshment',
        vendorName: 'Banaras Lassi & Juice Hub',
        rating: 4.9,
        ratingCount: 420,
        preparationTimeMinutes: 5,
        isBestSeller: true,
        isTrending: true,
        isRecommended: true,
      ),
    ]);

    // 4. Promotional Coupons
    _coupons.addAll([
      const CouponModel(
        code: 'CHEATDAY50',
        title: '50% OFF Street Cravings',
        description: 'Get 50% discount up to ₹100 on orders above ₹149',
        discountType: 'percentage',
        discountValue: 50.0,
        maxDiscountAmount: 100.0,
        minOrderAmount: 149.0,
      ),
      const CouponModel(
        code: 'STREET20',
        title: '20% OFF Everything',
        description: 'Flat 20% off on all street orders above ₹99',
        discountType: 'percentage',
        discountValue: 20.0,
        maxDiscountAmount: 60.0,
        minOrderAmount: 99.0,
      ),
      const CouponModel(
        code: 'FREEDELIVERY',
        title: 'Free Delivery',
        description: 'Zero delivery charges on your order above ₹129',
        discountType: 'free_delivery',
        discountValue: 35.0,
        maxDiscountAmount: 35.0,
        minOrderAmount: 129.0,
      ),
    ]);

    // 5. Saved Addresses
    _addresses.addAll([
      const AddressModel(
        id: 'addr_1',
        userId: 'user_default',
        label: 'Home',
        recipientName: 'Rahul Verma',
        recipientPhone: '+91 98765 43210',
        houseFlatBlock: 'Flat 402, Royal Residency',
        areaColonyStreet: 'Sector 15, Near Metro Gate 2',
        landmark: 'Apollo Pharmacy',
        city: 'Delhi',
        pincode: '110001',
        isDefault: true,
        latitude: 28.6139,
        longitude: 77.2090,
      ),
      const AddressModel(
        id: 'addr_2',
        userId: 'user_default',
        label: 'Work',
        recipientName: 'Rahul Verma',
        recipientPhone: '+91 98765 43210',
        houseFlatBlock: 'Floor 5, Cyber Park Tower B',
        areaColonyStreet: 'Tech Zone 4, Outer Ring Road',
        landmark: 'Opposite Coffee Day',
        city: 'Delhi',
        pincode: '110037',
        isDefault: false,
        latitude: 28.5355,
        longitude: 77.3910,
      ),
    ]);

    // 6. Sample Initial Orders
    _orders.addAll([
      OrderModel(
        id: 'CF-849201',
        userId: 'user_default',
        customerName: 'Rahul Verma',
        customerPhone: '+91 98765 43210',
        deliveryAddress: _addresses.first,
        items: [
          const OrderItemSnapshot(
            foodId: 'food_pani_puri',
            foodName: 'Gol Gappe / Pani Puri (6 Pcs)',
            unitPrice: 49.0,
            quantity: 2,
            totalPrice: 98.0,
            imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=800&q=80',
            isVeg: true,
            selectedOptions: ['Teekha (Spicy Mint Water)'],
            vendorName: 'Sharma Chaat Bhandar',
          ),
          const OrderItemSnapshot(
            foodId: 'food_vada_pav',
            foodName: 'Classic Mumbai Vada Pav (2 Pcs)',
            unitPrice: 40.0,
            quantity: 1,
            totalPrice: 40.0,
            imageUrl: 'https://images.unsplash.com/photo-1606491956689-2ea866880c84?auto=format&fit=crop&w=800&q=80',
            isVeg: true,
            selectedOptions: ['2 Salted Fried Green Chillies'],
            vendorName: 'Sardar Pav Bhaji Center',
          ),
        ],
        subtotal: 138.0,
        deliveryFee: 35.0,
        packagingFee: 15.0,
        taxes: 6.9,
        discountAmount: 20.0,
        appliedCouponCode: 'STREET20',
        totalAmount: 174.9,
        paymentMethod: 'UPI (Google Pay)',
        paymentStatus: 'Paid',
        status: AppConstants.statusPreparing,
        createdAt: DateTime.now().subtract(const Duration(minutes: 14)),
        estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 16)),
        deliveryInstructions: 'Ring bell and leave at the door please.',
      ),
      OrderModel(
        id: 'CF-729184',
        userId: 'user_default',
        customerName: 'Rahul Verma',
        customerPhone: '+91 98765 43210',
        deliveryAddress: _addresses.first,
        items: [
          const OrderItemSnapshot(
            foodId: 'food_chole_bhature',
            foodName: 'Amritsari Pindi Chole Bhature (2 Pcs)',
            unitPrice: 120.0,
            quantity: 2,
            totalPrice: 240.0,
            imageUrl: 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=800&q=80',
            isVeg: true,
            vendorName: 'Amritsari Chole Kulche Corner',
          ),
          const OrderItemSnapshot(
            foodId: 'food_mango_lassi',
            foodName: 'Kesar Mango Malai Lassi',
            unitPrice: 75.0,
            quantity: 2,
            totalPrice: 150.0,
            imageUrl: 'https://images.unsplash.com/photo-1546173159-315724a31696?auto=format&fit=crop&w=800&q=80',
            isVeg: true,
            vendorName: 'Banaras Lassi & Juice Hub',
          ),
        ],
        subtotal: 390.0,
        deliveryFee: 0.0,
        packagingFee: 15.0,
        taxes: 19.5,
        discountAmount: 100.0,
        appliedCouponCode: 'CHEATDAY50',
        totalAmount: 324.5,
        paymentMethod: 'Cash on Delivery',
        paymentStatus: 'Paid',
        status: AppConstants.statusDelivered,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      ),
    ]);

    // 7. Sample Reviews
    _reviews['food_pani_puri'] = [
      ReviewModel(
        id: 'rev_1',
        foodId: 'food_pani_puri',
        userId: 'u_101',
        userName: 'Aarav Sharma',
        rating: 5.0,
        comment: 'Authentic Purani Dilli taste! The mint water has the perfect spicy kick and puris were super crunchy.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ReviewModel(
        id: 'rev_2',
        foodId: 'food_pani_puri',
        userId: 'u_102',
        userName: 'Priya Iyer',
        rating: 4.5,
        comment: 'Loved the sweet imli chutney! Arrived packed very neatly without getting soggy.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  // --- Dynamic Mock Store Operations ---
  void addFoodItem(FoodItem item) {
    _foods.insert(0, item);
  }

  void updateFoodItem(FoodItem item) {
    final idx = _foods.indexWhere((f) => f.id == item.id);
    if (idx != -1) {
      _foods[idx] = item;
    }
  }

  void deleteFoodItem(String id) {
    _foods.removeWhere((f) => f.id == id);
  }

  void toggleFoodAvailability(String id) {
    final idx = _foods.indexWhere((f) => f.id == id);
    if (idx != -1) {
      final f = _foods[idx];
      _foods[idx] = f.copyWith(isAvailable: !f.isAvailable);
    }
  }

  void addOrder(OrderModel order) {
    _orders.insert(0, order);
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      _orders[idx] = _orders[idx].copyWith(status: newStatus);
    }
  }

  void toggleFavorite(String foodId) {
    if (_favoriteIds.contains(foodId)) {
      _favoriteIds.remove(foodId);
    } else {
      _favoriteIds.add(foodId);
    }
  }

  bool isFavorite(String foodId) => _favoriteIds.contains(foodId);

  void addAddress(AddressModel address) {
    if (address.isDefault) {
      for (int i = 0; i < _addresses.length; i++) {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
    }
    _addresses.add(address);
  }

  void updateAddress(AddressModel address) {
    final idx = _addresses.indexWhere((a) => a.id == address.id);
    if (idx != -1) {
      if (address.isDefault) {
        for (int i = 0; i < _addresses.length; i++) {
          _addresses[i] = _addresses[i].copyWith(isDefault: false);
        }
      }
      _addresses[idx] = address;
    }
  }

  void deleteAddress(String id) {
    _addresses.removeWhere((a) => a.id == id);
  }

  List<ReviewModel> getReviewsForFood(String foodId) {
    return _reviews[foodId] ?? [
      ReviewModel(
        id: 'rev_gen_1',
        foodId: foodId,
        userId: 'u_generic',
        userName: 'Food Explorer',
        rating: 5.0,
        comment: 'Absolutely finger-licking delicious! Best street food ever.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      )
    ];
  }

  void addReview(ReviewModel review) {
    if (!_reviews.containsKey(review.foodId)) {
      _reviews[review.foodId] = [];
    }
    _reviews[review.foodId]!.insert(0, review);
  }
}
