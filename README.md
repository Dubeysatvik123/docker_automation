# Docker Automation Tool

A versatile shell-based Docker automation tool that caters to both beginners and advanced users. It includes basic Docker operations, AI-assisted Dockerfile generation, and prompt-based Docker command execution.

---

## Features

### Beginner Mode
A comprehensive set of options for managing Docker resources:

1. **List Containers**
2. **Start a Container**
3. **Stop a Container**
4. **Remove a Container**
5. **List Images**
6. **Remove Unused Images**
7. **Cleanup System**
8. **View Logs**
9. **List Networks**
10. **Create a Network**
11. **Remove a Network**
12. **List Volumes**
13. **Create a Volume**
14. **Remove a Volume**
15. **Attach Volume to a Container**
16. **Troubleshoot a Container**

### Pro Mode
Advanced AI-powered capabilities:

1. **Execute Docker Commands**:
   - Describe the command in plain English, and the tool executes it using `aichat -e`.

2. **Generate Dockerfile**:
   - Provide a description of your application, and the tool generates a Dockerfile using `aichat -c`.
   - Optionally build the generated Dockerfile into a Docker image.

---

## Prerequisites

- **Docker**: Installed and configured on your system.
- **AI Chat Tool**: Ensure `aichat` is installed and accessible from your shell.
- **Bash**: Compatible with bash shell.

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Dubeysatvik123/docker_automation.git
   cd docker_automation
   ```

2. Make the script executable:
   ```bash
   chmod +x dock_ai.sh
   ```

---

## Usage

1. Run the tool:
   ```bash
   ./dock_ai.sh
   ```

2. Choose a mode:
   - **Beginner Mode**: Select "1" for basic Docker operations.
   - **Pro Mode**: Select "2" for AI-assisted Docker management.
   - **Exit**: Select "3" to quit the tool.

---

## Beginner Mode Options

- Perform essential Docker tasks like listing, starting, stopping, and removing containers.
- Manage Docker images, networks, and volumes.
- Troubleshoot containers and cleanup unused resources.

### Example:
To list all containers:
```bash
Select an option [1-17]: 1
```

---

## Pro Mode Options

### 1. Execute Docker Command
Provide a description, and the tool runs the command using AI:
```bash
Enter the command you want to execute (describe in plain English): List all running containers
```

### 2. Generate Dockerfile
Generate a Dockerfile based on a description:
```bash
Describe the application or setup for the Dockerfile: A Python Flask app with dependencies installed via pip.
```

The tool generates and saves the Dockerfile. You will be prompted to build it:
```bash
Do you want to build the Dockerfile? (yes/no): yes
```

---

## Contribution

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature-branch
   ```
3. Make your changes and commit:
   ```bash
   git commit -m "Add new feature"
   ```
4. Push to your fork and submit a pull request.

---

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---

## Contact

For issues or suggestions, please create an issue in the GitHub repository or contact:

- satvikdubey268@gmail.com
- **GitHub**: [Dubeysatvik123](https://github.com/Dubeysatvik123)

