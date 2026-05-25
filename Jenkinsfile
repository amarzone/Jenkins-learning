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

        stage('Terraform Init') {
            steps {
                echo 'Initializing Terraform...'
                sh 'terraform init'
            }
        }

        stage('Test') {
            steps {
                echo '========== Running Terraform Tests & Linting =========='
                
                // Stage 1: Terraform Format Check
                echo '--- Stage 1: Terraform Format Check ---'
                sh '''
                    echo "Checking Terraform formatting..."
                    terraform fmt -check -recursive . || {
                        echo "Terraform files are not properly formatted"
                        terraform fmt -recursive . 
                        exit 1
                    }
                '''
                
                // Stage 2: Terraform Validate
                echo '--- Stage 2: Terraform Validate ---'
                sh '''
                    echo "Validating Terraform configuration..."
                    terraform validate
                '''
                
                // Stage 3: TFLint - General Linting
                echo '--- Stage 3: TFLint Analysis ---'
                sh '''
                    echo "Installing/Updating TFLint..."
                    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash || true
                    
                    echo "Running TFLint..."
                    tflint --init || true
                    tflint --format=json > tflint-report.json || true
                    tflint --format=compact
                '''
                
                // Stage 4: Checkov - Security & Compliance
                echo '--- Stage 4: Checkov Security Scanning ---'
                sh '''
                    echo "Installing Checkov..."
                    pip install -q checkov || apt-get install -y python3-pip && pip3 install -q checkov
                    
                    echo "Running Checkov for security & compliance checks..."
                    checkov -d . --framework terraform --output cli --quiet || true
                    checkov -d . --framework terraform --output json > checkov-report.json || true
                '''
                
                // Stage 5: Terraform Security - Trivy
                echo '--- Stage 5: Trivy Infrastructure Scanning ---'
                sh '''
                    echo "Installing Trivy..."
                    wget -q https://github.com/aquasecurity/trivy/releases/download/v0.45.0/trivy_0.45.0_Linux-64bit.tar.gz -O trivy.tar.gz || \
                    apt-get install -y trivy
                    tar -xzf trivy.tar.gz 2>/dev/null || true
                    
                    echo "Running Trivy for IaC scanning..."
                    trivy config . --format json > trivy-report.json || true
                    trivy config . --severity CRITICAL,HIGH || true
                '''
                
                // Stage 6: Terrascan - Compliance Scanning
                echo '--- Stage 6: Terrascan Compliance Check ---'
                sh '''
                    echo "Installing Terrascan..."
                    curl -L https://github.com/tenable/terrascan/releases/download/v1.18.2/terrascan_1.18.2_Linux_x86_64.tar.gz -o terrascan.tar.gz || true
                    tar -xzf terrascan.tar.gz 2>/dev/null || true
                    
                    echo "Running Terrascan..."
                    ./terrascan scan -t aws -o json > terrascan-report.json || true
                    ./terrascan scan -t aws || true
                '''
                
                // Stage 7: Terraform Plan
                echo '--- Stage 7: Terraform Plan (Dry Run) ---'
                sh '''
                    echo "Running Terraform Plan..."
                    terraform plan -out=tfplan -json > terraform-plan.json || true
                    terraform plan -out=tfplan
                '''
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

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                echo 'Deploying infrastructure with Terraform...'
                sh '''
                    echo "Applying Terraform changes..."
                    terraform apply -auto-approve tfplan
                '''
                echo 'Deployment completed'
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed'
            echo '========== Test Reports Summary =========='
            sh '''
                echo "Generated Reports:"
                ls -lh *-report.json tfplan.json 2>/dev/null || echo "No reports generated"
            '''
            // Archive reports for Jenkins UI
            archiveArtifacts artifacts: '*-report.json,tfplan*', allowEmptyArchive: true
            
            // Clean up
            sh 'rm -f trivy.tar.gz terrascan.tar.gz terrascan 2>/dev/null || true'
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
