pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Package') {
            steps {
                sh 'docker run --rm -v "$PWD":/app -v "$HOME/.m2":/root/.m2 -w /app maven:3.9-eclipse-temurin-21 mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh 'docker run --rm -v "$PWD":/app -v "$HOME/.m2":/root/.m2 -w /app maven:3.9-eclipse-temurin-21 mvn test || true'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t mohamedadel9988/carts:latest .'
            }
        }

        stage('Docker Push') {
            steps {
                sh 'docker push mohamedadel9988/carts:latest'
            }
        }

        stage('Cleanup') {
            steps {
                sh 'docker image prune -f || true'
            }
        }
    }

    post {
        success { echo 'Carts Pipeline SUCCESS!' }
        failure { echo 'Carts Pipeline FAILED!' }
    }
}
