# Real-Time Chat Application (Flutter)

## Overview

This is a simplified real-time chat mobile application built using **Flutter**, showcasing the following:

- **Real-Time Messaging**: Uses a WebSocket connection to send and receive messages immediately.
- **Backend Integration**: Demonstrates user authentication and message sending through a mock backend API.
- **Clean Architecture**: The codebase is organized into clear layers (presentation, domain, data).
- **Internationalization**: Support for English and Ukrainian via `easy_localization`.

## Requirements

- **Flutter SDK**: 3.24.0
- **Dart**: >=3.5.3 <4.0.0
- **Backend / API**: The WebSocket endpoint is a test service like `wss://echo.websocket.events`.

## Setup Instructions

1.  **Clone the Repository**:

        git clone <repository_url>
        cd <repository_folder>

2.  **Install Dependencies**:

        flutter pub get

3.  **Backend Setup** (Optional):

    \- The login endpoint is currently pointing to `https://for-work.pp.ua/test_chat.php`. You can replace this URL in `AuthRepositoryImpl` with your own server.

    \- For testing the WebSocket, `wss://echo.websocket.events` is used. You can replace it with a hosted WebSocket chat server.

    \*If you want to simulate your own backend:\*

    *   Use **simple PHP server** to create `POST /login` endpoint that returns a JSON response:

            {
              "success": true,
              "token": "auth_token"
            }

    *   Update `AuthRepositoryImpl` with your server URL.

4.  **Run the Application**:

        flutter run

## Assumptions & Limitations
- **Backend**: Although the login endpoint URL (https://for-work.pp.ua/test_chat.php) is functional, it is used here primarily for demonstration purposes.
- **WebSocket Server**: The chosen WebSocket endpoint (`wss://echo.websocket.events`) simply echoes back messages. This simulates a chat environment but does not provide actual multi-user chat unless you modify the endpoint.
- **Authentication**: The project demonstrates an example of a token-based authentication mechanism. However, this example does not fully implement all aspects of secure authentication, such as token persistence or renewal.
- **UI/UX**: The user interface is minimal and basic, focusing on demonstrating functionality rather than polished design.

## Localization

The project uses `easy_localization`:

*   Supported locales: `en`, `uk`
*   To add more translations, edit the JSON files in `assets/translations/`.
*   You can switch languages via the dropdown on the login screen.
