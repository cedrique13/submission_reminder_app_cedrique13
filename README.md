# Submission Reminder App

## Overview
The Submission Reminder App is a simple Bash-based script designed to help track and remind students about pending assignment submissions. It creates a structured directory with essential configuration files, a reminder script, and functions to check pending submissions.

## Directory Structure
```
submission_reminder_<username>/
│-- app/
│   ├── reminder.sh
│-- modules/
│   ├── functions.sh
│-- assets/
│   ├── submissions.txt
│-- config/
│   ├── config.env
│-- startup.sh
```

## Installation & Setup
### 1. Run the Setup Script
To set up the submission reminder app, execute the script:
```bash
chmod +x setup.sh  # Ensure script is executable
./setup.sh
```

### 2. Provide Input
You will be prompted to enter your name. The script will create a personalized directory structure named `submission_reminder_<your_name>`.

### 3. Start the Application
Navigate to the created directory and run:
```bash
./startup.sh
```
This will start the reminder script.

## Features
- **Automated Setup**: The script initializes a structured directory.
- **Assignment Tracking**: Reads a file containing students and their submission statuses.
- **Reminders**: Displays pending assignments for students who have not submitted their work.

## Configuration
The `config.env` file contains:
```bash
ASSIGNMENT="Operating Systems"
DAYS_REMAINING=3
```
Modify these values to change the assignment name and due date countdown.

## Customization
- **Edit `submissions.txt`**: Add or remove student names and assignments.
- **Modify `config.env`**: Change the default assignment and due date.
- **Extend `functions.sh`**: Implement additional features like email notifications or logs.

## License
This project is open-source and can be modified as needed.


