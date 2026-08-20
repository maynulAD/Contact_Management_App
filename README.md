# Contact Management App

## Project Overview

The **Contact Management App** is a Flutter application designed to manage personal contacts using a local SQLite database.

The application provides basic CRUD operations along with contact search and favorite management.

## Project Details

**Project Name:** Contact Management App
**Platform:** Flutter
**Programming Language:** Dart
**Database:** SQLite
**Database Package:** `sqflite`

## Main Features

* Add new contacts
* View saved contacts
* Update contact information
* Delete contacts
* Search contacts by name
* Mark contacts as favorites
* View favorite contacts
* Store contact information locally

## Contact Information

Each contact contains:


Contact
│
├── ID
├── Name
├── Phone Number
├── Email
├── Address
└── Favorite Status


**Name** and **Phone Number** are required fields.

**Email** and **Address** can be optional.

## Application Flow


                    Contact Management App
                              │
              ┌───────────────┼───────────────┐
              │               │               │
           Contacts        Search         Favorites
              │               │               │
       ┌──────┼──────┐        │          Favorite List
       │      │      │        │
      Add   View   Details    │
       │      │      │        │
       │      │   ┌──┴───┐    │
       │      │   │      │    │
       │      │  Edit  Delete │
       │      │               │
       └──────┴───────────────┘
                      │
                 SQLite Database


## Database Structure


contacts
│
├── id
│   └── INTEGER PRIMARY KEY AUTOINCREMENT
│
├── name
│   └── TEXT NOT NULL
│
├── phone
│   └── TEXT NOT NULL
│
├── email
│   └── TEXT
│
├── address
│   └── TEXT
│
└── isFavorite
    └── INTEGER


## CRUD Operations


CREATE
  ↓
Add Contact
  ↓
SQLite Database

READ
  ↓
View Contacts
  ↓
Search / Favorites

UPDATE
  ↓
Edit Contact
  ↓
Update SQLite Record

DELETE
  ↓
Delete Contact
  ↓
Remove SQLite Record


## Project Architecture

lib/
│
├── database/
│   └── database_helper.dart
│
├── models/
│   └── contact.dart
│
├── screens/
│   ├── home_screen.dart
│   ├── add_edit_contact_screen.dart
│   ├── contact_details_screen.dart
│   ├── favorites_screen.dart
│   └── settings_screen.dart
│
├── widgets/
│   └── contact_avatar.dart
│
└── main.dart


## Technologies

* Flutter
* Dart
* SQLite
* `sqflite`
* `path`
* Material Design

## Author

**Md Gazi Maynul Hassan Moin**

**Project:** Flutter Contact Management App
