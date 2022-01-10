FROM java:8
EXPOSE 8181
RUN mkdir /usr/src/app
WORKDIR /usr/src/app

ADD /target/MINTS-validation-0.0.1-SNAPSHOT.jar mints-validatation.jar
ENTRYPOINT ["java", "-jar", "mints-validatation.jar"]