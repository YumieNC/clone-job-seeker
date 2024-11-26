pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: '1', url: 'https://github.com/navtuan12/Job-Seeker.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn -f server/pom.xml clean package'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') { // 'SonarQube' là tên SonarQube server đã cấu hình trong Jenkins.
                    sh 'mvn sonar:sonar -Dsonar.projectKey=your-project-key -Dsonar.organization=your-organization-key'
                }
            }
        }
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
    }
}