pipeline {
    agent any

    environment {
        // DOCKER_REGISTRY_URL = "https://index.docker.io/v1/"
        SONAR_SERVER_URL = "http://localhost:9000" // Thay bằng URL SonarQube của bạn
        SERVER_PORT = 8800
        CLIENT_PORT = 80
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Server') {
            agent {
                docker {
                    image 'maven:3.9.2-eclipse-temurin-17'
                    reuseNode true // Tái sử dụng node nếu có thể
                }
            }
            steps {
                sh 'mvn -f server/pom.xml clean package -DskipTests' // Xác định đường dẫn đến pom.xml
            }
        }

        stage('SonarQube Analysis') {
            agent {
                docker {
                    image 'maven:3.9.2-eclipse-temurin-17'
                    reuseNode true
                }
            }
            steps {
                withSonarQubeEnv(installationName: 'SonarQube') {
                    withMaven(jdk: 'jdk17', maven: 'maven3') {
                        sh """
                            mvn -f server/pom.xml sonar:sonar \
                                -Dsonar.projectKey=your-project-key \
                                -Dsonar.projectName=Your Project Name \
                                -Dsonar.projectVersion=${env.BUILD_NUMBER} \
                                -Dsonar.sources=./server/src \
                                -Dsonar.java.binaries=./server/target/classes
                        """
                    }
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