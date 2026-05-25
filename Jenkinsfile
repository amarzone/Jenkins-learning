
pipeline { 
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timeout(time: 1, unit: 'HOURS')
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Building the application...'
                // Uncomment the build command for your technology stack:
                
                // For Maven projects:
                // sh 'mvn clean build'
                
                // For Node.js projects:
                // sh 'npm install && npm run build'
                
                // For Python projects:
                // sh 'pip install -r requirements.txt && python setup.py build'
                
                // For Docker:
                // sh 'docker build -t myapp:${BUILD_NUMBER} .'
                
                echo 'Build completed successfully'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                // Uncomment the test command for your technology stack:
                
                // For Maven projects:
                // sh 'mvn test'
                
                // For Node.js projects:
                // sh 'npm test'
                
                // For Python projects:
                // sh 'pytest'
                
                echo 'Tests completed'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                // Add your deployment logic here
                // sh 'docker push myapp:${BUILD_NUMBER}'
                // sh 'kubectl apply -f deployment.yaml'
                echo 'Deployment completed'
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed'
        }
        success {
            echo 'Pipeline succeeded!'
            // Add success notifications here
        }
        failure {
            echo 'Pipeline failed!'
            // Add failure notifications here
        }
    }
}
