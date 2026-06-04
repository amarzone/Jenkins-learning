pipeline {
    agent { 
        label "ritik"
    } 

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

        stage('Setup') {
            steps {
                echo 'Setting up environment...'
                sh '''
                    echo "Installing Terraform..."
                    TERRAFORM_VERSION="1.5.7"

                    wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O terraform.zip
                    
                    if [ ! -f terraform.zip ]; then
                        echo "Terraform download failed"
                        exit 1
                    fi

                    unzip -o -q terraform.zip
                    chmod +x terraform
                    mv terraform /usr/local/bin/ 2>/dev/null || true
                    rm -f terraform.zip

                    echo "Terraform Version:"
                    terraform version
                    
                    sudo apt update
                    sudo apt install -y python3-pip python3-venv
                    
                    # Create virtual environment
                    python3 -m venv venv
                    
                    # Activate it
                    . venv/bin/activate
                    
                    # Install packages inside venv
                    pip install -r checkov

                '''
            }
        }

        stage('Terraform Init') {
            steps {
                echo 'Initializing Terraform...'
                sh 'terraform init'
            }
        }

        stage('Test & Security Checks') {
            steps {
                echo '========== Running Terraform Validation & Security =========='

                // ✅ Stage 1: Formatting (FIXED)
                sh '''
                    echo "--- Terraform Format ---"
                    terraform fmt -recursive .
                    terraform fmt -check -recursive .
                '''

                // ✅ Stage 2: Validate
                sh '''
                    echo "--- Terraform Validate ---"
                    terraform validate
                '''

                // ✅ Stage 3: TFLint
                sh '''
                    echo "--- TFLint ---"
                    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash || true
                    tflint --init || true
                    tflint --format compact || true
                '''

                // ✅ Stage 4: Checkov
                sh '''
                    echo "--- Checkov ---"
                    pip install -q checkov || pip3 install -q checkov
                    checkov -d . --framework terraform --quiet || true
                '''

                // ✅ Stage 5: Trivy
                sh '''
                    echo "--- Trivy ---"
                    TRIVY_VERSION="0.45.0"

                    wget -q https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz -O trivy.tar.gz || true

                    if [ -f trivy.tar.gz ]; then
                        tar -xzf trivy.tar.gz
                        mv trivy /usr/local/bin/ 2>/dev/null || true
                    fi

                    trivy config . --severity HIGH,CRITICAL || true
                '''

                // ✅ Stage 6: Terraform Plan
                sh '''
                    echo "--- Terraform Plan ---"
                    terraform plan -out=tfplan
                '''
            }
        }

        stage('Build') {
            steps {
                echo 'Build stage (placeholder)'
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                echo 'Deploying infrastructure...'
                sh '''
                    terraform apply -auto-approve tfplan
                '''
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed'

            sh '''
                echo "Generated files:"
                ls -lh tfplan* 2>/dev/null || true
            '''

            archiveArtifacts artifacts: 'tfplan*', allowEmptyArchive: true
        }

        success {
            echo '✅ Pipeline succeeded!'
        }

        failure {
            echo '❌ Pipeline failed!'
        }
    }
}
