# sales_bets

A new Flutter project.

## Getting Started

Sales Bets - No-Loss Betting Platform
A cutting-edge Flutter application that brings the excitement of sports betting to business challenges with a revolutionary "win but never lose" system.

App Overview
Sales Bets is a platform where users can bet on business teams achieving milestones, watch live streaming events, and engage with a community of business enthusiasts - all without risking their credits.

Core Features

Implemented Features
- User Authentication - Secure login/register with Firebase Auth

- No-Loss Betting System - Users can only win, never lose credits

- Team Management - Browse, follow, and track business teams

- Live Events - Event streaming with real-time betting

- Modern UI/UX - Beautiful dark/light theme with smooth animations

- Real-time Updates - Live data sync with Cloud Firestore

- User Profiles - Comprehensive user stats and wallet management

Architecture
- Frontend: Flutter with Dart

- Backend: Firebase (Auth, Firestore, Storage)

- State Management: Riverpod

- Navigation: Flutter Navigator

Getting Started
Prerequisites
- Flutter SDK 3.0+

- Firebase Project

- VS Code

Installation
Clone the repository

Run flutter pub get to install dependencies

Set up Firebase project and add configuration files

Run flutter run to start the app

Project Structure
text
lib/
├── models/          # Data models (User, Team, Event, Bet)
├── providers/       # State management with Riverpod
├── screens/         # App screens and navigation
├── services/        # Business logic and Firebase services
├── widgets/         # Reusable UI components
└── utils/           # Constants and theme configuration

Key Implementation Details
No-Loss Betting Logic
dart
// Credits are never deducted - only potential winnings are calculated
potentialWinnings = (stakeAmount * 1.5).round();
Firebase Integration
Real-time data streaming with Firestore

Secure authentication with Firebase Auth

File storage with Firebase Storage

State Management
Riverpod for predictable state management

Stream providers for real-time updates

Efficient widget rebuilds with Consumer widgets

- UI/UX Features
Responsive Design - Works on all screen sizes

Theme Support - Dark/Light mode toggle

Smooth Animations - Confetti effects for wins

Intuitive Navigation - Bottom navigation bar

Modern Components - Cards, gradients, and clean layouts

- Sample Data
The app includes:

10 Business Teams with unique specialties and stats

10 Live Events with various statuses (live, upcoming, completed)

Real User Profiles with betting history and achievements

- Technical Highlights
Code Quality
Clean, maintainable code structure

Proper error handling and loading states

Efficient state management

Responsive UI components

Firebase Expertise
Real-time data synchronization

Secure authentication flow

Efficient data modeling

Proper security rules

Flutter Best Practices
Widget composition and reusability

Proper state management

Smooth animations and transitions

Platform-specific design


