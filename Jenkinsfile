pipeline {
    agent any
    environment {
        GIT = "$payload"
    }
    stages {
        stage('Test') {
            steps {
                sh """echo asdf"""
                sh """echo hahaha"""
                sh """echo asdf"""
            }
        }
        stage('Build') {
            steps {
                sh 'echo haha'
                sh """
                    echo ${env.GIT_COMMITTER_NAME}
                    echo ${env.GIT_COMMITTER_EMAIL}
                    echo ${env.GIT_URL}
                    echo ${env.GIT_COMMIT}
                    echo ${env.GIT_PREVIOUS_COMMIT}
                    echo ${env.GIT_PREVIOUS_SUCCESSFUL_COMMIT}
                """
            }
        }
    }
}
