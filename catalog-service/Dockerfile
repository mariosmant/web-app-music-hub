FROM eclipse-temurin:25-jdk
WORKDIR /app
COPY mvnw ./
COPY .mvn .mvn
COPY pom.xml .
RUN ./mvnw -q -DskipTests dependency:go-offline
COPY src ./src
RUN ./mvnw -q -DskipTests package
EXPOSE 8080
CMD ["./mvnw", "spring-boot:run"]
