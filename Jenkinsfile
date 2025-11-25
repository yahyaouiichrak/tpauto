pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "ichrakyhy/cv-onepage"
        DOCKER_CREDENTIALS = 'dockerhub'
        GIT_REPO = 'https://github.com/yahyaouiichrak/tpauto.git'
        SLACK_WEBHOOK = credentials('slack-webhook')  // ton webhook Slack
    }

    triggers {
        pollSCM('H/5 * * * *')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: "${GIT_REPO}"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t ${DOCKER_IMAGE}:latest .
                    docker tag ${DOCKER_IMAGE}:latest ${DOCKER_IMAGE}:v${BUILD_NUMBER}
                """
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${DOCKER_IMAGE}:latest
                        docker push ${DOCKER_IMAGE}:v${BUILD_NUMBER}
                    """
                }
            }
        }
    }

    post {
        success {
            script {
                sh """
                curl -X POST -H 'Content-type: application/json' --data "{
                    \\"text\\": \\":white_check_mark: SUCCESS - Job: ${env.JOB_NAME}, Build: #${env.BUILD_NUMBER}\\"
                }" ${SLACK_WEBHOOK}
                """
            }
        }

        failure {
            script {
                sh """
                curl -X POST -H 'Content-type: application/json' --data "{
                    \\"text\\": \\":x: FAILED - Job: ${env.JOB_NAME}, Build: #${env.BUILD_NUMBER}\\"
                }" ${SLACK_WEBHOOK}
                """
            }
        }
    }
}