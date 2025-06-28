import streamlit as st
import requests
import json
from datetime import datetime

st.title("Docker Manager")

# Configuration
st.sidebar.header("Docker Host Configuration")
docker_host = st.sidebar.text_input(
    "Docker Host URL", 
    value="http://localhost:2376",
    help="Enter your Docker daemon API endpoint"
).rstrip('/')

# API Headers
headers = {"Content-Type": "application/json"}

def make_docker_request(endpoint, method="GET", data=None):
    """Make request to Docker API"""
    try:
        url = f"{docker_host}{endpoint}"
        
        if method == "GET":
            response = requests.get(url, headers=headers, timeout=10)
        elif method == "POST":
            response = requests.post(url, headers=headers, json=data, timeout=30)
        elif method == "DELETE":
            response = requests.delete(url, headers=headers, timeout=10)
        
        if response.status_code == 200:
            return response.json(), None
        else:
            return None, f"Error {response.status_code}: {response.text}"
    
    except requests.exceptions.ConnectionError:
        return None, "Cannot connect to Docker daemon. Make sure Docker API is accessible."
    except requests.exceptions.Timeout:
        return None, "Request timed out. Docker daemon might be busy."
    except Exception as e:
        return None, f"Error: {str(e)}"

def format_container_info(containers):
    """Format container information for display"""
    if not containers:
        return "No containers found"
    
    output = []
    for container in containers:
        name = container.get('Names', ['unnamed'])[0].lstrip('/')
        image = container.get('Image', 'unknown')
        status = container.get('Status', 'unknown')
        ports = container.get('Ports', [])
        
        port_info = ""
        if ports:
            port_list = []
            for port in ports:
                if 'PublicPort' in port:
                    port_list.append(f"{port.get('PrivatePort', '?')}:{port.get('PublicPort', '?')}")
            if port_list:
                port_info = f" | Ports: {', '.join(port_list)}"
        
        output.append(f"• {name} | {image} | {status}{port_info}")
    
    return "\n".join(output)

def format_image_info(images):
    """Format image information for display"""
    if not images:
        return "No images found"
    
    output = []
    for image in images:
        repo_tags = image.get('RepoTags', ['<none>:<none>'])
        size = image.get('Size', 0)
        size_mb = round(size / (1024 * 1024), 1)
        created = datetime.fromtimestamp(image.get('Created', 0)).strftime('%Y-%m-%d %H:%M')
        
        for tag in repo_tags:
            output.append(f"• {tag} | {size_mb} MB | Created: {created}")
    
    return "\n".join(output)

# Test connection
if st.button("Test Docker Connection"):
    result, error = make_docker_request("/version")
    if result:
        st.success(f"✅ Connected! Docker version: {result.get('Version', 'unknown')}")
    else:
        st.error(f"❌ Connection failed: {error}")

st.sidebar.header("Choose What To Do")
option = st.sidebar.selectbox("Pick One:", [
    "List Containers", 
    "Start Container", 
    "Stop Container", 
    "Remove Container",
    "List Images",
    "Pull Image",
    "Remove Image",
    "Create Container",
    "Container Logs",
    "System Info"
])

if option == "List Containers":
    st.header("All Containers")
    show_all = st.checkbox("Show stopped containers too", value=True)
    
    if st.button("Show Containers"):
        endpoint = "/containers/json" + ("?all=true" if show_all else "")
        containers, error = make_docker_request(endpoint)
        
        if containers is not None:
            if containers:
                st.text(format_container_info(containers))
                
                # Show as expandable JSON for advanced users
                with st.expander("Raw JSON Data"):
                    st.json(containers)
            else:
                st.info("No containers found")
        else:
            st.error(error)

elif option == "Start Container":
    st.header("Start a Container")
    container_name = st.text_input("Enter container name or ID:")
    
    if st.button("Start") and container_name:
        result, error = make_docker_request(f"/containers/{container_name}/start", "POST")
        
        if error is None:
            st.success(f"✅ Started container: {container_name}")
        else:
            st.error(f"❌ Failed to start: {error}")

elif option == "Stop Container":
    st.header("Stop a Container")
    container_name = st.text_input("Enter container name or ID:")
    
    if st.button("Stop") and container_name:
        result, error = make_docker_request(f"/containers/{container_name}/stop", "POST")
        
        if error is None:
            st.success(f"✅ Stopped container: {container_name}")
        else:
            st.error(f"❌ Failed to stop: {error}")

elif option == "Remove Container":
    st.header("Remove a Container")
    container_name = st.text_input("Enter container name or ID:")
    force_remove = st.checkbox("Force remove (even if running)")
    
    if st.button("Remove") and container_name:
        endpoint = f"/containers/{container_name}"
        if force_remove:
            endpoint += "?force=true"
            
        result, error = make_docker_request(endpoint, "DELETE")
        
        if error is None:
            st.success(f"✅ Removed container: {container_name}")
        else:
            st.error(f"❌ Failed to remove: {error}")

elif option == "List Images":
    st.header("All Images")
    
    if st.button("Show Images"):
        images, error = make_docker_request("/images/json")
        
        if images is not None:
            if images:
                st.text(format_image_info(images))
                
                with st.expander("Raw JSON Data"):
                    st.json(images)
            else:
                st.info("No images found")
        else:
            st.error(error)

elif option == "Pull Image":
    st.header("Pull an Image")
    image_name = st.text_input("Enter image name (like nginx:latest, ubuntu:20.04):")
    
    if st.button("Pull") and image_name:
        st.info("🔄 Pulling image... This may take a while for large images")
        
        # Note: Pull operation returns streaming response, simplified here
        result, error = make_docker_request(f"/images/create?fromImage={image_name}", "POST")
        
        if error is None:
            st.success(f"✅ Successfully pulled: {image_name}")
        else:
            st.error(f"❌ Failed to pull: {error}")

elif option == "Remove Image":
    st.header("Remove an Image")
    image_name = st.text_input("Enter image name or ID:")
    force_remove = st.checkbox("Force remove")
    
    if st.button("Remove") and image_name:
        endpoint = f"/images/{image_name}"
        if force_remove:
            endpoint += "?force=true"
            
        result, error = make_docker_request(endpoint, "DELETE")
        
        if error is None:
            st.success(f"✅ Removed image: {image_name}")
        else:
            st.error(f"❌ Failed to remove: {error}")

elif option == "Create Container":
    st.header("Create a Container")
    
    col1, col2 = st.columns(2)
    
    with col1:
        container_name = st.text_input("Container name:")
        image_name = st.text_input("Image name:")
        
    with col2:
        port_mapping = st.text_input("Port mapping (host:container, e.g., 8080:80):")
        env_vars = st.text_area("Environment variables (KEY=VALUE, one per line):")
    
    if st.button("Create Container") and container_name and image_name:
        # Build container config
        config = {
            "Image": image_name,
            "name": container_name
        }
        
        # Add port mapping if specified
        if port_mapping and ":" in port_mapping:
            host_port, container_port = port_mapping.split(":", 1)
            config["HostConfig"] = {
                "PortBindings": {
                    f"{container_port}/tcp": [{"HostPort": host_port}]
                }
            }
            config["ExposedPorts"] = {f"{container_port}/tcp": {}}
        
        # Add environment variables
        if env_vars:
            env_list = []
            for line in env_vars.strip().split('\n'):
                if '=' in line:
                    env_list.append(line.strip())
            if env_list:
                config["Env"] = env_list
        
        result, error = make_docker_request(f"/containers/create?name={container_name}", "POST", config)
        
        if error is None:
            st.success(f"✅ Created container: {container_name}")
            if st.button("Start it now?"):
                start_result, start_error = make_docker_request(f"/containers/{container_name}/start", "POST")
                if start_error is None:
                    st.success("✅ Container started!")
                else:
                    st.error(f"❌ Failed to start: {start_error}")
        else:
            st.error(f"❌ Failed to create: {error}")

elif option == "Container Logs":
    st.header("Container Logs")
    container_name = st.text_input("Enter container name or ID:")
    
    if st.button("Get Logs") and container_name:
        # Note: This is simplified - actual logs endpoint returns streaming data
        result, error = make_docker_request(f"/containers/{container_name}/logs?stdout=true&stderr=true&tail=100")
        
        if error is None:
            st.text_area("Logs:", value="Logs would appear here (simplified for demo)", height=300)
        else:
            st.error(f"❌ Failed to get logs: {error}")

elif option == "System Info":
    st.header("Docker System Information")
    
    if st.button("Get System Info"):
        info, error = make_docker_request("/info")
        
        if info is not None:
            st.subheader("System Overview")
            
            col1, col2 = st.columns(2)
            
            with col1:
                st.metric("Containers", info.get('Containers', 0))
                st.metric("Images", info.get('Images', 0))
                st.metric("Running Containers", info.get('ContainersRunning', 0))
                
            with col2:
                st.metric("Paused Containers", info.get('ContainersPaused', 0))
                st.metric("Stopped Containers", info.get('ContainersStopped', 0))
                
            st.subheader("System Details")
            st.write(f"**Docker Version:** {info.get('ServerVersion', 'unknown')}")
            st.write(f"**Operating System:** {info.get('OperatingSystem', 'unknown')}")
            st.write(f"**Architecture:** {info.get('Architecture', 'unknown')}")
            st.write(f"**Total Memory:** {round(info.get('MemTotal', 0) / (1024**3), 2)} GB")
            
            with st.expander("Full System Info (JSON)"):
                st.json(info)
        else:
            st.error(error)

# Instructions
st.write("---")
st.subheader("Setup Instructions")

st.write("""
**To use this Docker Manager:**

1. **Enable Docker API** on your Docker host:
   ```bash
   # On Linux, edit daemon.json
   sudo nano /etc/docker/daemon.json
   
   # Add this configuration:
   {
     "hosts": ["unix:///var/run/docker.sock", "tcp://0.0.0.0:2376"]
   }
   
   # Restart Docker
   sudo systemctl restart docker
   ```

2. **For remote access**, update the Docker Host URL above to your server's IP
3. **Security Note**: For production, use TLS encryption and authentication

**Hosting Options:**
- Deploy on Streamlit Cloud, Heroku, or similar platforms
- The app will connect to your Docker daemon via API
- No local Docker installation needed on the hosting platform
""")

st.write("Made with Streamlit + Docker API")
