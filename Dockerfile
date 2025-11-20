# Bước 1: Build ứng dụng bằng Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
# Build file .jar và bỏ qua test để tiết kiệm thời gian (có thể bỏ -DskipTests nếu muốn chạy test)
RUN mvn clean package -DskipTests

# Bước 2: Chạy ứng dụng bằng JDK rút gọn
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app
# Copy file .jar từ bước build (đảm bảo pom.xml build ra tên file đúng hoặc dùng *.jar)
COPY --from=build /app/target/*.jar app.jar

# Tạo thư mục upload tạm thời để tránh lỗi
RUN mkdir -p /tmp/uploads

# Port mặc định của Spring Boot trong cấu hình trên
EXPOSE 8082

# Lệnh chạy
ENTRYPOINT ["java","-jar","app.jar"]