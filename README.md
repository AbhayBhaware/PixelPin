# PixelPin 📌

> A wallpaper ecosystem — mobile app, creator website, and admin panel — all powered by Firebase + Cloudinary.

## Structure

```
PixelPin/
├── lib/                    # Flutter app (viewer)
│   ├── core/               # Theme, constants, router, services
│   ├── data/               # Models, repositories, datasources
│   ├── features/           # Splash, Home, Categories, Search, Detail, Favorites, Settings
│   └── shared/             # Reusable widgets & providers
├── website/                # Next.js 14 (App Router) — website + admin panel
│   ├── app/
│   │   ├── (public)/       # Public browse & wallpaper pages
│   │   ├── (auth)/         # Login
│   │   ├── (contributor)/  # Upload, dashboard, earnings
│   │   └── admin/          # Review queue, analytics, payouts
│   ├── components/
│   ├── lib/                # Firebase, Cloudinary, hooks, stores
│   └── types/
├── functions/              # Firebase Cloud Functions (Phase 4+)
├── firestore.rules         # Security rules
├── firestore.indexes.json  # Composite indexes
└── firebase.json
```

## Phases

| Phase | Status | Description |
|-------|--------|-------------|
| 0. Setup | ✅ Complete | Flutter scaffold, Next.js scaffold, Firebase config, Cloudinary utils, Firestore rules |
| 1. Website MVP | 🚧 In Progress | Auth + invite, upload, contributor dashboard |
| 2. Admin Panel | 🚧 In Progress | Review queue, approve/reject, categories |
| 3. Flutter App MVP | ⏳ Pending | Home, categories, search, detail, download, share |
| 4. Analytics | ⏳ Pending | Event tracking, counters, dashboard |
| 5. Ads + Earnings | ⏳ Pending | AdMob, monthly revenue, payout records |
| 6. Polish & Launch | ⏳ Pending | Legal, SEO, Play Store |

## Setup

### 1. Firebase
```bash
npm install -g firebase-tools
firebase login
firebase init
firebase deploy --only firestore:rules,firestore:indexes
```

### 2. FlutterFire (Flutter app)
```bash
dart pub global activate flutterfire_cli
flutterfire configure
flutter pub get
```

### 3. Website
```bash
cd website
cp .env.example .env.local
# Fill .env.local with Firebase + Cloudinary credentials
npm install
npm run dev
```

## Design System

| Token | Value |
|-------|-------|
| Primary | `#7C4DFF` |
| Accent | `#FF6D6D` |
| Background | `#0A0A0F` |
| Font | Outfit (Google Fonts) |

## Revenue Model

- Platform cut: **30%**, Contributor pool: **70%**
- Score: `views × 1 + downloads × 5 + shares × 3`
