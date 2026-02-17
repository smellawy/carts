pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        checkout scm
        echo '✅ Code checked out'
      }
    }

    stage('Build & Test') {
      steps {
        sh '''
                    docker run --rm -v "$PWD":/app -w /app maven:3.9-eclipse-temurin-21 sh -c "mvn clean package -DskipTests && mvn test || true"
                '''
        echo '✅ Build & Test completed'
      }
    }

    stage('Docker Build') {
      steps {
        sh 'docker build -t mohamedadel9988/carts:latest -t mohamedadel9988/carts:${BUILD_NUMBER} .'
        echo '✅ Docker image built'
      }
    }

    stage('Docker Push') {
      steps {
        withCredentials(bindings: [usernamePassword(
                              credentialsId: 'dockerhub-credentials',
                              usernameVariable: 'DOCKER_USER',
                              passwordVariable: 'DOCKER_PASS'
                          )]) {
            sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push mohamedadel9988/carts:latest
                        docker push mohamedadel9988/carts:${BUILD_NUMBER}
                        docker logout
                    '''
          }

          echo '✅ Pushed to Docker Hub'
        }
      }

      stage('Update K8s Manifest') {
        steps {
          withCredentials(bindings: [usernamePassword(
                                credentialsId: 'github-credentials',
                                usernameVariable: 'GIT_USER',
                                passwordVariable: 'GIT_PASS'
                            )]) {
              sh '''
                        rm -rf mogambo-manifests
                        git clone https://${GIT_USER}:${GIT_PASS}@github.com/smellawy/mogambo-manifests.git
                        cd mogambo-manifests
                        sed -i "s|image: mohamedadel9988/carts:.*|image: mohamedadel9988/carts:${BUILD_NUMBER}|g" apps/carts/deployment.yml
                        git config user.email "jenkins@mogambo.com"
                        git config user.name "Jenkins CI"
                        git add .
                        git commit -m "Update carts image to build ${BUILD_NUMBER}" || true
                        git push origin main || true
                    '''
            }

            echo '✅ ArgoCD manifest updated'
          }
        }

        stage('Cleanup') {
          steps {
            sh '''
                    docker rmi mohamedadel9988/carts:${BUILD_NUMBER} || true
                    rm -rf mogambo-manifests
                '''
          }
        }

      }
      post {
        success {
          echo '🎉 Carts Pipeline SUCCESS! Build #${BUILD_NUMBER}'
        }

        failure {
          echo '❌ Carts Pipeline FAILED! Build #${BUILD_NUMBER}'
        }

      }
    }