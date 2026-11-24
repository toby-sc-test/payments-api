FROM gradle:7.6-jdk17 AS build
COPY . /src
RUN gradle build

FROM eclipse-temurin:17.0.9_9-jre-focal
COPY --from=build /src/build/libs/app.jar /app.jar
