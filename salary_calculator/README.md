# Salary Calculator App

A modern, animated Flutter application designed to calculate net monthly salary with ease. This app provides a detailed breakdown of tax deductions and net income.

## Features

- **Detailed Inputs**: Fields for Monthly Income, Medical Allowance, Travel Allowance, and Residential Allowance.
- **Dynamic Tax Calculation**: Allows users to input a tax percentage to see the impact on their take-home pay.
- **Visual Breakdown**: Displays the **Tax Deduction** amount separately before showing the final **Net Monthly Salary**.
- **Modern UI**: Built with Material 3 using a high-luminance (Amber/Yellow) color scheme for high visibility.
- **Interactive Animations**: Results appear with smooth scale-in and fade-in animations using an elastic curve.
- **Robust Design**: Handles numeric inputs safely and supports various screen sizes via a scrollable interface.

## Calculation Logic

The app follows this internal logic:
1. **Gross Salary** = Monthly Income + Medical Allowance + Travel Allowance + Residential Allowance.
2. **Tax Amount** = Gross Salary * (Tax Percentage / 100).
3. **Net Monthly Salary** = Gross Salary - Tax Amount.

## How to Run

Follow these steps to get the app running on your machine:

### Prerequisites
- Install the [Flutter SDK](https://docs.flutter.dev/get-started/install).
- Set up an Android emulator, iOS simulator, or connect a physical device.

### Steps
1. **Clone the project**:
   ```bash
   git clone <repository-url>
   cd salary_calculator
   ```
2. **Install Dependencies**:
   Open your terminal in the project root and run:
   ```bash
   flutter pub get
   ```
3. **Run the App**:
   To start the app on your default device:
   ```bash
   flutter run
   ```
   *Tip: Use `r` in the terminal for Hot Reload or `R` for Hot Restart if you encounter state sync issues.*

## Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **Language**: Dart
- **Design System**: Material 3 (with custom high-luminance theme)
- **Animations**: Flutter `AnimationController`, `FadeTransition`, and `ScaleTransition`.
