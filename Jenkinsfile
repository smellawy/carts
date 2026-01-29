pipeline {
    agent any
    
    tools {
        maven 'Maven'  // يجب أن يتطابق هذا الاسم مع المكونات المحددة في Jenkins → إدارة Jenkins → الأدوات العالمية
    }
    
    stages {
        stage('Compile') {
            steps {
                echo 'This is the first stage - Compilation'
                sh 'mvn compile'  // تم تصحيح الأمر من 'compile' إلى 'mvn compile'
            }
        }
        
        stage('Test') {
            steps {
                echo 'This is the second stage - Testing'
                sh 'mvn clean test'  // تم تصحيح الأمر من 'clean test' إلى 'mvn clean test'
            }
        }
        
        stage('Package') {
            steps {
                echo 'This is the third stage - Packaging'
                sh 'mvn package -DskipTests'  // تم تصحيح الأمر من 'package -Dskip' إلى 'mvn package -DskipTests'
                 // تم تصحيح بناء جملة sleep
            }
        }
    }
    
    post {
        always {
            echo 'This pipeline has completed...'
            // يمكن إضافة خطوات إضافية هنا مثل تنظيف workspace
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
            // يمكن إضافة إشعارات هنا (Email, Slack, etc.)
        }
    }
}
