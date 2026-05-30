FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

FROM tomcat:11.0-jdk21-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build /app/target/Proyecto_Final_LP2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080