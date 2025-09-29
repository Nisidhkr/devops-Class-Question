# 🖥️ System Health & Admin Menu Script

This Bash script provides a **menu-driven tool** for common system administration and troubleshooting tasks.  
It helps with system health checks, process monitoring, user & group management, file organization, network diagnostics, scheduling tasks, and SSH key setup.

---

## 🚀 Features

1. **System Health Check**  
   - Generates a `system_report.txt` with:
     - Disk usage (`df -h`)
     - CPU info (`lscpu`)
     - Memory usage (`free -h`)
   - Displays the first 10 lines of the report.

2. **Active Processes**  
   - Displays active processes (`top`)
   - Lets you search for processes by keyword
   - Shows the number of matching processes

3. **User & Group Management**  
   - Creates new users and groups
   - Assigns a default password
   - Changes file ownership to the new user/group

4. **File Organizer**  
   - Organizes files in a directory into:
     - `images/` (jpg, png)
     - `docs/` (txt, md)
     - `scripts/` (sh)
   - Uses `tree` to show the new directory structure

5. **Network Diagnostics**  
   - Asks for a website and runs:
     - `ping -c 4`
     - `dig`
     - `curl -I`
   - Saves results into `networkReport.txt`

6. **Scheduled Task Setup**  
   - Prompts for script path and time (minute/hour)
   - Adds a cron job for automated execution

7. **SSH Key Setup**  
   - Generates an RSA SSH key
   - Displays the public key (`~/.ssh/id_rsa.pub`)

---

## ⚙️ Usage

1. Make the script executable:
   ```bash
   chmod +x ce87242a-ecfe-41ea-91ec-68e8ed9d407b.sh
