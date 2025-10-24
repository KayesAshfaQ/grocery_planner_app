# Features Documentation

## Overview

The Grocery Planner App provides comprehensive grocery shopping management with the following key features:

## 1. Purchase List Management

### Description
Create and manage multiple purchase lists for different shopping trips.

### Capabilities
- Create new purchase lists with name and date
- Add items to lists with quantity and price
- Mark items as purchased
- Track total cost per list
- View purchase history

### User Flow
1. Navigate to Purchase Lists screen
2. Tap "Add" to create new list
3. Add items from catalog or create new items
4. During shopping, mark items as purchased
5. View completed lists in history

## 2. Catalog Management

### Description
Maintain a master catalog of frequently purchased grocery items.

### Capabilities
- Pre-populate common grocery items
- Add custom items with name, category, and unit
- Edit item details
- Delete unused items
- Search and filter catalog

### Benefits
- Faster list creation
- Consistent item naming
- Price history tracking
- Category organization

## 3. Category Management

### Description
Organize grocery items into customizable categories.

### Capabilities
- Create custom categories with icons
- Edit category names and icons
- Delete categories
- Assign items to categories
- Filter items by category

### Default Categories
- Food & Beverages
- Personal Care
- Household
- Fresh Produce
- Dairy & Eggs
- Meat & Seafood
- Bakery
- Frozen Foods

## 4. Shopping Schedule

### Description
Plan shopping trips with reminders and notifications.

### Capabilities
- Schedule future shopping trips
- Set location/store for each trip
- Add notes and planning details
- Receive notifications before scheduled trips
- Link purchase lists to scheduled trips

### User Flow
1. Navigate to Schedule screen
2. Select date for shopping trip
3. Add store location and notes
4. Link to existing purchase list
5. Get reminder notification

## 5. Reports & Analytics

### Description
Track spending patterns and purchase history.

### Capabilities
- Weekly spending reports
- Monthly spending summaries
- Category-wise spending breakdown
- Price fluctuation tracking
- Purchase frequency analysis

### Visualizations
- Bar charts for weekly/monthly spending
- Line graphs for price trends
- Pie charts for category distribution
- Comparison charts for different periods

## 6. Settings & Preferences

### Description
Customize app behavior and appearance.

### Capabilities
- Theme selection (Light/Dark/System)
- Default currency setting
- Notification preferences
- Data backup and restore
- Clear app data

### Available Settings
- **Appearance**: Theme mode, color scheme
- **Notifications**: Shopping reminders, price alerts
- **Currency**: Default currency symbol and format
- **Data**: Import/export, backup, clear cache

## Upcoming Features

### Planned Enhancements
- [ ] Barcode scanning for quick item addition
- [ ] Shared shopping lists with family members
- [ ] Recipe integration with ingredient lists
- [ ] Store layout mapping for efficient shopping
- [ ] Budget tracking and spending limits
- [ ] Coupon and discount management
- [ ] Multi-language support
- [ ] Cloud sync across devices

## Feature Implementation Status

| Feature | Status | Notes |
|---------|--------|-------|
| Purchase List Management | ✅ Complete | Core functionality implemented |
| Catalog Management | ✅ Complete | With search and filtering |
| Category Management | ✅ Complete | Custom icons supported |
| Shopping Schedule | 🚧 In Progress | Notifications pending |
| Reports & Analytics | 🚧 In Progress | Basic charts implemented |
| Settings | ✅ Complete | Theme and preferences |
| Barcode Scanner | 📋 Planned | Future enhancement |
| Cloud Sync | 📋 Planned | Future enhancement |

## Technical Implementation

Each feature follows Clean Architecture with:
- **Domain Layer**: Business entities and use cases
- **Data Layer**: Local database (Floor) persistence
- **Presentation Layer**: BLoC state management with Material3 UI

For detailed technical implementation, see [ARCHITECTURE.md](ARCHITECTURE.md).
