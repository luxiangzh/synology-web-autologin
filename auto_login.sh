#!/bin/bash

# Set working directory
target_directory="/volume1/homes/user"
cd "$target_directory" || { echo "Error: Failed to change directory to $target_directory"; exit 1; }

data_file="login_data.txt"
user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36"
log_file="auto_login.log"

function check_login() {
    local login_url=$1
    local check_url=$2
    local element_to_check=$3

    # Request check page
    check_page=$(curl -s -b cookies.txt -A "$user_agent" -e "$login_url" "$check_url")

    # Search for specific element
    if echo "$check_page" | grep -q "$element_to_check"; then
        return 0
    else
        return 1
    fi
}

while IFS=, read -ra login_data; do
    username="${login_data[0]}"
    password="${login_data[1]}"
    website_name="${login_data[2]}"
    login_url="${login_data[3]}"
    logout_url="${login_data[4]}"
    check_url="${login_data[5]}"
    element_to_check="${login_data[6]}"

    echo "Processing $website_name..."

    if check_login "$login_url" "$check_url" "$element_to_check"; then
        # If the login URL is null and the user is already logged in, exit program
        if [ -z "$logout_url" ] || [ "$logout_url" = "null" ]; then
            echo "Already logged in, exiting program."
            continue
        fi

        # Already logged in, log out
        echo "Already logged in, logging out!"
        curl -s -o /dev/null -c cookie.txt -b cookie.txt $logout_url

        # Check if logout is successful
        if check_login "$login_url" "$check_url" "$element_to_check"; then
            echo "Logout successful!"
        else
            echo "Logout failed!"
        fi
    fi

    # Get CSRF token
    csrf_token=$(curl -s "$login_url" | grep -oP 'name="csrf_token" value="\K[^"]+')

    # Build POST data
    post_data="csrf_token=$csrf_token&username=$username&password=$password"
    
    # Log in and save HTTP response status code
    response=$(curl -s -c cookies.txt -d "$post_data" -w "%{http_code}" -o /dev/null $login_url)

    # Log in and get response content, also display verbose output
    # response_content=$(curl -s -c cookies.txt -b cookies.txt -d "$post_data" -A "$user_agent" -v $login_url 2>&1)

    if check_login "$check_url" "$element_to_check"; then
        echo "Login successful!"
        echo "$(date) | $website_name: Login successful!" >> "$log_file"
    else
        echo "Login failed!"
        echo "$(date) | $website_name: Login failed! HTTP response status code: $response" >> "$log_file"
        exit 1;
    fi

    echo "-----"
    
done < "$data_file"
