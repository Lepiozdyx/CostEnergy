# CostEnergy

An iOS app for tracking energy consumption costs through device management, real-time monitoring, and statistics visualization.

## Features

### 1. Device Management
- Add, edit, and delete energy-consuming devices
- Customize device icons from SF Symbols
- Track power consumption (kW) and usage type
- Empty state guidance for first-time users

### 2. Real-Time Timer
- Select devices to monitor
- Real-time energy consumption tracking
- Live cost calculation
- Save usage sessions to history
- Disabled state when no devices are added

### 3. Statistics & History
- Filter by day, week, or month
- Summary cards showing total energy, cost, and time
- Chronological usage history
- Device-specific tracking
- Empty state for new users

### 4. Settings
- Property name configuration
- Multi-currency support (USD, RUB, EUR)
- Customizable tariff rates
- Transparent calculation formulas

## Technical Details

### Requirements
- iOS 16.0+
- Xcode 14.0+
- Swift 5.9+

### Architecture
- **Pattern**: MVVM (Model-View-ViewModel)
- **UI Framework**: SwiftUI
- **Persistence**: UserDefaults + Codable
- **State Management**: Combine, ObservableObject
- **Orientation**: Portrait only

### Project Structure
```
CostEnergy/
├── App/                    # App entry point
├── Models/                 # Data models
├── ViewModels/             # Business logic
├── Views/                  # UI components
│   ├── TabBar/            # Main navigation
│   ├── Devices/           # Device management
│   ├── Timer/             # Energy tracking
│   ├── Statistics/        # Usage analytics
│   └── Settings/          # Configuration
├── Managers/              # Service layer
├── Helpers/               # Utilities & extensions
└── Resources/             # Assets

```

### Key Components

#### Models
- `Device`: Energy-consuming device information
- `UsageRecord`: Tracking session data
- `AppSettings`: User preferences

#### Managers
- `StorageManager`: Centralized persistence using UserDefaults
- `CalculationManager`: Energy and cost calculations

#### Calculation Formulas
```
Energy (kWh) = Power (kW) × Time (hours)
Cost = Energy (kWh) × Tariff Rate
```

## UI/UX Features

- **Dark Mode**: Full support with adaptive colors
- **Animations**: Smooth transitions and spring animations
- **Dynamic Type**: Scalable text for accessibility
- **Empty States**: Helpful guidance throughout the app
- **SF Symbols**: Consistent iconography
- **Swipe Actions**: Edit and delete gestures
- **Form Validation**: Input checks before saving

## Data Persistence

All data is stored locally using UserDefaults with JSON encoding:
- Devices list
- Usage records history
- App settings (currency, tariff, property name)

## Building & Running

1. Open `CostEnergy.xcodeproj` in Xcode
2. Select your target device or simulator
3. Press `Cmd + R` to build and run

## Testing

The app includes:
- SwiftUI Previews for all major views
- Edge case handling (zero devices, empty states)
- Input validation for numeric fields
- Portrait-only orientation lock

## Future Enhancements

Potential improvements:
- Export usage data to CSV
- Charts and graphs for statistics
- Notifications for high usage
- Widget support
- iCloud sync
- Multiple properties support

## License

© 2025 CostEnergy. All rights reserved.

