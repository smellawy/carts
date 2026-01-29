pipeline {
  agent any
  stages {
    stage('Compile') {
      steps {
        echo 'This is the first stage - Compilation'
        sh 'mvn compile'
      }
    }

    stage('Test') {
      steps {
        echo 'This is the second stage - Testing'
        sh 'mvn clean test'
      }
    }

    stage('Package') {
      steps {
        echo 'This is the third stage - Packaging'
        sh 'mvn package -DskipTests'
        archiveArtifacts '**/target/*.jar'
      }
    }

  }
  tools {
    maven 'Maven'
  }
  post {
    always {
      echo 'This pipeline has completed...'
      cleanWs()
    }

    success {
      echo 'Pipeline completed successfully!'
    }

    failure {
      echo 'Pipeline failed!'
    }

  }
}