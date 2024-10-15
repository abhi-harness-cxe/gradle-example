# Use the official OpenJDK base image
FROM openjdk:11-jdk AS build

# Set the working directory
WORKDIR /app

# Copy the Gradle wrapper and build files
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# Copy the source code
COPY src src
COPY lib lib

# Give execution rights to the Gradle wrapper
RUN chmod +x gradlew

# Build the application
RUN ./gradlew build --no-daemon

# Use a smaller image for running the application
FROM openjdk:11-jre

# Set the working directory for the runtime
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Expose the port that the app runs on
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
