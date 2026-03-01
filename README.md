# CROMA - Streetwear Fashion Store

CROMA is a premium mobile experience for a streetwear fashion store, built with Flutter. It focuses on a minimalist, industrial, and high-end aesthetic while providing a seamless shopping experience synchronized with the Web/Astro backend.

![CROMA Logo](https://res.cloudinary.com/dlp6mueis/image/upload/v1740690048/croma_logo_dark.png)

## 🚀 Key Features

### 🛒 Shopping Experience
- **Industrial Catalog**: A carefully designed shop interface with smooth scroll-fading animations and minimalist product cards.
- **Advanced Filtering**: Collapsible search and filtering system for categories, brands, and colors.
- **Product Details**: High-resolution gallery, interactive size selection, and real-time stock monitoring.

### 🔐 User & Security
- **Cross-Platform Favorites**: Synchronized favorites list across Web and Mobile via Supabase.
- **Secure Authentication**: Full login/register flow integrated with the Astro backend ecosystem.
- **Address Management**: Intelligent shipping address system allowing multiple saved locations.

### 💳 Logistics & Payments
- **Stripe Integration**: Secure payment processing with real-time order creation.
- **Order Tracking**: Detailed view of past orders, including itemized lists and status history.
- **Returns System**: Streamlined return request interface with industrial design.

### 🛠 Administrative Control (Admin Portal)
- **Real-Time Metrics**: Dashboard with live revenue, marketing reach, and critical stock alerts.
- **Inventory Management**: Full control over product visibility, pricing, and database deletion.
- **Logistics Center**: Manage all orders, update shipping statuses, and monitor client profiles.

## 🏗 Technology Stack

- **Framework**: [Flutter](https://flutter.dev/) (Mobile & Web compatibility)
- **State Management**: [Riverpod](https://riverpod.dev/) (Functional & Reactive)
- **Backend**: [Supabase](https://supabase.com/) (Database & Auth)
- **Payments**: [Stripe](https://stripe.com/)
- **Media**: [Cloudinary](https://cloudinary.com/) (Optimized image delivery)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)

## 📁 Project Structure

The project follows a **Feature-first Clean Architecture** pattern:

```text
lib/
├── core/               # App-wide configurations, routing, and services
│   ├── config/         # Routing (GoRouter) and Environment
│   └── services/       # Stripe, Cloudinary, and Supabase integrations
├── features/           # Independent business modules
│   ├── admin/          # Management portal
│   ├── cart/           # Basket and totals logic
│   ├── checkout/       # Payment flows
│   ├── product_detail/ # Detailed view and gallery
│   └── ...             # Shop, Search, Favorites, etc.
└── shared/             # Common models, widgets, and utilities
```

## 🛠 Setup & Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/astralk9999/CROMA_APP.git
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run build runner** (to generate code for models and providers):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Launch the app**:
   ```bash
   flutter run
   ```

---
*Developed as part of the CROMA Digital Ecosystem.*
