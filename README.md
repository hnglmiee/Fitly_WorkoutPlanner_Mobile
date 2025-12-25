# Fitly - Workout Tracker

A comprehensive mobile application designed to help users schedule workouts, create training plans, and track their fitness progress effectively.

## Overview

Fitly is a full-featured workout tracking application that empowers users to take control of their fitness journey. With intuitive scheduling, personalized workout plans, and intelligent progress tracking, Fitly makes it easy to stay motivated and achieve your fitness goals.

## Key Features

- **Workout Scheduling**: Plan and organize your training sessions with an intuitive calendar interface
- **Custom Training Plans**: Create personalized workout routines tailored to your fitness goals
- **Progress Tracking**: Monitor your fitness journey with detailed analytics and historical data
- **InBody Data Integration**: Automatically extract body composition data from InBody reports using OCR technology
- **Performance Metrics**: Track key metrics including weight, body fat percentage, muscle mass, and more
- **Workout History**: Review past workouts and analyze your performance over time

## Technology Stack

### Backend
- **Java Spring Boot**: Robust and scalable REST API framework
- **MySQL**: Relational database for secure data storage and management
- **PaddlePaddle OCR**: Advanced optical character recognition for extracting data from InBody scan documents

### Mobile Application
- **Flutter**: Cross-platform mobile development framework for iOS and Android
- Dart programming language
- Material Design UI components

## Architecture

```
┌─────────────────┐
│  Flutter App    │
│   (Mobile UI)   │
└────────┬────────┘
         │
         │ REST API
         │
┌────────▼────────┐
│  Spring Boot    │
│    Backend      │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
┌───▼───┐ ┌──▼──────────┐
│ MySQL │ │ PaddleOCR   │
│  DB   │ │  Service    │
└───────┘ └─────────────┘
```

## Getting Started

### Prerequisites

- Java JDK 11 or higher
- MySQL 8.0 or higher
- Flutter SDK 3.0+
- PaddlePaddle OCR dependencies

### Backend Setup

1. Clone the repository:
```bash
git clone https://github.com/hnglmiee/Fitly_WorkoutPlanner_Mobile.git
cd fitly-workout-tracker/backend
```

2. Configure database connection in `application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/fitly_db
spring.datasource.username=your_username
spring.datasource.password=your_password
```

3. Install dependencies and run:
```bash
./mvnw clean install
./mvnw spring-boot:run
```

### Mobile App Setup

1. Navigate to the Flutter app directory:
```bash
cd fitly-workout-tracker/mobile
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure API endpoint in `lib/config/api_config.dart`:
```dart
static const String baseUrl = 'http://your-api-url:8080';
```

4. Run the app:
```bash
flutter run
```

## Core Functionalities

### Workout Management
- Create, edit, and delete custom workouts
- Set exercise routines with sets, reps, and weights
- Schedule workouts on specific dates and times

### Progress Tracking
- Visual charts and graphs for progress monitoring
- Body measurement tracking
- Workout completion statistics
- Personal records (PRs) tracking

### InBody Integration
- Upload InBody scan reports (PDF/Image format)
- Automatic data extraction using PaddleOCR
- Historical body composition tracking
- Trend analysis for key metrics

## API Endpoints

### Authentication
- `POST /api/v1/users` - User registration
- `POST /api/v1/auth` - User login

### Workout Plans
- `GET /api/v1/workouts/my-plan` - Get all workout plans
- `POST /api/v1/workout-plans` - Create new workout
- `PUT /api/v1/workout-plans/{id}` - Update workout
- `DELETE /api/v1/workout-plans/{id}` - Delete workout

### Goal Progress
- `GET /api/v1/goal/progress` - Get user goal progress data
- `POST /api/v1/goal` - Create workout goal

### InBody
- `POST /api/v1/user-in-body/import/upload` - Upload InBody scan
- `GET /api/v1/user-in-body/my-in-body` - Get InBody history

## Database Schema

Key tables include:
- `users` - User account information
- `workout-schedule` - Workout definitions and schedules
- `workout-exercises` - Exercise library
- `workout_logs` - Completed workout records
- `user-in-body` - Body composition and measurements
- `sms-notification` - SMS reminder

## OCR Integration

The application uses PaddlePaddle OCR to automatically extract data from InBody reports:

1. User uploads InBody scan (PDF or image)
2. Backend processes the document using PaddleOCR
3. Text recognition identifies key metrics (weight, body fat %, muscle mass, etc.)
4. Extracted data is parsed and stored in the database
5. User can review and confirm the imported data

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Acknowledgments

- PaddlePaddle OCR for text recognition capabilities
- Flutter community for excellent documentation and packages
- Spring Boot framework for backend reliability
