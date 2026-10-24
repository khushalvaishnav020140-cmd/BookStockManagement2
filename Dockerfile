FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn -B clean package -DskipTests

FROM tomcat:10.1-jre17-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build /app/target/BookStockManagement.war /usr/local/tomcat/webapps/ROOT.war

COPY entrypoint.sh /entrypoint.sh

EXPOSE 8080

CMD ["sh", "/entrypoint.sh"]
