#!/usr/bin/env bash
# Script to create submission reminder app environment

# Ask for user's name
read -p "Enter your name: " name

# Create main application directory
main_dir="submission_reminder_${name}"
mkdir -p "$main_dir/app" "$main_dir/modules" "$main_dir/assets" "$main_dir/config"

# Create config.env in the config directory
cat > "$main_dir/config/config.env" << 'EOL'
# App Configuration
ASSIGNMENT="Operating Systems"
DAYS_REMAINING=3
EOL

# Create reminder.sh in the app directory
cat > "$main_dir/app/reminder.sh" << 'EOL'
#!/usr/bin/env bash

# Source environment variables and helper functions
source ../config/config.env
source ../modules/functions.sh

# Path to the submissions file
submissions_file="../assets/submissions.txt"

# Print assignment details
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

# Check submissions
check_submissions "$submissions_file"
EOL
chmod +x "$main_dir/app/reminder.sh"

# Create functions.sh in the modules directory
cat > "$main_dir/modules/functions.sh" << 'EOL'
#!/usr/bin/env bash

# Function to check pending submissions
check_submissions() {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file..."

    # Skip the header and iterate through lines
    while IFS=',' read -r student assignment status; do
        # Trim whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOL
chmod +x "$main_dir/modules/functions.sh"

# Create submissions.txt in the assets directory
cat > "$main_dir/assets/submissions.txt" << 'EOL'
student, assignment, submission status
Mugisha, Operating Systems, not submitted
Aline, Data Structures, submitted
Peter, Computer Networks, not submitted
Zuba, Databases, submitted
Benjamin, Web Development, not submitted
Iradukunda, Algorithms, not submitted
Uwase, Computer Networks, submitted
Kwizera, Cybersecurity, not submitted
Niyonzima, Artificial Intelligence, not submitted
Cedrick, Databases, submitted
Ishimwe, Software Engineering, not submitted
Gasana, Cloud Computing, submitted
Ingabire, Operating Systems, not submitted
Kayinamura, Machine Learning, not submitted
Manzi, Shell Scripting, not submitted
EOL

# Create startup.sh in the main directory
cat > "$main_dir/startup.sh" << 'EOL'
#!/usr/bin/env bash
# Start the submission reminder app

echo "Starting Submission Reminder App..."
./app/reminder.sh
EOL
chmod +x "$main_dir/startup.sh"

echo "Environment setup complete in directory: $main_dir"

