# Synology Web Autologin Script

This repository contains an automatic login script for websites, designed to run on Synology NAS devices using scheduled tasks.

## Description

The auto_login.sh script logs into multiple websites automatically by reading website login data from a CSV file (login_data.txt). The script can be scheduled to run periodically on a Synology NAS to ensure that you will not have your account deleted for not logging into certain websites for a long period of time.

## Limitations

- The script is based on `curl` and may not work for websites that require JavaScript, CAPTCHA, or have complex login mechanisms.
- The script requires the ability to run scheduled tasks on the device, which is available on Synology NAS devices through the Task Scheduler.

## Installation

1. Clone this repository or download the `auto_login.sh` and `login_data.txt` files.

2. Modify the `login_data.txt` file with the necessary login information for each website.

3. Update the target directory in the `auto_login.sh` file to match your own setup. The target directory should be the directory where the script and the login_data.txt file are located.

4. Upload the modified script and data file to your Synology NAS.

5. Set up a scheduled task on your Synology NAS device to run the script periodically. In Task Settings -> Run Command, add the path to the script. For example:
    ```
    Bash /volume1/homes/user/auto_login.sh
    ```
    For more information on how to create scheduled tasks, refer to the [official Synology documentation](https://www.synology.com/en-global/knowledgebase/DSM/help/DSM/AdminCenter/system_taskscheduler).

## Usage

- The `login_data.txt` file should contain the login information for each website, with one website per line. The format of each line should be:
  ```
  username,password,website_name,login_url,logout_url,check_url,element_to_check
  ```
- The `login_url` is not the same as the login webpage address, but rather the address where the POST request should be sent to. You can usually find it in the webpage source code.

- When the `logout_url` is "null" or empty, the program will not attempt to log in again if it is already logged in.

- We recommend setting the `element_to_check` to the username.

- We highly recommend you enable `Send run details only when the script terminates abnormally`.

## Disclaimer

- This script is provided "as-is" without warranty. Use at your own risk. Always ensure the security and privacy of your login information when using any auto-login scripts. 

- When using an automatic login script, it is important to ensure that it complies with the website's terms and conditions and usage agreements, in order to avoid violating the website's policies or triggering its security mechanisms.
