# Simple Calculator App in Flutter & Dart

A clean, modern, and responsive **Simple Calculator** built with Flutter and Dart, adhering strictly to Material Design standards.

---

## 📁 Project Structure

```text
simple_calculator/
│
├── lib/
│   ├── main.dart       # Main app entry, state management, calculation logic & display UI
│   └── buttons.dart    # Calculator button labels & reusable MyButton widget
│
├── pubspec.yaml        # Flutter dependencies (includes math_expressions: ^2.7.0)
└── android/            # Android platform configuration files
```

---

## 🎨 UI & Design Specifications

- **App Bar**: Blue (`#2196F3`), Title: `"Calculator"`, Left-aligned, White text.
- **Display Section**: Dark Grey (`#606260`), displays entered expression at top right and calculated result below in large bold white text (`44pt`). Prevents overflow via horizontal scrolling.
- **Button Grid**: 4 columns × 5 rows (20 buttons total) with thin grey borders (`#E0E0E0`).
- **Color Palette**:
  - `C`, `+/-`, `%`, `DEL`: Light Blue (`#E1F5FE`), Black text
  - `0`–`9`, `.`: White (`#FFFFFF`), Black text
  - `+`, `-`, `×`, `/`: Blue (`#448AFF`), White text
  - `=`: Orange (`#FF8800`), White text

---

## ⚡ Features & Operations

1. **Arithmetic Operations**: `+`, `-`, `×`, `/`
2. **Expression Evaluation**: Uses `math_expressions` parser.
3. **Decimal Input (`.`)**: Prevents multiple decimal points in a single number token.
4. **Sign Toggle (`+/-`)**: Switches positive/negative state of the current number.
5. **Percentage (`%`)**: Converts input number/expression by dividing by 100.
6. **Division by Zero Protection**: Displays `"Cannot divide by zero"`.
7. **Invalid Input Guard**: Displays `"Error"` on invalid syntax.
8. **Clear (`C`) & Delete (`DEL`)**: Clear full screen or backspace last character.

---

## 🚀 How to Run the App

### Prerequisites
1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install).
2. Install Android Studio & Android SDK (or VS Code with Flutter extension).
3. Connect an Android Device via USB (with Developer Options & USB Debugging enabled) OR start an Android Emulator.

### Step-by-Step Terminal Instructions

1. **Navigate to the project directory**:
   ```bash
   cd simple_calculator
   ```

2. **Fetch dependencies**:
   ```bash
   flutter pub get
   ```

3. **Check connected Android devices**:
   ```bash
   flutter devices
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

---

## 🛠 Dependencies (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter
  math_expressions: ^2.7.0
```
