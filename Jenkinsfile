pipeline {
    agent {
        docker {
            image 'jenkins-agent:latest'
            label 'docker-agent'
            reuseNode true
        }
    }
    stages {
        stage('Install Docker Compose') {
            steps {
                sh '''
                    curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                    chmod +x /usr/local/bin/docker-compose
                '''
            }
        }
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: '1', url: 'https://github.com/YumieNC/clone-job-seeker.git'
            }
        }
        stage('Build & Test') {
            steps {
                // sh "${tool 'Maven 3.9.9'}/bin/mvn -f server/pom.xml clean package"
                sh 'docker-compose -f docker-compose.prod.yml up --build -d server'
                sleep 15
                sh "docker exec job-seeker-server-container mvn -f server/pom.xml test"
                sh 'docker-compose -f docker-compose.prod.yml down'
            }
        }
        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool 'sonarqube_scanner' // Khai báo SonarQube Scanner
            }
            steps {
                withSonarQubeEnv('sonarqube_server') { // 'SonarQube' là tên SonarQube server đã cấu hình trong Jenkins.
                    sh "${tool 'Maven 3.9.9'}/bin/mvn sonar:sonar -Dsonar.projectKey=jobseeker -Dsonar.projectName='jobseeker'"
                }
            }
        }
        /*
        stage('Build and Push Docker Images (Optional)') {
            when {
                expression { env.BRANCH_NAME == 'main' } // Chỉ build Docker image khi ở branch main
            }
            steps {
                script {
                  def clientImageName = "your-dockerhub-username/client:${env.BUILD_NUMBER}"
                  def serverImageName = "your-dockerhub-username/server:${env.BUILD_NUMBER}"
                  docker.withRegistry('https://registry.hub.docker.com', 'your-dockerhub-credentials-id') {
                    docker.build(clientImageName, './client').push()
                    docker.build(serverImageName, './server').push()
                  }
                }
                
            }
        }
        */
    }
}