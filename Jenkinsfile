pipeline {
    agent any
    environment {
        GIT = "$payload"
    }
    stages {
        stage('Test') {
            steps {
                sh """echo ${env.GIT}"""
                sh """echo penglei"""
                sh """echo pl"""
                sh """echo pl2"""
                sh """echo pl3"""
                sh """echo pl4"""
                sh """echo pl5"""
                sh """echo pl6"""
                sh """echo pl7"""
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
