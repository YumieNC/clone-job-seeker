pipeline {
    agent any

    environment {
        // DOCKER_REGISTRY_URL = "https://index.docker.io/v1/"
        SONAR_SERVER_URL = 'http://sonarqube:9000'
        SERVER_PORT = 8800
        CLIENT_PORT = 80
    }

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
                    sh """
                    mvn -f server/pom.xml sonar:sonar \
                        -Dsonar.projectKey=your-project-key \
                        -Dsonar.projectName=Your Project Name \
                        -Dsonar.projectVersion=${env.BUILD_NUMBER} \
                        -Dsonar.sources=src \
                        -Dsonar.java.binaries=target/classes
                """
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        /*
        stage('Build and Push Docker Images') {
            agent {
                docker {
                    image 'docker:latest' // Sử dụng docker image để build và push
                    reuseNode true
                }
            }
            steps {
                script {
                    docker.withRegistry(env.DOCKER_REGISTRY_URL, 'docker-hub-credentials') {
                        def serverImage = docker.build("your-dockerhub-username/job-seeker-server:${env.BUILD_NUMBER}",
                                "-f server/Dockerfile .") // Xác định Dockerfile và context
                        serverImage.push()
                        //serverImage.push("latest")

                        def clientImage = docker.build("your-dockerhub-username/job-seeker-client:${env.BUILD_NUMBER}",
                                "-f client/Dockerfile .") // Xác định Dockerfile và context
                        clientImage.push()
                    //clientImage.push("latest")
                    }
                }
            }
        }

        stage('Deploy') {
            agent {
                 docker {
                    image 'docker:latest'
                    reuseNode true
                    label 'docker-agent' // Sử dụng agent có label 'docker-agent' nếu bạn muốn chỉ định agent cụ thể
                 }
            }
            steps {
                echo "Deploying to production..."
                sh """
                    docker-compose -f docker-compose.prod.yml down
                    docker-compose -f docker-compose.prod.yml pull
                    docker-compose -f docker-compose.prod.yml up -d --build
                """
                 //  sh "docker run -d -p ${SERVER_PORT}:${SERVER_PORT} --name job-seeker-server your-dockerhub-username/job-seeker-server:${env.BUILD_NUMBER}"
                 //  sh "docker run -d -p ${CLIENT_PORT}:${CLIENT_PORT} --name job-seeker-client your-dockerhub-username/job-seeker-client:${env.BUILD_NUMBER}"

            }
        }
        */
    }
}
