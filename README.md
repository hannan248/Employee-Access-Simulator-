# Employee Access Simulator

This is my Flutter app for the Innovaxel internship take-home assessment. It simulates employee access to secure rooms based on their access levels, time restrictions, and cooldown periods.

## What I Built

I created a mobile app that loads employee data from a JSON file and simulates access control for different rooms in a building. The app checks if employees can enter rooms based on three main criteria: their access level, whether the room is open, and if they've violated any cooldown periods.

The rooms have different requirements:
- ServerRoom needs level 2 or higher, open from 9 AM to 11 AM, with 15 minutes cooldown
- Vault needs level 3, open from 9 AM to 10 AM, with 30 minutes cooldown
- R&D Lab needs level 1 or higher, open from 8 AM to 12 PM, with 10 minutes cooldown

## How It Works

When you run the simulation, the app processes all employee requests in chronological order. For each request, it checks the access requirements and either grants or denies access with a clear reason why.

I organized the code into different folders to keep everything clean:
- models for data structures
- services for the main logic
- utils for helper functions
- widgets for reusable UI components
- screens for the main app interface

## Setup and Running

Make sure you have Flutter installed, then:

```bash
flutter pub get
flutter run
```

The employee data is loaded from `assets/data/employees.json`, so you can easily modify the test data without changing the code.

## Features I Implemented

- Clean Material Design UI with cards and proper color coding
- Loads data from external JSON file as requested
- Shows room rules clearly so users understand the requirements
- Processes requests chronologically for accurate cooldown calculations
- Displays detailed results with reasons for each decision
- Summary statistics showing granted vs denied access
- Error handling for file loading issues
- Reset functionality to run simulation multiple times

## Technical Approach

I used Flutter's built-in state management and organized the code following clean architecture principles. The time calculations handle 24-hour format properly, and I made sure the cooldown logic works correctly by tracking previous accesses.

The UI is responsive and works on different screen sizes. I added loading states and error handling to make the app feel professional and robust.

This was a great project to work on and I'm excited to discuss my implementation choices and any improvements that could be made.