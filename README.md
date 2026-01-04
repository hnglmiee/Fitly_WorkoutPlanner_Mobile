# Fitly - Workout Tracker

A comprehensive mobile application designed to help users schedule workouts, create training plans, and track their fitness progress effectively with intelligent InBody data extraction.

## Index

- [About](#about)
- [Usage](#usage)
  - [Installation](#installation)
  - [Commands](#commands)
- [Development](#development)
  - [Pre-Requisites](#pre-requisites)
  - [Development Environment](#development-environment)
  - [File Structure](#file-structure)
  - [Build](#build)  
  - [Deployment](#deployment)  
  - [Guideline](#guideline)  
- [FAQ](#faq)
- [Resources](#resources)
- [Gallery](#gallery)

## About

Fitly is a full-featured workout tracking mobile application that empowers users to take complete control of their fitness journey. Built with Flutter for cross-platform compatibility and powered by a robust Spring Boot backend, Fitly provides an intuitive and comprehensive solution for fitness enthusiasts of all levels.

**Key Highlights:**
- Schedule and organize training sessions with an intelligent calendar interface
- Create personalized workout plans with a diverse exercise library
- Track progress with detailed analytics and historical data
- Automatically extract body composition data from InBody reports using advanced OCR technology
- Perfect for beginners who need guidance and support in reading fitness reports
- Seamless integration between workout planning and body composition tracking

The application leverages PaddlePaddle OCR to eliminate the time-consuming process of manually reading InBody reports, making it especially suitable for newcomers who need assistance in understanding their fitness metrics.

## Usage

Fitly is designed for both iOS and Android platforms, providing a seamless fitness tracking experience across devices.

### Installation

**For End Users:**

1. **Android:**
   - Download the APK from the releases page
   - Enable "Install from Unknown Sources" in your device settings
   - Install the APK file
   - Open Fitly and create your account

2. **iOS:**
   - Download from TestFlight (development) or App Store (when available)
   - Open the app and register

**For Developers:**

1. Clone the repository:
```bash
git clone https://github.com/hnglmiee/Fitly_WorkoutPlanner_Mobile.git
cd Fitly_WorkoutPlanner_Mobile
```

2. **Backend Setup:**
```bash
cd backend
# Configure application.properties with your MySQL credentials
./mvnw clean install
./mvnw spring-boot:run
```

3. **Mobile App Setup:**
```bash
cd mobile
flutter pub get
# Configure API endpoint in lib/config/api_config.dart
flutter run
```

### Commands

**Backend Commands:**
```bash
# Start the Spring Boot server
./mvnw spring-boot:run

# Run tests
./mvnw test

# Build production JAR
./mvnw clean package
```

**Mobile App Commands:**
```bash
# Run on connected device/emulator
flutter run

# Build APK for Android
flutter build apk --release

# Build iOS app
flutter build ios --release

# Run tests
flutter test
```

## Development

We welcome developers who want to contribute to making fitness tracking more accessible and intelligent.

### Pre-Requisites

**Backend Development:**
- Java JDK 11 or higher
- Maven 3.6+
- MySQL 8.0 or higher
- PaddlePaddle OCR dependencies
- IDE (IntelliJ IDEA, Eclipse, or VS Code)

**Mobile Development:**
- Flutter SDK 3.0+
- Dart SDK (included with Flutter)
- Android Studio (for Android development)
- Xcode (for iOS development, macOS only)
- An Android/iOS device or emulator

### Development Environment

**Setting up Backend:**

1. Install Java JDK 11+
2. Install MySQL and create database:
```sql
CREATE DATABASE fitly_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

3. Configure `application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/fitly_db
spring.datasource.username=your_username
spring.datasource.password=your_password
spring.jpa.hibernate.ddl-auto=update
```

4. Install PaddlePaddle OCR dependencies:
```bash
pip install paddlepaddle paddleocr
```

**Setting up Mobile App:**

1. Install Flutter SDK from [flutter.dev](https://flutter.dev)
2. Run Flutter doctor to verify installation:
```bash
flutter doctor
```

3. Configure API endpoint in `lib/config/api_config.dart`:
```dart
class ApiConfig {
  static const String baseUrl = 'http://localhost:8080/api/v1';
  // Use 10.0.2.2 for Android emulator
  // Use actual IP for physical devices
}
```

4. Install dependencies:
```bash
flutter pub get
```

### File Structure

**Backend Structure:**

```
backend/
├── src/main/java/com/fitly/     # Main application package
│   ├── controllers/              # REST API endpoints
│   ├── services/                 # Business logic layer
│   ├── repositories/             # Data access layer
│   ├── models/                   # Database entity models
│   ├── config/                   # Configuration classes
│   └── ocr/                      # PaddleOCR integration service
├── src/main/resources/
│   └── application.properties    # Application configuration
└── pom.xml                       # Maven dependencies
```

**Mobile App Structure:**

```
mobile/
├── lib/
│   ├── main.dart                 # Application entry point
│   ├── screens/                  # UI screens and pages
│   ├── widgets/                  # Reusable UI components
│   ├── models/                   # Data models
│   ├── services/                 # API and business logic services
│   ├── providers/                # State management
│   ├── config/                   # App configuration
│   └── utils/                    # Helper functions and utilities
├── assets/                       # Images, fonts, and other assets
├── android/                      # Android-specific files
├── ios/                          # iOS-specific files
└── pubspec.yaml                  # Flutter dependencies
```

### Build

**Backend Build:**
```bash
# Development build
./mvnw clean install

# Production build (creates executable JAR)
./mvnw clean package -DskipTests
# Output: target/fitly-backend-1.0.0.jar
```

**Mobile App Build:**

```bash
# Android APK
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Android App Bundle (for Google Play)
flutter build appbundle --release

# iOS
flutter build ios --release
# Then archive in Xcode for App Store distribution
```

### Deployment

**Backend Deployment:**

1. **Using JAR file:**
```bash
java -jar target/fitly-backend-1.0.0.jar
```

2. **Using Docker:**
```dockerfile
FROM openjdk:11-jre-slim
COPY target/fitly-backend-1.0.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]
```

3. **Cloud Deployment:**
   - Deploy to AWS Elastic Beanstalk, Google Cloud Platform, or Heroku
   - Configure environment variables for database and OCR service
   - Set up MySQL instance (AWS RDS, Cloud SQL, etc.)

**Mobile App Deployment:**

1. **Android:**
   - Upload APK/AAB to Google Play Console
   - Configure store listing and screenshots
   - Submit for review

2. **iOS:**
   - Archive app in Xcode
   - Upload to App Store Connect
   - Complete app information and submit for review

### Guideline

**Code Style Guidelines:**

- **Backend (Java):** Follow standard Java conventions, use meaningful variable names, add JavaDoc comments for public methods
- **Mobile (Dart/Flutter):** Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide, use proper naming conventions
- Write unit tests for new features
- Ensure code is properly formatted before committing
- Write clear commit messages following conventional commits format

**API Development:**
- Use RESTful conventions
- Include proper error handling and status codes
- Document new endpoints in API documentation
- Validate input data

**UI/UX:**
- Follow Material Design guidelines
- Ensure responsive design for different screen sizes
- Maintain accessibility standards
- Test on both iOS and Android platforms

## FAQ

**Q: Does Fitly work offline?**  
A: The app requires internet connection for syncing data and accessing the OCR service. However, you can view previously loaded workout plans offline.

**Q: What InBody file formats are supported?**  
A: Currently, we support PDF and image formats (JPG, PNG) for InBody report uploads.

**Q: Is my fitness data secure?**  
A: Yes, all data is encrypted during transmission and stored securely in our database. We follow industry-standard security practices.

**Q: Can I export my workout history?**  
A: Yes, you can export your workout logs and progress data in CSV format from the app settings.

**Q: How accurate is the OCR extraction?**  
A: The PaddleOCR technology provides high accuracy for InBody reports. However, we recommend reviewing the extracted data before saving.

**Q: Is Fitly free to use?**  
A: Yes, Fitly is currently free to use with all features available.

## Resources

**Official Documentation:**
- [Flutter Documentation](https://flutter.dev/docs)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [PaddleOCR Documentation](https://github.com/PaddlePaddle/PaddleOCR)
- [MySQL Documentation](https://dev.mysql.com/doc/)

**Learning Resources:**
- [REST API Best Practices](https://restfulapi.net/)
- [Flutter State Management](https://flutter.dev/docs/development/data-and-backend/state-mgmt)
- [MySQL Database Design](https://dev.mysql.com/doc/workbench/en/wb-getting-started-tutorial-creating-a-model.html)

**Project Repository:**
- [GitHub Repository](https://github.com/hnglmiee/Fitly_WorkoutPlanner_Mobile)

## Gallery

[Project screenshots and images will be displayed here]

**Coming soon:**
- Dashboard overview
- Workout scheduling interface
- Exercise library
- InBody upload and extraction
- Progress tracking charts
- Mobile app screenshots (iOS and Android)

**Technologies Used:**
- Flutter & Dart
- Spring Boot & Java
- MySQL
- PaddlePaddle OCR
- Material Design
