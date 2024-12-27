d_help() {
  echo "                 DOX - Docker Automation Tool"
  echo "=================================================================="
  echo "Options:"
  echo "  1. Docker operations"
  echo "  2. Generate Dockerfile and code"
  echo "  3. Build Dockerfile"
  echo "  4. Exit"
  echo "=================================================================="
}
operations() {
  echo "Enter a prompt to generate a Docker command to execute:"
  read -r prompt
  echo "Executing Docker command based on prompt: $prompt"
  command=$(aichat -e "$prompt" 2>/dev/null)
  if [ $? -ne 0 ] || [ -z "$command" ]; then
    echo "Error: Failed to generate command using aichat. Please check your setup."
    return
  fi
  echo "Generated command: $command"
  eval "$command"
}

dockerfile() {
  echo "Enter a prompt to generate Dockerfile code:"
  read -r prompt
  echo "Generating Dockerfile code for prompt: $prompt"
  ai_output=$(aichat -c "$prompt" 2>/dev/null)
  if [ $? -ne 0 ] || [ -z "$ai_output" ]; then
    echo "Error: Failed to generate Dockerfile using aichat. Please check your setup."
    return
  fi

  echo "$ai_output" >> Dockerfile
  echo "Dockerfile generated successfully."
}

build() {
  echo "Enter the name for the Docker image:"
  read -r image_name
  if [ -z "$image_name" ]; then
    echo "Image name cannot be empty. Using default name 'generated_image'."
    image_name="generated_image"
  fi

  echo "Building Docker image named $image_name using Dockerfile..."
  docker build -t "$image_name" .
  if [ $? -ne 0 ]; then
    echo "Error: Failed to build the Docker image."
    return
  fi
  echo "Docker image '$image_name' built successfully."
}


while true; do
  d_help
  echo "Choose an option (1-4):"
  read -r choice

  case $choice in
    1)
     operations
      ;;
    2)
     dockerfile
      ;;
    3)
      build
      ;;
    4)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid option. Please choose again."
      ;;
  esac
done
