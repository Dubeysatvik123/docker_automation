#!/bin/bash

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

display_main_menu() {
    echo -e "${BLUE}Docker Management Tool${RESET}"
    echo -e "${YELLOW}1. Beginner Mode (Basic Docker Management)${RESET}"
    echo -e "${YELLOW}2. Pro Mode (AI Chat for Commands and Dockerfile)${RESET}"
    echo -e "${YELLOW}3. Exit${RESET}"
}

list_containers() { docker ps -a; }
start_container() { 
    list_containers
    read -p "Enter the container ID or name to start: " container
    docker start "$container"
}
stop_container() { 
    list_containers
    read -p "Enter the container ID or name to stop: " container
    docker stop "$container"
}
remove_container() { 
    list_containers
    read -p "Enter the container ID or name to remove: " container
    docker rm "$container"
}
list_images() { docker images; }
remove_unused_images() { docker image prune -f; }
cleanup_system() { docker system prune -af; }
view_logs() { 
    list_containers
    read -p "Enter the container ID or name to view logs: " container
    docker logs -f "$container"
}
list_networks() { docker network ls; }
create_network() { read -p "Enter the network name to create: " network; docker network create "$network"; }
remove_network() { 
    list_networks
    read -p "Enter the network name to remove: " network; 
    docker network rm "$network"; 
}
list_volumes() { docker volume ls; }
create_volume() { read -p "Enter the volume name to create: " volume; docker volume create "$volume"; }
remove_volume() { 
    list_volumes
    read -p "Enter the volume name to remove: " volume; 
    docker volume rm "$volume"; 
}
attach_volume_to_container() { 
    read -p "Enter the container name: " container
    read -p "Enter the volume name: " volume
    docker run -v "$volume:/data" --name "$container" alpine sh -c "echo 'Volume attached' > /data/test.txt"
}
troubleshoot_container() { 
    read -p "Enter the container ID or name to troubleshoot: " container
    docker inspect "$container"
    docker logs "$container"
    docker stats --no-stream "$container"
}
pull_image() { read -p "Enter the image name to pull: " image; docker pull "$image"; }
create_container() { 
    read -p "Enter the image name: " image
    read -p "Enter the container name: " container
    docker run -dit --name "$container" "$image"
}
remove_image() { 
    list_images
    read -p "Enter the image name or ID to remove: " image
    docker rmi "$image"
}

beginner_mode() {
    echo -e "${GREEN}Entering Beginner Mode...${RESET}"
    while true; do
        echo -e "${YELLOW}1. Start a Container${RESET}"
        echo -e "${YELLOW}2. Stop a Container${RESET}"
        echo -e "${YELLOW}3. Remove a Container${RESET}"
        echo -e "${YELLOW}4. List Containers${RESET}"
        echo -e "${YELLOW}5. List Images${RESET}"
        echo -e "${YELLOW}6. Remove Unused Images${RESET}"
        echo -e "${YELLOW}7. Cleanup System${RESET}"
        echo -e "${YELLOW}8. View Logs${RESET}"
        echo -e "${YELLOW}9. List Networks${RESET}"
        echo -e "${YELLOW}10. Create a Network${RESET}"
        echo -e "${YELLOW}11. Remove a Network${RESET}"
        echo -e "${YELLOW}12. List Volumes${RESET}"
        echo -e "${YELLOW}13. Create a Volume${RESET}"
        echo -e "${YELLOW}14. Remove a Volume${RESET}"
        echo -e "${YELLOW}15. Attach Volume to Container${RESET}"
        echo -e "${YELLOW}16. Troubleshoot Container${RESET}"
        echo -e "${YELLOW}17. Pull an Image${RESET}"
        echo -e "${YELLOW}18. Create a Container${RESET}"
        echo -e "${YELLOW}19. Remove an Image${RESET}"
        echo -e "${YELLOW}20. Exit to Main Menu${RESET}"
        read -p "Select an option [1-20]: " option
        case $option in
            1) start_container ;;
            2) stop_container ;;
            3) remove_container ;;
            4) list_containers ;;
            5) list_images ;;
            6) remove_unused_images ;;
            7) cleanup_system ;;
            8) view_logs ;;
            9) list_networks ;;
            10) create_network ;;
            11) remove_network ;;
            12) list_volumes ;;
            13) create_volume ;;
            14) remove_volume ;;
            15) attach_volume_to_container ;;
            16) troubleshoot_container ;;
            17) pull_image ;;
            18) create_container ;;
            19) remove_image ;;
            20) echo -e "${BLUE}Returning to Main Menu...${RESET}" ; break ;;
            *) echo -e "${RED}Invalid option. Please try again.${RESET}" ;;
        esac
        echo ""
    done
}

pro_mode() {
    echo -e "${GREEN}Entering Pro Mode...${RESET}"
    while true; do
        echo -e "${YELLOW}1. Execute Docker Command (Prompt-Based with AI)${RESET}"
        echo -e "${YELLOW}2. Generate Dockerfile (AI-Powered)${RESET}"
        echo -e "${YELLOW}3. Exit to Main Menu${RESET}"
        read -p "Select an option [1-3]: " option
        case $option in
            1) 
                read -p "Enter the command you want to execute (describe in plain English): " prompt
                echo -e "${YELLOW}Executing command: ${prompt}${RESET}"
                aichat -e "$prompt"
                ;;
            2) 
                read -p "Describe the application or setup for the Dockerfile: " docker_prompt
                echo -e "${YELLOW}Generating Dockerfile based on prompt: ${docker_prompt}${RESET}"
                aichat -c "Generate a Dockerfile for: $docker_prompt" > Dockerfile
                if [[ $? -eq 0 ]]; then
                    echo -e "${GREEN}Dockerfile successfully generated and saved as 'Dockerfile'.${RESET}"
                    cat Dockerfile
                    read -p "Do you want to build the Dockerfile? (yes/no): " build_choice
                    if [[ "$build_choice" == "yes" ]]; then
                        docker build -t generated-image .
                        echo -e "${GREEN}Dockerfile built successfully as 'generated-image'.${RESET}"
                    else
                        echo -e "${BLUE}Build skipped.${RESET}"
                    fi
                else
                    echo -e "${RED}Error: Failed to generate Dockerfile.${RESET}"
                fi
                ;;
            3) echo -e "${BLUE}Returning to Main Menu...${RESET}" ; break ;;
            *) echo -e "${RED}Invalid option. Please try again.${RESET}" ;;
        esac
        echo ""
    done
}

while true; do
    display_main_menu
    read -p "Select a mode [1-3]: " mode
    case $mode in
        1) beginner_mode ;;
        2) pro_mode ;;
        3) echo -e "${BLUE}Exiting...${RESET}" ; exit ;;
        *) echo -e "${RED}Invalid option. Please try again.${RESET}" ;;
    esac
    echo ""
done
