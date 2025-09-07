Todo Reminder App
![Image](https://github.com/user-attachments/assets/006d0358-df20-4f85-adfe-ae7e914adaf7)
A simple yet powerful Todo Reminder application built for an internship assignment. It allows users to manage their daily tasks with a clean interface, secure authentication, and a robust serverless backend.

Key Features
Secure Google Authentication: Simple and secure sign-in using a user's Google account, powered by Supabase Auth.

User Profile Display: Fetches and displays the user's name and Google profile picture for a personalized experience.

Full CRUD Functionality: Complete Create, Read, Update, and Delete operations for todos. Users can add tasks, edit them, mark them as complete, and delete them.

Server-Triggered Push Notifications: A professional, serverless architecture using Supabase Edge Functions to trigger Firebase Cloud Messaging (FCM) push notifications one hour before a todo's deadline, ensuring reliability even when the app is closed.

Polished & Responsive UI: A clean, card-based interface with smooth interactions and helpful dialogs for a great user experience.

Tech Stack
Frontend: Flutter

Backend: Supabase (Auth, Postgres DB, Edge Functions)

Push Notifications: Firebase Cloud Messaging (FCM)

State Management: Flutter Riverpod

Setup Instructions for Reviewers
To run this project, you will need to configure your own Supabase and Firebase projects.

1. Clone & Configure Environment
   Clone this repository to your local machine.

In the root of the project, create a new file named .env.

Copy the contents of the .env.example below and paste it into your new .env file.

.env.example
# Supabase Config (from your Supabase Project Settings > API)
SUPABASE_URL=YOUR_SUPABASE_URL
SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY

# Google OAuth Web Client ID (from your Google Cloud Console > Credentials)
GOOGLE_WEB_CLIENT_ID=YOUR_GOOGLE_WEB_CLIENT_ID.apps.googleusercontent.com
2. Firebase / Google Cloud Setup
   Create a new project in the Firebase Console.

In the associated Google Cloud project, enable the Firebase Cloud Messaging API.

Go to APIs & Services -> Credentials and create an OAuth 2.0 Client ID for a Web application. Use this Client ID for the GOOGLE_WEB_CLIENT_ID value in your .env file.

Create another OAuth 2.0 Client ID for Android. To get your SHA-1 fingerprint, run ./gradlew signingReport in the project's android directory and add the debug SHA-1 key to this credential.

3. Supabase Project Setup
   Create a new project in Supabase.

Go to the SQL Editor and run the SQL queries to create the todos and profiles tables and their RLS policies.

Go to Authentication -> Providers -> Google.

Enable the Google provider. Use the Web Client ID and Client Secret from the previous step.

Add your Android Client ID to the list of Authorized Client IDs.

Fill in the SUPABASE_URL and SUPABASE_ANON_KEY in your .env file using the keys from your Supabase project's API settings.

4. Run the Flutter App
   Once the .env file is configured, run the following commands:

Bash

flutter pub get
flutter run
5. Edge Function Setup (for Notifications)
   In your Firebase project settings, go to Service accounts and Generate new private key to download your service account .json file.

In your Supabase project dashboard, go to Project Settings -> Edge Functions -> Secrets and create a new secret named FIREBASE_SERVICE_ACCOUNT. Paste the entire content of the downloaded .json file as the value.

Deploy the function by running npx supabase functions deploy send-reminders --no-verify-jwt.

Schedule the function by running the cron.schedule command in the Supabase SQL Editor (remember to replace the placeholders with your own project ref and anon key).
Push Notification Status
The application is architected to use a Supabase Edge Function for reliable, server-triggered FCM push notifications. The complete code for the Flutter app to save its FCM token and the server-side Edge Function (index.ts) to handle the scheduling and sending logic is implemented and deployed.

Current Status: During final testing, the Edge Function was blocked by a persistent unauthorized_client error from Google's authentication servers. This error persists even after verifying the service account credentials, enabling the Firebase Cloud Messaging API, and granting the service account the project "Editor" role in IAM. This points to a platform-level permission or configuration issue within the original Google Cloud project. The existing code represents the correct and final implementation for this architecture.
