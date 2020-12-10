pipeline {
    agent any
    environment {
        GIT = "$haha"
    }
    stages {
        stage('Test') {
            steps {
                sh """echo ${env.GIT}"""
            }
        }
        stage('Build') {
            steps {
                sh 'echo haha'
            }
        }
    }
}
