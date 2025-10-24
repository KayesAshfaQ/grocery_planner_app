# Grocery Planner App

A comprehensive grocery planning and tracking application built with Flutter using Clean Architecture.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Development](#development)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

## Overview

The Grocery Planner App helps users efficiently manage grocery shopping with intelligent planning, tracking, and analytics features.

### Key Highlights

- 📝 **Smart List Management**: Create and manage multiple purchase lists
- 📊 **Analytics & Reports**: Track spending patterns and price trends
- 🗂️ **Catalog System**: Maintain a master catalog of frequently purchased items
- 📅 **Shopping Schedule**: Plan trips with reminders
- 🎨 **Material Design 3**: Modern, responsive UI with light/dark themes
- 🏗️ **Clean Architecture**: Scalable, testable, and maintainable codebase

## Features

- ✅ Purchase list management with real-time updates
- ✅ Master catalog of grocery items
- ✅ Custom categories with icons
- ✅ Shopping schedule with notifications
- ✅ Weekly and monthly spending reports
- ✅ Price fluctuation tracking
- ✅ Dark mode support
- 🚧 Cloud sync (coming soon)
- 🚧 Barcode scanning (coming soon)

For detailed feature documentation, see [FEATURES.md](docs/FEATURES.md)

## Architecture

This app follows **Clean Architecture** with three main layers:

- **Domain Layer**: Business logic, entities, use cases
- **Data Layer**: Data sources, models, repository implementations
- **Presentation Layer**: BLoC state management, pages, widgets

### Project Structure

```text
lib/
├── config/          # Routes, theme, app configuration
├── core/            # DI, database, error handling, event bus
├── features/        # Feature modules (domain/data/presentation)
│   ├── catalog/
│   ├── category/
│   ├── purchase_list/
│   └── shared/      # Shared entities, models, widgets
```

For detailed architecture documentation, see [ARCHITECTURE.md](docs/ARCHITECTURE.md)

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK 3.0+
- Android Studio / VS Code
- Android SDK / Xcode (for iOS)

### Installation

```bash
# Clone the repository
git clone https://github.com/KayesAshfaQ/grocery_planner_app.git
cd grocery_planner_app

# Install dependencies
flutter pub get

# Run code generation
flutter packages pub run build_runner build

# Run the app
flutter run
```

### Build Commands

```bash
# Development
flutter run

# Tests
flutter test

# Build APK
flutter build apk

# Build iOS
flutter build ios
```

## Development

### Tech Stack

- **Framework**: Flutter & Dart
- **State Management**: BLoC (flutter_bloc)
- **Dependency Injection**: GetIt
- **Routing**: GoRouter
- **Database**: Floor (SQLite)
- **Functional Programming**: dartz (Either)

### Quick Commands

```bash
# Code generation (after DB changes)
flutter packages pub run build_runner build

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
flutter format .
```

For detailed development guidelines, see [DEVELOPMENT.md](docs/DEVELOPMENT.md)

## Documentation

- **[ARCHITECTURE.md](docs/ARCHITECTURE.md)**: Clean Architecture patterns, layers, and best practices
- **[DEVELOPMENT.md](docs/DEVELOPMENT.md)**: Development guide, code organization, and common tasks
- **[FEATURES.md](docs/FEATURES.md)**: Detailed feature descriptions and implementation status
- **[CONTRIBUTING.md](docs/CONTRIBUTING.md)**: Contribution guidelines and code standards

## Contributing

Contributions are welcome! Please read the [Contributing Guidelines](docs/CONTRIBUTING.md) before submitting a pull request.

### Quick Start for Contributors

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Follow Clean Architecture patterns (see [ARCHITECTURE.md](docs/ARCHITECTURE.md))
4. Write tests for new features
5. Commit with conventional commits (`feat:`, `fix:`, `docs:`, etc.)
6. Push and create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Built with ❤️ using Flutter**
