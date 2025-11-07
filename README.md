# **ft\_hangouts**

An iOS mobile application developed with **SwiftUI** designed to handle local contact management and messaging functionality. This project focuses on demonstrating clean architecture principles, secure API key management via Git exclusion, and real-time database integration.

## **🚀 Project Overview**

ft\_hangouts is a comprehensive mobile application that serves as both a contact book and a basic messaging platform. By leveraging **Firebase for all data storage**—from the user's contact book to every message log—the application ensures data is always synchronized and instantly available without relying on local databases.

### **Key Features**

* **User Authentication:** Secure **Log In** and registration capabilities required to access the application and synchronize data with Firebase.  
* **Synchronized Contact Management:** Full CRUD (Create, Read, Update, Delete) capabilities for contacts, with **all data stored and synchronized instantly** via the Firebase backend.  
* **Real-time Chat:** Live messaging functionality powered by Firebase for instant communication between users.  
* **Multi-Language Support:** The user interface supports **three different languages**, handled through a dedicated localization service layer.  
* **Responsive UI:** Built using declarative SwiftUI framework.

### **🛠️ Technical Stack & Logic**

| Component | Technology / Logic Used | Description |
| :---- | :---- | :---- |
| **Framework** | **SwiftUI** | Used for building the entire user interface and ensuring a modern, declarative structure. |
| **Networking/Backend** | **Firebase** | Used for real-time synchronization of all persistent user data, including contact management and messaging, as well as handling user authentication. |
| **Dependency Injection** | **Service Manager** | Services (e.g., ColorThemeManager, LocalizationManager) are instantiated and managed to ensure code decoupling. |
| **Architecture** | **MVVM (Model-View-ViewModel)** | All feature modules follow this pattern, using **ViewModels** to handle business logic and expose state to **Views**. |

## **⚙️ Local Development Setup**

Follow these steps to clone the repository and run the project locally.

### **Prerequisites**

* **Xcode 15+**  
* **iOS 17+ SDK**  
* **Swift 5**

### **1\. Clone the Repository**

Clone the project using the SSH protocol.

### **2\. Install Dependencies**

This project uses **Swift Package Manager (SPM)** for external libraries (Firebase). Xcode will automatically fetch all necessary packages (modules) upon opening the project for the first time. **No manual installation command is required.**

## **🔗 Firebase Backend Setup**

This project requires a Firebase project for its messaging functionality. Since configuration files are ignored by Git, you must create your own server and link it locally.

### **1\. Create a Firebase Project**

1. Go to the [Firebase Console](https://console.firebase.google.com/).  
2. Create a **new project**.

### **2\. Register an iOS App**

1. In your new Firebase project, click **"Add app"** and select the **iOS** icon.  
2. Enter the required details:  
   * **iOS Bundle ID:** This must match the Bundle Identifier in your Xcode project..  
   * **App Nickname:** ft\_hangouts  
3. Click **"Register app."**

### **3\. Manual Xcode Configuration (Capabilities & URL Schemes)**

For full functionality, specifically handling authentication and background processing, you must manually configure Xcode:

1. Capabilities: In your target settings, enable Push Notifications.  
2. URL Scheme: Navigate to the Info tab in your target settings and add a URL Type using the GOOGLE\_APP\_ID and BUNDLE\_ID found inside your GoogleService-Info.plist file.

### **4\. Download and Add the Config File**

1. Firebase will prompt you to download the **GoogleService-Info.plist** file. Download it.  
2. Open your cloned Xcode project.  
3. **Crucial Step:** Drag the downloaded GoogleService-Info.plist file into the root ft\_hangouts group in the Xcode Project Navigator.  
   * In the dialog box, ensure the **ft\_hangouts** target is **CHECKED** under "Add to targets."

### **5\. Configure Firebase Services (Security & Indexes)**

Once the app is running, you must configure the following in your Firebase Console:

1. **Security Rules:** Set up **Firestore Security Rules** to control access to your data collections. For production-ready apps, these rules must enforce user authentication and data ownership.  
   \`\`\`  
   rules\_version \= '2';  
   service cloud.firestore {  
   	match /databases/{database}/documents {  
     
       match /users/{userId} {  
       	allow read, write: if true;  
   		}  
     
       match /contacts/{contactId} {  
         allow read, write: if true;  
       }  
     
       match /conversations/{conversationId} {  
         allow read, write: if true;  
       }  
     
       match /messages/{messageId} {  
         allow read, write: if true;  
       }  
   	}  
   }  
   \`\`\`  
2. **Indexes:** Create necessary **Firestore Indexes** for any complex queries involving sorting or multiple `where` clauses. The console will prompt you to create these when you run a query that requires one.  
   \`\`\`  
   \[  
       {  
           "collectionId": "contacts",  
           "fields": \[  
               { "fieldPath": "phoneNumber", "order": "ASCENDING" },  
               { "fieldPath": "userID", "order": "ASCENDING" }  
           \]  
       },  
       {  
           "collectionId": "messages",  
           "fields": \[  
               { "fieldPath": "conversationId", "order": "ASCENDING" },  
               { "fieldPath": "timestamp", "order": "ASCENDING" }  
           \]  
       }  
   \]  
   \`\`\`

## **🔒 Security Note**

The GoogleService-Info.plist file contains public API keys and is **securely excluded** from this Git repository via the .gitignore file to prevent accidental exposure of your Firebase project ID. Never commit this file.

## **⚠️ Constraints & Scalability**

This minimal version of the application avoids certain paid features to run entirely on the Firebase free tier, though they are recommended for production:

### **Firebase Cloud Functions**

This project **does not use Firebase Cloud Functions** for backend logic.

* **Constraint:** Cloud Functions require usage of the paid plan.  
* **Scalability Note:** For a highly secure and scalable application (e.g., processing sensitive server-side data validation, or implementing complex cross-user logic), the use of **Cloud Functions is essential** and highly recommended.

