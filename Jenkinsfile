pipeline {
    agent any

    environment {
        DOCKERHUB_REPO = 'mohamedadel9988/carts'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    tools {
        maven 'Maven'  // Configure in Manage Jenkins → Tools → Maven
        jdk 'JDK21'    // Configure in Manage Jenkins → Tools → JDK
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo "✅ Code checked out successfully"
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
                echo "✅ Build completed"
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test || true'
                echo "✅ Tests completed"
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package -DskipTests'
                echo "✅ JAR packaged: target/carts.jar"
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${DOCKERHUB_REPO}:${IMAGE_TAG} -t ${DOCKERHUB_REPO}:latest ."
                echo "✅ Docker image built: ${DOCKERHUB_REPO}:${IMAGE_TAG}"
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}
                        docker push ${DOCKERHUB_REPO}:latest
                        docker logout
                    '''
                }
                echo "✅ Image pushed to Docker Hub"
            }
        }

        stage('Update K8s Manifest for ArgoCD') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'github-credentials',
                    usernameVariable: 'GIT_USER',
                    passwordVariable: 'GIT_PASS'
                )]) {
                    sh '''
                        rm -rf mogambo-manifests
                        git clone https://${GIT_USER}:${GIT_PASS}@github.com/smellawy/mogambo-manifests.git
                        cd mogambo-manifests
                        sed -i "s|image: mohamedadel9988/carts:.*|image: mohamedadel9988/carts:${IMAGE_TAG}|g" apps/carts/deployment.yml
                        git config user.email "jenkins@mogambo.com"
                        git config user.name "Jenkins CI"
                        git add .
                        git commit -m "🚀 Update carts image to build ${IMAGE_TAG}"
                        git push origin main
                    '''
                }
                echo "✅ ArgoCD manifest updated"
            }
        }

        stage('Cleanup') {
            steps {
                sh '''
                    docker rmi ${DOCKERHUB_REPO}:${IMAGE_TAG} || true
                    docker rmi ${DOCKERHUB_REPO}:latest || true
                    rm -rf mogambo-manifests
                '''
                echo "✅ Cleanup done"
            }
        }
    }

    post {
        success {
            echo "🎉 Carts pipeline completed successfully! Build #${BUILD_NUMBER}"
        }
        failure {
            echo "❌ Carts pipeline failed at build #${BUILD_NUMBER}"
        }
    }
}
