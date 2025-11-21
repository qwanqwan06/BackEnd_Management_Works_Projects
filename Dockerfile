# ========== STEP 1: BUILD STAGE ==========
FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy pom trước để cache dependency
COPY pom.xml .

# Download dependencies (dùng cache nếu pom.xml không đổi)
RUN mvn -B dependency:go-offline

# Copy toàn bộ source
COPY src ./src

RUN mvn -B clean package -DskipTests

# ========== STEP 2: RUNTIME ==========
FROM eclipse-temurin:21-jdk-alpine

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8082

ENTRYPOINT ["java", "-jar", "app.jar"]
