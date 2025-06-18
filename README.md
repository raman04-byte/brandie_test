# Brandie Test - Clean Architecture Flutter App

A well-structured single page Flutter application demonstrating clean architecture principles with logical component breakdown.

## Project Structure

```
lib/
├── core/                          # Core functionality shared across the app
│   ├── constants/                 # App-wide constants
│   │   └── app_constants.dart     # Spacing, sizes, durations
│   ├── theme/                     # Theme and styling
│   │   ├── app_colors.dart        # Color palette
│   │   ├── app_text_styles.dart   # Typography styles
│   │   └── app_theme.dart         # Main theme configuration
│   └── utils/                     # Utility functions
│       └── responsive_utils.dart  # Responsive design helpers
├── features/                      # Feature-based organization
│   └── home/                      # Home feature
│       └── presentation/          # UI layer
│           ├── pages/             # Screen/page widgets
│           │   └── home_page.dart # Main home screen
│           └── widgets/           # Feature-specific widgets
│               ├── header_section.dart
│               ├── stats_section.dart
│               ├── action_buttons_section.dart
│               └── recent_activity_section.dart
├── shared/                        # Shared components
│   └── widgets/                   # Reusable UI components
│       ├── custom_button.dart     # Custom button widget
│       ├── custom_card.dart       # Custom card widgets
│       └── common_widgets.dart    # Loading, error, empty states
└── main.dart                      # App entry point
```

## 🏗️ Architecture Overview

### Clean Architecture Principles

1. **Separation of Concerns**: Each layer has a specific responsibility
2. **Feature-based Organization**: Code organized by features rather than technical layers
3. **Reusability**: Shared components and utilities
4. **Maintainability**: Clear structure makes code easy to maintain and extend

### Folder Structure Explanation

#### Core Layer
- **Constants**: App-wide constants for consistent spacing, sizing, and timing
- **Theme**: Centralized theming system with colors, typography, and component styles
- **Utils**: Helper functions and utilities (responsive design, formatters, etc.)

#### Features Layer
- **Home Feature**: Contains all home-related functionality
  - **Presentation**: UI components for the feature
    - **Pages**: Main screen widgets
    - **Widgets**: Feature-specific reusable components

#### Shared Layer
- **Widgets**: Reusable UI components used across multiple features
- Common patterns like loading states, error handling, and custom components

## Design System

### Color Palette
- **Primary**: Modern purple theme (`#6C63FF`)
- **Secondary**: Teal accent (`#03DAC6`)
- **Neutrals**: Comprehensive grayscale
- **Status**: Success, warning, error, info colors

### Typography
- **Google Fonts**: Inter font family for modern, clean appearance
- **Hierarchical**: Consistent heading and body text styles
- **Responsive**: Proper line heights and spacing

### Components
- **Custom Button**: Elevated and outlined variants with loading states
- **Custom Card**: Consistent card styling with Material Design principles
- **Info Cards**: Specialized cards for displaying statistics
- **Loading States**: Consistent loading indicators across the app

## Responsive Design

The app is built with responsive design principles:
- **Mobile First**: Optimized for mobile devices
- **Tablet Support**: Adjusted layouts for tablet screens
- **Desktop Ready**: Proper scaling for desktop experiences

### Responsive Features
- Dynamic grid columns based on screen size
- Responsive padding and spacing
- Adaptive button layouts
- Screen size-aware components

## Key Features

### Home Page Components

1. **Header Section**
   - Welcome message
   - User avatar placeholder
   - Responsive layout

2. **Stats Section**
   - Grid of information cards
   - Loading states
   - Responsive grid columns

3. **Action Buttons Section**
   - Primary and secondary actions
   - Responsive layout (mobile: stacked, tablet/desktop: horizontal)
   - Icon-text buttons

4. **Recent Activity Section**
   - List of recent activities
   - Interactive cards
   - Loading states
   - Icon-based categorization

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- VS Code or Android Studio

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

- **flutter**: SDK
- **google_fonts**: Typography
- **cupertino_icons**: iOS-style icons

## Development Guidelines

### Adding New Features
1. Create a new folder under `features/`
2. Follow the same structure: `presentation/pages/` and `presentation/widgets/`
3. Add shared components to `shared/widgets/`
4. Update theme and constants as needed

### Component Development
- Use the existing design system
- Follow Material Design principles
- Implement responsive behavior
- Include loading and error states
- Write clean, documented code

### Best Practices
- Use const constructors where possible
- Implement proper null safety
- Follow Dart/Flutter linting rules
- Use meaningful variable and function names
- Keep widgets focused and single-purpose

## Customization

### Colors
Update `lib/core/theme/app_colors.dart` to modify the color scheme.

### Typography
Modify `lib/core/theme/app_text_styles.dart` for typography changes.

### Spacing
Adjust `lib/core/constants/app_constants.dart` for consistent spacing updates.

### Theme
The main theme configuration is in `lib/core/theme/app_theme.dart`.

## Future Enhancements

- State management (Bloc/Riverpod)
- Data layer with repositories
- API integration
- Local storage
- Navigation with routing
- Internationalization (i18n)
- Dark theme support
- Animation enhancements

---

Built with ❤️ using Flutter and clean architecture principles.
