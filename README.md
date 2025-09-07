Todo Reminder App

![App Preview](https://github.com/user-attachments/assets/006d0358-df20-4f85-adfe-ae7e914adaf7)

A simple yet powerful **Todo Reminder application** built as part of an internship assignment. It enables users to manage daily tasks through a clean interface, secure authentication, and a reliable serverless backend.

---

## Features

- **Google Authentication** – Secure sign-in with Google using Supabase Auth.  
- **User Profiles** – Displays the user’s name and profile picture for a personalized experience.  
- **Task Management** – Full create, read, update, and delete functionality for todos.  
- **Push Notifications** – Server-triggered reminders sent via Firebase Cloud Messaging one hour before a deadline, powered by Supabase Edge Functions.  
- **User-Friendly Design** – A polished, responsive UI with smooth interactions and dialogs.  

---

## Technology Stack

- **Frontend**: Flutter  
- **Backend**: Supabase (Auth, Postgres, Edge Functions)  
- **Notifications**: Firebase Cloud Messaging (FCM)  
- **State Management**: Riverpod  

---

## System Architecture

```mermaid
flowchart TD
    User["User"] -->|Sign In| FlutterApp["Flutter App"]
    FlutterApp -->|Auth Request| SupabaseAuth["Supabase Auth"]
    FlutterApp -->|CRUD Todos| SupabaseDB["Supabase Postgres DB"]
    FlutterApp -->|Send FCM Token| SupabaseEdge["Supabase Edge Function"]
    SupabaseEdge --> Firebase["Firebase Cloud Messaging"]
    Firebase -->|Reminder Notification| User["User"]
