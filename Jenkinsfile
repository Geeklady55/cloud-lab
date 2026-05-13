pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Geeklady55/cloud-lab.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t cloud-lab-app .'
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                docker stop cloudlab || true
                docker rm cloudlab || true
                docker run -d --name cloudlab -p 5000:5000 cloud-lab-app
                docker ps
                '''
            }
        }
    }
}
