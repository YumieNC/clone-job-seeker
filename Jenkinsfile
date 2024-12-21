pipeline {
    agent any

    environment {
        SONAR_SERVER_URL = 'http://sonarqube:9000'    }

    tools {
        maven 'maven'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Server') {
            steps {
                sh 'mvn -f server/pom.xml clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv(installationName: 'sonarqube_server') {
                    withCredentials([string(credentialsId: '3', variable: 'SIGNER_KEY')]) {
                    sh " mvn -f server/pom.xml clean verify sonar:sonar -Dsonar.projectKey=java-maven -Dsonar.sources=src -Dsonar.java.binaries=target/classes -Dsonar.tests=src/test/java -Dsonar.exclusions=src/test/java/**/* -DSIGNER_KEY=${SIGNER_KEY}"
                    }   
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        
        // stage('Build and Push Docker Images') {
        //     agent {
        //         docker {
        //             image 'docker:latest'
        //             reuseNode true
        //         }
        //     }
        //     steps {
        //         script {
        //             def harborUrl = "registry.devnoneknow.online"

        //             def harborProject = "nt548proj"

        //             docker.withRegistry("https://$harborUrl", 'harbor-credentials') {
        //                 def serverImage = docker.build("$harborUrl/$harborProject/job-seeker-server:${env.BUILD_NUMBER}", "-f server/Dockerfile .")
        //                 serverImage.push()

        //                 def clientImage = docker.build("$harborUrl/$harborProject/job-seeker-client:${env.BUILD_NUMBER}",
        //                         "-f client/Dockerfile .")
        //                 clientImage.push()
        //             }
        //         }
        //     }
        // }
        // stage('Deploy') {
        //     agent {
        //          docker {
        //             image 'docker:latest'
        //             reuseNode true
        //          }
        //     }
        //     steps {
        //         echo "Deploying to production..."
        //         sh """
        //             docker-compose -f docker-compose.prod.yml down
        //             docker-compose -f docker-compose.prod.yml pull
        //             docker-compose -f docker-compose.prod.yml up -d --build
        //         """
        //     }
        // }
    }
}
