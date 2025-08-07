# Flutter Firebase Chat Application

This is a real-time 1-on-1 chat application built with **Flutter**, using **Firebase** as the backend and **GetX** for state management. It was developed as part of a recruitment assignment for the Flutter Developer role at STEMM One Cloudworks Pvt Ltd.

## 📱 Features

- 🔐 **Authentication** (Sign Up / Login)
- 🧑‍🤝‍🧑 1-on-1 chat between users
- 💬 Send and receive:
  - Text messages
  - Images
  - Documents (PDF, DOCX, etc.)
  - Videos
- 📇 **User list screen** displaying all registered users
- 👤 Tap on user display picture to view full profile
- ⚡ Real-time updates using Firebase Firestore
- 🎯 Clean architecture using **MVC pattern** and **GetX** for reactive state management

## 📂 Project Structure (MVC Pattern)
```
lib/
├── controller/       # Business logic (GetX Controllers)
├── model/            # Data models
├── view/             # UI screens & widgets
├── bindings/         # Dependency injection
├── services/         # Firebase/Auth/Storage handling
├── routes/           # Navigation routes using GetX
└── main.dart         # Entry point
```

## 🛠️ Tech Stack

- **Flutter**
- **Firebase Authentication**
- **Cloud Firestore**
- **Firebase Storage**
- **GetX** for state management and routing
- **MVC Architecture**

## 🔑 Requirements

- Flutter SDK (>=3.10.0)
- Firebase CLI (for deploying or testing functions)
- Android Studio / VS Code

## 🚀 Getting Started

```bash
# 1. Clone the repository
git clone https://github.com/your-username/flutter_firebase_chat.git
cd flutter_firebase_chat

# 2. Install dependencies
flutter pub get

# 3. Setup Firebase
# - Use Firebase CLI to initialize your project
# - Enable Authentication (Email/Password)
# - Create Firestore Database
# - Enable Firebase Storage

# 4. Run the app
flutter run
```

## 📦 APK & Demo

- [Download APK](https://your-apk-link.com) (replace with actual link)
- [Watch Demo Video](https://your-demo-link.com) (optional)

## 📧 Assignment Details

> This application was developed as an assignment for the Flutter Developer position at **STEMM One Cloudworks Pvt Ltd**, as outlined in the task received via email on **August 5, 2025**. All mentioned functionalities have been implemented.

## 👤 Author

**Ahmad Ali**  
📧 [aali.dev7@gmail.com](mailto:aali.dev7@gmail.com)  
🌐 [LinkedIn](https://www.linkedin.com/in/your-profile) | [GitHub](https://github.com/your-username)

---

Feel free to fork, contribute, or share your feedback!