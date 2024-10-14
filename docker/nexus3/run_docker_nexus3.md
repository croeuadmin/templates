# Docker run command for creating Nexus container

# Prepare neccessary folders for bind mount volumes and set appropriate permissions
sudo mkdir -p /path/to/custom/nexus-data
sudo chown -R 200:200 /path/to/custom/nexus-data

# Run Docker run command with custom value to create and start Nexus Docker container
# Adjust ports, container name, volume bind mount (or dedicated) location and Docker image name (with custom or latest image)
docker run -d -p 8081:8081 --name nexus -v /path/to/custom/nexus-data:/nexus-data sonatype/nexus3:3.72.0-java17-alpine

