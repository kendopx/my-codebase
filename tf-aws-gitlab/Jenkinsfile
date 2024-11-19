pipeline {
    agent any
    stages {

        // Init stage 
        stage('Terraform Init') {
            steps {
                withAWS(credentials: 'aws-credentials', region: 'us-east-2') {
                    sh 'terraform init -reconfigure'
                    sh 'terraform init -migrate-state'
                    sh 'terraform fmt'
                }
            }
        }

        // Plan stage 
        stage('Terraform Plan') {
            steps {
                withAWS(credentials: 'aws-credentials', region: 'us-east-2') {
                    sh 'terraform plan'
                }
            }
        }

        // Apply stage 
        stage('Terraform Apply') {
            steps {
                withAWS(credentials: 'aws-credentials', region: 'us-east-2') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        // Approval stage 
        stage ("Destroy approval") {
            steps {
                withAWS(credentials: 'aws-credentials', region: 'us-east-2') {
                    echo "Taking approval from DEV Manager for QA Deployment"
                    timeout(time: 7, unit: 'DAYS') {
                    input message: 'Do you want to Destroy the Infra', submitter: 'admin'
                    }
                    }
                }    
            }   

        // Destroy stage               
        stage('Terraform Destroy') {
            steps {
                withAWS(credentials: 'aws-credentials', region: 'us-east-2') {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }        
    }    
}
