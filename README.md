# 🌩️ Storm Chaser – Weather Updates App

Storm Chaser is a modern iOS weather updates app that enables users to post and explore real-time weather conditions shared by the community. With support for offline usage, dark mode, image carousels, and map integration, it delivers a dynamic experience tailored for weather enthusiasts.


## 📱 Features

### ✅ Authentication
- 🔐 Google Sign-In with Firebase Authentication.

### 🌦️ Weather Updates
- Auto-fetches current location using Core Location.
- Retrieves live weather data including:
  - 🌡 Temperature
  - 🌧 Precipitation
  - 🌬 Wind Speed

### 🧭 Navigation
- **Bottom Tab Bar** with:
  - **All Weather Posts**: Explore posts shared by all users.
  - **Settings**: View current user info and log out.

### 📝 Create & View Posts
- Add new weather updates with:
  - Automatically fetched weather data.
  - Multiple image uploads.
  - User-written description.
- View post details including:
  - 📍 City name, Latitude & Longitude
  - 🌡 Weather details at the time of posting
  - 🖼 Slidable Image Carousel
  - 🗺 Embedded Mini Map

### 🌙 Dark Mode
- Full support for iOS light and dark themes.

### 📡 Offline Mode
- Offline access using **Core Data**.
- Allows viewing **only current user's posts** when offline.



## 🛠 Tech Stack

| Layer          | Tool/Framework            |
|----------------|---------------------------|
| **Language**   | Swift                     |
| **UI**         | UIKit                     |
| **Auth**       | Firebase Authentication   |
| **Weather API**| [OpenMeteo](https://open-meteo.com/)|
| **Storage**    | Core Data (Offline Support), Firebase Storage |
| **Location**   | Core Location             |
| **Maps**       | MapKit                    |
