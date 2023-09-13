# Use an official Ubuntu as a parent image
FROM ubuntu AS build

# Install required tools and dependencies
RUN apt-get update && apt-get install -y git maven openjdk-8-jdk

# Set the working directory
WORKDIR /src

# Clone your Git repository
RUN git clone https://github.com/ChintalaVineetha/devops-automation.git
WORKDIR /src/devops-automation

# Build the Spring Boot application
RUN mvn clean package

# stage: 2 — create a production-ready image with Java runtime
FROM openjdk:8-jre-slim

# Set the working directory
WORKDIR /app

# Copy the JAR file from the build stage to the current directory
COPY --from=build /src/devops-automation/target/*.jar app.jar

# Expose port 8080 for the Spring Boot application
EXPOSE 8080

# Define the command to run the Spring Boot application
CMD ["java", "-jar", "app.jar"]
