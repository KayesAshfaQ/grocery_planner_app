# Contributing Guidelines

## Welcome

Thank you for considering contributing to the Grocery Planner App! This document provides guidelines and best practices for contributing.

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Git

### Setup Development Environment
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

## How to Contribute

### 1. Choose What to Work On
- Check the [Issues](https://github.com/KayesAshfaQ/grocery_planner_app/issues) page
- Look for `good-first-issue` or `help-wanted` labels
- Comment on the issue to indicate you're working on it
- Or propose a new feature/improvement

### 2. Fork and Branch
```bash
# Fork the repository on GitHub
# Clone your fork
git clone https://github.com/YOUR_USERNAME/grocery_planner_app.git

# Create a feature branch
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

### 3. Follow Code Standards

#### Architecture
- Follow Clean Architecture principles (see [ARCHITECTURE.md](ARCHITECTURE.md))
- Separate concerns into Domain, Data, and Presentation layers
- Use BLoC pattern for state management
- Follow single-responsibility principle

#### Code Style
- Follow official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

#### Naming Conventions
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `lowerCamelCase` or `SCREAMING_SNAKE_CASE` for static constants
- **BLoC Events**: `VerbNounEvent` (e.g., `AddPurchaseListEvent`)
- **BLoC States**: `NounStateType` (e.g., `PurchaseListLoadedState`)

### 4. Write Tests
All contributions should include appropriate tests:

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/path/to/test_file.dart
```

**Test Coverage Requirements**:
- Unit tests for use cases
- Unit tests for repositories
- BLoC tests for state management
- Widget tests for complex UI components

### 5. Commit Guidelines

Follow conventional commits format:

```bash
# Feature
git commit -m "feat(purchase-list): add bulk delete functionality"

# Bug fix
git commit -m "fix(catalog): resolve search filter issue"

# Documentation
git commit -m "docs(readme): update installation instructions"

# Refactor
git commit -m "refactor(category): consolidate form widgets"

# Test
git commit -m "test(purchase-list): add unit tests for use cases"
```

**Commit Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Build process or auxiliary tool changes
- `style`: Code style changes (formatting, missing semicolons, etc.)

### 6. Submit Pull Request

```bash
# Push your branch
git push origin feature/your-feature-name
```

1. Go to GitHub and create a Pull Request
2. Fill out the PR template with:
   - Description of changes
   - Related issue numbers
   - Screenshots (for UI changes)
   - Test coverage
3. Wait for code review
4. Address review comments
5. Once approved, your PR will be merged

## Pull Request Checklist

Before submitting, ensure:
- [ ] Code follows Clean Architecture patterns
- [ ] All tests pass (`flutter test`)
- [ ] No linting errors (`flutter analyze`)
- [ ] Code is properly formatted (`flutter format .`)
- [ ] Added/updated documentation if needed
- [ ] Added/updated tests for new functionality
- [ ] Commits follow conventional commit format
- [ ] PR description clearly explains changes
- [ ] Screenshots included for UI changes

## Code Review Process

1. **Automated Checks**: CI/CD runs tests and linting
2. **Peer Review**: Maintainer reviews code quality and architecture
3. **Feedback**: Address any requested changes
4. **Approval**: Once approved, PR is merged
5. **Release**: Changes included in next release

## Development Guidelines

### Adding New Features
See the detailed guide in [DEVELOPMENT.md](DEVELOPMENT.md#adding-new-features)

**Quick Checklist**:
1. Create domain layer (entities, repositories, use cases)
2. Create data layer (models, data sources, repository implementations)
3. Create presentation layer (BLoC, pages, widgets)
4. Register dependencies in `service_locator.dart`
5. Add routes in `app_router.dart`
6. Write tests
7. Update documentation

### Modifying Existing Features
1. Understand the current implementation
2. Check for dependencies and impacts
3. Update tests accordingly
4. Document breaking changes
5. Update relevant documentation

### Database Changes
After modifying entities or DAOs:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Reporting Bugs

### Bug Report Template
```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Environment:**
 - Device: [e.g., Pixel 5]
 - OS: [e.g., Android 12]
 - App Version: [e.g., 1.0.0]

**Additional context**
Any other context about the problem.
```

## Suggesting Enhancements

### Feature Request Template
```markdown
**Is your feature request related to a problem?**
A clear description of the problem.

**Describe the solution you'd like**
A clear description of what you want to happen.

**Describe alternatives you've considered**
Other solutions or features you've considered.

**Additional context**
Mockups, examples, or references.
```

## Code of Conduct

### Our Standards
- Be respectful and inclusive
- Accept constructive criticism
- Focus on what's best for the community
- Show empathy towards others

### Unacceptable Behavior
- Harassment or discriminatory comments
- Trolling or insulting comments
- Personal or political attacks
- Publishing others' private information

## Questions?

- Open a [Discussion](https://github.com/KayesAshfaQ/grocery_planner_app/discussions)
- Ask in the issue comments
- Contact maintainers

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

Thank you for contributing! 🎉
