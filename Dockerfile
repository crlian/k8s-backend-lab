# ===== Build stage =====
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app

# Copiamos wrapper + pom primero para cache
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN chmod +x mvnw && ./mvnw -q -DskipTests dependency:go-offline

# Ahora copiamos el codigo y compilamos
COPY src/ src/
RUN ./mvnw -q -DskipTests package

# ====== Runtime stage =====
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copiamos el jar generado
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
