pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'ap-south-1'   // change to your AWS region
    }

    stages {
        stage('Checkout') {
            steps {
                // Clone your GitHub repo
                git branch: 'main',
                    credentialsId: 'github-creds',
                    url: 'https://github.com/iamsivas57/myproject.git'
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                sh """
                  terraform init
                  terraform plan -var aws_region=$AWS_DEFAULT_REGION \
                                 -var aws_access_key=$AWS_ACCESS_KEY_ID \
                                 -var aws_secret_key=$AWS_SECRET_ACCESS_KEY \
                                 -out tfplan
                  terraform show -no-color tfplan > tfplan.txt
                """
            }
        }

        stage('Approval') {
            when {
                not { equals expected: true, actual: params.autoApprove }
            }
            steps {
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                          parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                sh "terraform apply -input=false tfplan"
            }
        }
    }

    post {
        success {
            echo '✅ AWS infrastructure provisioned successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check logs for details.'
        }
    }
}
