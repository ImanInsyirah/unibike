UniBike is a mobile bike rental application developed using Flutter and Firebase. The application allows users to browse available bicycles, select rental durations, choose booking dates and times, and complete bookings through a simple and user-friendly interface.

This project was developed as part of an academic assignment to demonstrate mobile application development, user interface design, database and API integration, and booking management functionality.

---

## Features

### User Features

* Browse available bicycles
* View bike details and images
* Select rental duration
* Choose booking date and time
* Make bike reservations
* View booking confirmation
* Receive notifications
* Manage user profile information

---

## Technology Stack

### Frontend

* Flutter
* Dart

### Backend & Database

* Firebase Authentication
* Cloud Firestore
* Firebase Storage

### Development Tools

* Visual Studio Code
* Android Studio Emulator
* Git & GitHub

---

## Application Flow

1. Bike Selection
2. Duration Selection
3. Date and Time Selection
4. Booking Details
5. Payment Confirmation
6. Booking Success
7. Return to Home Screen

---

## Project Structure

```text
lib/
├── screens/
│   ├── bike_selection.dart
│   ├── duration_picker.dart
│   ├── bike_details.dart
│   ├── booking_details_page.dart
│   ├── payment_confirmation.dart
│   └── booking_success.dart
│
├── models/
├── services/
├── widgets/
└── main.dart
```

---

## Installation

### Prerequisites

* Flutter SDK
* Dart SDK
* Firebase Project
* Android Studio or VS Code

### Steps

1. Clone the repository

```bash
git clone https://github.com/your-username/unibike.git
```

2. Navigate to the project directory

```bash
cd unibike
```

3. Install dependencies

```bash
flutter pub get
```

4. Configure Firebase

* Create a Firebase project.
* Add Android and/or iOS applications.
* Download the Firebase configuration files.
* Place:

  * `google-services.json` inside `android/app/`
  * `GoogleService-Info.plist` inside `ios/Runner/`

5. Run the application

```bash
flutter run
```

---

## Screenshots

Add screenshots of:

* Home Screen
* Bike Selection Screen
* Booking Details Screen
* Payment Confirmation Screen
* Booking Success Screen

Example:

```markdown
![Home Screen](screenshots/home.png)
```

---

## Future Improvements

* Online payment gateway integration
* GPS tracking and navigation
* Real-time bike availability tracking
* Reward and loyalty system
* Booking history analytics

---

## Learning Outcomes

This project helped strengthen knowledge in:

* Flutter mobile application development
* Firebase integration
* User interface and user experience design
* Mobile application architecture
* Database management
* Version control using Git and GitHub

---

## Authors

Developed by Iman Insyirah and project team members as part of a university coursework project.

---

## License

This project is developed for educational purposes.
