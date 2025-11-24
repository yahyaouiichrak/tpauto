
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "ichrakyhy/cv-onepage" // Remplace par ton repo Docker Hub
        DOCKER_CREDENTIALS = 'dockerhub'      // ID des credentials Jenkins
        GIT_REPO = 'https://github.com/yahyaouiichrak/tpauto' // Remplace par ton repo GitHub
    }

    triggers {
        pollSCM('H/5 * * * *') // Vérifie toutes les 5 minutes
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: "${GIT_REPO}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        docker build -t ${DOCKER_IMAGE}:latest .
                        docker tag ${DOCKER_IMAGE}:latest ${DOCKER_IMAGE}:v${BUILD_NUMBER}
                    """
                }
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

        stage('Notify Slack') {
            steps {
                slackSend(channel: '#devops', message: "✅ Pipeline terminé avec succès : ${DOCKER_IMAGE} (Build #${BUILD_NUMBER})")
            }
        }
    }

    post {
        failure {
            slackSend(channel: '#devops', message: "❌ Pipeline échoué : ${DOCKER_IMAGE} (Build #${BUILD_NUMBER})")
        }
    }
}
