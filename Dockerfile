# ---- Stage 1: Build ----
FROM maven:3.9.12-eclipse-temurin-21 AS build

WORKDIR /opt/carts

# نسخ ملفات المشروع
COPY pom.xml .
COPY src ./src

# بناء المشروع (بدون تشغيل الاختبارات لو محتاج)
RUN mvn clean package -DskipTests

# ---- Stage 2: Runtime ----
FROM eclipse-temurin:21-jre

WORKDIR /run

# نسخ الـ JAR النهائي من مرحلة build
COPY --from=build /opt/carts/target/carts.jar .

# فتح البورت 80
EXPOSE 80

# أمر التشغيل
CMD ["java", "-jar", "carts.jar", "--port=80"]
# ---- Stage 1: Build ----
FROM maven:3.9.12-eclipse-temurin-21 AS build

WORKDIR /opt/carts

# نسخ ملفات المشروع
COPY pom.xml .
COPY src ./src

# بناء المشروع (بدون تشغيل الاختبارات لو محتاج)
RUN mvn clean package -DskipTests

# ---- Stage 2: Runtime ----
FROM eclipse-temurin:21-jre

WORKDIR /run

# نسخ الـ JAR النهائي من مرحلة build
COPY --from=build /opt/carts/target/carts.jar .

# فتح البورت 80
EXPOSE 80

# أمر التشغيل
CMD ["java", "-jar", "carts.jar", "--port=80"]

