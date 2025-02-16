#!/usr/bin/env bash
# Script to create submission reminder app environment

# Ask for user's name
echo "Please enter your name: "
read -r name

# Create main directory
main_dir="submission_reminder_${name}"
mkdir -p "$main_dir"

# Create subdirectories
mkdir -p "$main_dir/config"
mkdir -p "$main_dir/src"
mkdir -p "$main_dir/data"
mkdir -p "$main_dir/logs"

# Create files
# Config file
cat > "$main_dir/config/config.env" << 'EOL'
# App configuration
APP_NAME="Submission Reminder"
LOG_FILE="../logs/app.log"
DATA_FILE="../data/submissions.txt"
CHECK_INTERVAL=3600  # in seconds
EOL

# Functions file
cat > "$main_dir/src/functions.sh" << 'EOL'
#!/usr/bin/env bash

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Function to check submission deadlines
check_deadlines() {
    while IFS=',' read -r student assignment deadline status; do
        if [ "$status" = "pending" ]; then
            current_time=$(date +%s)
            deadline_time=$(date -d "$deadline" +%s)
            time_diff=$((deadline_time - current_time))
            
            if [ $time_diff -lt 86400 ] && [ $time_diff -gt 0 ]; then
                log_message "WARNING: $student has less than 24 hours to submit $assignment"
                echo "REMINDER: $student has less than 24 hours to submit $assignment"
            fi
        fi
    done < "$DATA_FILE"
}
EOL

# Reminder script
cat > "$main_dir/src/reminder.sh" << 'EOL'
#!/usr/bin/env bash

# Source configuration and functions
source ../config/config.env
source ./functions.sh

# Main reminder loop
while true; do
    echo "Checking submission deadlines..."
    check_deadlines
    sleep "$CHECK_INTERVAL"
done
EOL

# Create submissions.txt with sample data
cat > "$main_dir/data/submissions.txt" << 'EOL'
John Doe,Project 1,2025-02-20,pending
Jane Smith,Assignment 2,2025-02-18,submitted
Mike Johnson,Lab Report,2025-02-19,pending
Sarah Williams,Final Paper,2025-02-21,pending
Alex Brown,Quiz 1,2025-02-17,submitted
James Wilson,Project 2,2025-02-22,pending
Emily Davis,Assignment 3,2025-02-23,pending
David Miller,Lab Exercise,2025-02-24,pending
EOL

# Create startup script
cat > "$main_dir/startup.sh" << 'EOL'
#!/usr/bin/env bash
# Script to start the submission reminder application

# Change to src directory
cd src || exit

# Start the reminder script
./reminder.sh &

echo "Submission reminder application started!"
echo "Process ID: $!"
EOL

# Make scripts executable
chmod +x "$main_dir/src/functions.sh"
chmod +x "$main_dir/src/reminder.sh"
chmod +x "$main_dir/startup.sh"

# Create log file
touch "$main_dir/logs/app.log"

echo "Environment created successfully!"
echo "To start the application, navigate to $main_dir and run ./startup.sh"
