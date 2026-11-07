# 🍲 Cheat Food - Indian Street Food Mobile Application

**Cheat Food** is a complete, modern, attractive, and production-ready Flutter mobile application exclusively engineered for **Indian street food ordering**. From hot, crispy Gol Gappe and spicy Mumbai Vada Pavs to fluffy Amritsari Chole Bhature and rich Kesar Mango Lassi, Cheat Food connects foodies directly with beloved authentic street stalls and vendors.

---

## 📸 Key Features

### 1. Exclusive Indian Street Food Focus
- Strictly street food categories:
  - **Chaat:** Pani Puri / Gol Gappe, Bhel Puri, Aloo Tikki, Papdi Chaat, Sev Puri, Dahi Puri
  - **Mumbai Street Food:** Vada Pav, Pav Bhaji, Misal Pav, Dabeli
  - **North Indian Street Food:** Chole Bhature, Aloo Paratha, Amritsari Kulcha
  - **South Indian Street Food:** Masala Dosa, Podi Idli, Mysore Bonda, Medu Vada
  - **Snacks & Pakodas:** Samosa, Kachori, Mirchi Bajji, Onion Pakoda
  - **Rolls & Momos:** Veg Momos, Paneer Kathi Roll, Double Egg Street Roll
  - **Street-style Beverages:** Fresh Sugarcane Juice, Jeera Masala Soda, Cutting Chai, Mango Lassi

### 2. Appetizing Street Food UI/UX
- **Theme:** Vibrant Tandoor Saffron (`#FF5722`), Chilli Red (`#D32F2F`), Warm Cream (`#FFFDF9`), Turmeric Gold (`#FFA000`), and Mint Chutney Green (`#2E7D32`).
- Modern rounded food cards with shadow depth, spice level badges (🌶️ Mild, 🌶️🌶️ Medium, 🌶️🌶️🌶️ Fiery Spicy), pure-veg & non-veg indicators, preparation time, and star ratings.
- Smooth Hero animations transitioning between card and details.
- Persistent badged floating cart pill at the bottom when items are in cart.

### 3. Firebase Authentication & Profiles
- Email & password registration with validation.
- Secure login and password recovery.
- Instant **1-Click Demo Evaluation Pills** (`Customer Demo` & `Admin Demo`) for rapid college testing and vivas.
- Saved user profile with address book management (Home, Work, Other).

### 4. Interactive Street Food Search & Smart Filtering
- Search across **Food Name**, **Street Food Category**, and **Vendor Stall Name**.
- Live filters for:
  - Pure Veg Only toggle
  - Spice Level (Mild, Medium, Fiery Spicy)
  - Star Rating (4.5+, 4.8+)
  - Sorting (Popularity, Rating, Price: Low to High, Price: High to Low)

### 5. Shopping Cart & Promo Coupons
- Full item customization support (spice water choices, extra chutneys, cheese burst pavs, extra puris).
- Live quantity increments/decrements.
- Working coupon engine:
  - `CHEATDAY50`: 50% discount up to ₹100
  - `STREET20`: 20% discount up to ₹60
  - `FREEDELIVERY`: Free delivery on orders
- Automatic Indian billing calculation: Item total, Free Delivery over ₹199 threshold, packaging fee, 5% GST, and coupon discounts.

### 6. Checkout & Firestore Order Placement
- Selection of saved delivery addresses or instant new address creation.
- Rider delivery instructions notes.
- Payment methods: **Cash on Delivery (COD)**, **UPI (Google Pay / PhonePe / Paytm)**, and **Credit/Debit Card**.
- Direct Cloud Firestore write operation to the `orders` collection.

### 7. Real-Time Order Tracking & History
- Interactive visual order timeline:
  - `Placed` ➔ `Confirmed` ➔ `Preparing in Kadai/Tawa` ➔ `Out for Delivery` ➔ `Delivered`
  - Demo Status Advancer button to quickly simulate full order lifecycle during demonstrations!
  - Order cancellation support with reason prompt.

### 8. Vendor & Admin Management Panel
- Dedicated admin portal with KPI metrics (Total Sales ₹, Total Orders, Pending Orders, Active Menu Items).
- Add new street food items with name, description, price, spice level, veg tag, preparation time, and images.
- Edit existing foods or delete unavailable items.
- Live order status update dropdown for incoming stall orders.
- 1-Click **"Seed Cloud Database"** button to populate Firestore with sample Indian street food items, categories, vendors, and coupons.

---

## 🧱 Architecture & Project Structure

The project follows clean architecture principles with separate layers:

```
lib/
├── main.dart                      # App entry point, MultiProvider & MaterialApp setup
├── firebase_options.dart          # Firebase project configuration options
├── constants/
│   ├── app_colors.dart            # Saffron, chilli red, warm cream, dark slate palette
│   ├── app_constants.dart         # Categories, statuses, currency symbol (₹), fees
│   └── app_theme.dart             # Material 3 theme & typography (Plus Jakarta Sans)
├── models/
│   ├── user_model.dart            # User profile, role (customer / admin)
│   ├── food_item_model.dart       # Street food entity, customizations, spice level
│   ├── category_model.dart        # Category entity (Chaat, Mumbai, South Indian...)
│   ├── vendor_model.dart          # Vendor stall info, locality, rating
│   ├── cart_item_model.dart       # Cart entity with chosen options
│   ├── order_model.dart           # Order entity, snapshot, delivery address, status
│   ├── review_model.dart          # Food reviews & ratings
│   ├── address_model.dart         # Saved user delivery addresses
│   └── coupon_model.dart          # Discount coupons & calculation logic
├── services/
│   ├── firebase_service.dart      # Safe Firebase init with dual engine support
│   ├── auth_service.dart          # FirebaseAuth + local fallback
│   ├── firestore_service.dart     # Cloud Firestore CRUD operations
│   └── mock_data_service.dart     # Rich pre-seeded authentic Indian street foods
├── providers/
│   ├── auth_provider.dart         # Authentication state management
│   ├── food_provider.dart         # Foods, category filter, search & sorting
│   ├── cart_provider.dart         # Cart state, item math, coupons & totals
│   ├── order_provider.dart        # Order placement, active/past tabs, live tracking
│   ├── favorites_provider.dart    # Saved favorites list
│   ├── location_provider.dart     # Address book & active delivery location
│   └── admin_provider.dart        # Admin KPIs, food management, order updates
├── utils/
│   ├── currency_formatter.dart    # Indian Rupee (₹) formatting
│   ├── date_formatter.dart        # Clean Indian timestamp formatting
│   └── validators.dart            # Form input validation
├── widgets/
│   ├── food_card.dart             # Vertical food card with Hero image & quick add
│   ├── food_card_compact.dart     # Horizontal compact card for search & history
│   ├── category_chip.dart         # Street food category selection pill
│   ├── banner_slider.dart         # Promotional banner carousel with coupons
│   ├── veg_nonveg_badge.dart      # Authentic green / red food dot badge
│   ├── spice_level_badge.dart     # Chilli pepper indicator (Mild, Medium, Fiery)
│   ├── rating_badge.dart          # Star rating badge
│   ├── delivery_location_bar.dart # Location bar with address switcher
│   ├── search_bar_widget.dart     # Clean search bar with filter trigger
│   ├── order_status_timeline.dart # Visual step-by-step progress timeline
│   ├── empty_state_widget.dart    # Empty cart / search / orders placeholder
│   ├── custom_button.dart         # Themed primary / outlined buttons
│   └── custom_text_field.dart     # Styled input field with icons
└── screens/
    ├── splash/splash_screen.dart
    ├── onboarding/welcome_screen.dart
    ├── auth/                      # Login, Register, Forgot Password
    ├── main_navigation_screen.dart# 5-tab Bottom Navigation + Floating Cart Pill
    ├── home/home_screen.dart
    ├── food_details/food_details_screen.dart
    ├── search/search_screen.dart
    ├── cart/                      # CartScreen & CheckoutScreen
    ├── order/                     # Success, History & Live Tracking
    ├── favorites/favorites_screen.dart
    ├── profile/                   # Profile, Edit Profile, Addresses, Help
    └── admin/                     # Dashboard, Manage Foods, Orders, Vendors
```

---

## 🔒 Firebase Security Rules

`firestore.rules` enforces role-based access control (RBAC):
- **Users:** Can read and modify only their own profile and sub-collections (`addresses`, `favorites`).
- **Foods & Categories:** Publicly readable by all users; only authorized administrators/vendors can create, modify, or delete items.
- **Orders:** Authenticated customers can read and place their own orders; admins can view all orders and update their status.
- **Reviews:** Any authenticated user can submit reviews.

---

## 🚀 How to Run the Project

### Prerequisites
- Flutter SDK (version 3.0.0 or higher) installed on your system.
- Android Studio / VS Code with Flutter extension.
- Chrome browser or an Android emulator / physical device.

### 1. Install Dependencies
Open your terminal in the project root directory (`CHEAT FOODS`) and run:
```bash
flutter pub get
```

### 2. Running on Chrome (Instant Web Preview)
```bash
flutter run -d chrome
```

### 3. Running on Android Emulator / Physical Device
```bash
flutter run
```

### 4. Building Production APK
```bash
flutter build apk --release
```
The resulting APK will be located at:
`build/app/outputs/flutter-apk/app-release.apk`

---

## 🧪 Testing & Evaluation Guide

For quick evaluation or college project presentation:
1. **Launch the App:** You will see the animated **Cheat Food** splash screen.
2. **Instant Sign-In:** On the Login Screen, click **"Customer Demo"** or **"Admin Demo"** for instant 1-click auto-fill.
3. **Explore Street Foods:** Browse categories like Chaat, Mumbai Street Food, North Indian, etc. Filter by "Pure Veg Only" or "Fiery Spicy".
4. **Customizations:** Open *Gol Gappe / Pani Puri* or *Amul Butter Pav Bhaji*, pick your water choices or extra butter pav, and add to cart.
5. **Coupons:** In the cart, apply `CHEATDAY50` to enjoy a 50% discount.
6. **Checkout:** Select address, choose payment mode (Cash on Delivery or UPI), and hit **Place Order**.
7. **Track Order:** In the tracking screen, click **"Demo Tool: Next Step ➔"** to step the order live from *Placed* ➔ *Preparing* ➔ *Out for Delivery* ➔ *Delivered*.
8. **Admin Panel:** Go to Profile ➔ **Admin & Vendor Dashboard** to add new food items, change food prices, or manage live incoming orders.
