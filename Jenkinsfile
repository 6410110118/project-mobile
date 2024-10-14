pipeline {

    agent any

    environment {
        HOST_IP = "172.17.0.2"
        PROJECT_TOKEN = "sqp_cbe40d52fd00800e4f0294b8df18430f21f6d96c"
        PROJECT_KEY = "project-mobile"
        WORKSPACE = pwd()
    }

    stages {
        
        stage ('Fetch code') {
            steps{
                git branch: 'main', url: 'https://github.com/6410110118/project-mobile.git'
            }
        }

        stage ('Test') {
            agent {
                docker {
                    image 'python:3.11.1-alpine3.16'
                    reuseNode true
                    args '-u root'
                }
            }
            steps {
                sh "pip install -r requirements.txt "
                sh "pytest --junitxml=result.xml"
            }
        }
        
        stage('Scan') {

            steps {

                script {
                    def scannerHome = tool '6410110118-sonaqube-tool';
                    withSonarQubeEnv() {
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=${PROJECT_KEY} -Dsonar.sources=. -Dsonar.host.url=http://${HOST_IP}:9000 -Dsonar.login=${PROJECT_TOKEN} -X "
                    }
                }
            }
        }

        stage('Build') {
            steps {
                sh "docker build -t pyapp-img ."
            }
        }

        stage('Deploy') {
            steps {
                sh "docker run -d --name pyapp -p 8000:8000 pyapp-img"
            }
        }
    }
}
