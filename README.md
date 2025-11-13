# **ft\_hangouts**

An iOS mobile application developed with **SwiftUI** designed to handle local contact management and messaging functionality. This project focuses on demonstrating clean architecture principles and real-time database integration.

## **🚀 Project Overview**

ft\_hangouts is a comprehensive mobile application that serves as both a contact book and a basic messaging platform. By leveraging **Firebase for all data storage**—from the user's contact book to every message log—the application ensures data is always synchronized and instantly available without relying on local databases.

### **Key Features**

* **User Authentication:** Secure **Log In** and registration capabilities required to access the application and synchronize data with Firebase.
  
  <img src="https://github.com/user-attachments/assets/950d2a55-54b3-4abc-a2d5-705e174d5f22" width="200" />

* **Synchronized Contact Management:** Full CRUD (Create, Read, Update, Delete) capabilities for contacts, with **all data stored and synchronized instantly** via the Firebase backend.
  
  <img src="https://github.com/user-attachments/assets/2c8afe75-e3c5-46a8-802c-d968046e98fa" width="200" />

* **Real-time Chat:** Live messaging functionality powered by Firebase for instant communication between users.
  
  <img src="https://github.com/user-attachments/assets/0ececfc9-4351-4596-9a8c-1b760c9d511e" width="200" />

* **Multi-Language Support:** The user interface supports **three different languages**, handled through a dedicated localization service layer.
  
  <img src="https://github.com/user-attachments/assets/af195857-ebb6-4232-9937-10c89b8c4190" width="200" />

* **Responsive UI:** Built using declarative SwiftUI framework.
  

## **⚙️ Local Development Setup**

Follow these steps to clone the repository and run the project locally.

### **Prerequisites**

* **Xcode 16.4+**  
* **iOS 17.2+ SDK**  
* **Swift 5**

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
   ```  
    rules_version = '2';  
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
   ```  
2. **Indexes:** Create necessary **Firestore Indexes** for any complex queries involving sorting or multiple `where` clauses. The console will prompt you to create these when you run a query that requires one.  
   ```  
   [  
       {  
           "collectionId": "contacts",  
           "fields": [  
               { "fieldPath": "phoneNumber", "order": "ASCENDING" },  
               { "fieldPath": "userID", "order": "ASCENDING" }  
           ]  
       },  
       {  
           "collectionId": "messages",  
           "fields": [  
               { "fieldPath": "conversationId", "order": "ASCENDING" },  
               { "fieldPath": "timestamp", "order": "ASCENDING" }  
           ]  
       }  
   ]  
   ```

### **Firebase Cloud Functions**

This project **does not use Firebase Cloud Functions** for backend logic.

* **Constraint:** Cloud Functions require usage of the paid plan.  
* **Scalability Note:** For a highly secure and scalable application (e.g., processing sensitive server-side data validation, or implementing complex cross-user logic), the use of **Cloud Functions is essential** and highly recommended.

