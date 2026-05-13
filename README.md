# MemberMe - Personal Task Manager App

A Flutter-based personal task manager mobile application built as part of the Mobile Application Development course (Level 400 Software Engineering).

## Developer
- **Name:** Awongu Agabi Therese-Claire
- **Student ID:** LMUI250709
- **Programme:** Software Engineering
- **Lecturer:** Atumkeze

---

## About the App
MembaMe is a personal task manager that helps you create, organize, and track your daily tasks. 
It was built entirely with Flutter using only built-in widgets and no external packages.

---

## Features

### Section 1 — Foundation
- Custom app theme using teal color scheme
- Debug banner disabled
- Profile screen with personal information, bio, and semester goals

### Section 2 — Core Features
- Task model with title, description, category, priority, due date, and completion status
- Task list using `ListView.builder` with custom `TaskCard` widget
- Strikethrough text for completed tasks
- Swipe left to delete a task
- Tap a task to view full details
- Empty state message when no tasks exist
- Add task via floating action button with a centered dialog form
- Dropdowns for category and priority selection
- Date picker for due date
- Form validation — no field can be left empty

### Section 3 — Advanced Features
- Task Detail Screen showing all task information
- Mark task as complete or incomplete
- Edit task with pre-filled form
- Delete task with confirmation dialog
- Filter tasks by All, Pending, or Completed
- Sort tasks by Due Date or Priority
- Statistics bar showing total, completed, and pending task counts
- Linear progress indicator showing completion percentage

### Section 4 — Navigation & Polish
- Bottom Navigation Bar with Tasks and Profile tabs
- Search tasks by title from the AppBar
- Clear all tasks with confirmation dialog
- Priority color coding — Red (High), Orange (Medium), Green (Low)
- Category icons — School, Health, Work, Personal
- Overdue tasks highlighted in red

---

## App Structure
lib/
├── main.dart
├── screens/
│   ├── profile_screen.dart
│   ├── task_list_screen.dart
│   └── task_detail_screen.dart
└── widgets/
└── task_card.dart

---

## How to Run

1. Make sure Flutter is installed — [Flutter Install Guide](https://flutter.dev/docs/get-started/install)
2. Clone this repository:
```bash
   git clone https://github.com/your-username/your-repo-name.git
```
3. Navigate into the project folder:
```bash
   cd your-repo-name
```
4. Get dependencies:
```bash
   flutter pub get
```
5. Run the app:
```bash
   flutter run
```

---

## State Management
This app uses `StatefulWidget` and `setState` only — no external state management packages.

## Packages Used
Flutter built-in widgets only — no external packages.

---
