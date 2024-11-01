# 1. OpenJDK 이미지 사용
FROM openjdk:17-jdk-slim

# 2. 애플리케이션 JAR 파일 위치 설정
ARG JAR_FILE=target/*.jar

# 3. JAR 파일을 이미지 내로 복사
COPY ${JAR_FILE} app.jar

# 4. 애플리케이션 실행 명령
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]