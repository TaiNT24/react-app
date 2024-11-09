pipeline {
    agent {
        label 'nodejs-slave'
    }
    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
        DOCKER_IMAGE = 'nguyentutai12/react-app'
        CI = 'false'
        // DOCKER_TAG = ''
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Get Git Commit Hash') {
            steps {
                script {
                    def gitCommit = sh(script: 'git rev-parse --short=6 HEAD', returnStdout: true).trim()
                    DOCKER_TAG = gitCommit
                    echo "Git Commit Hash: ${gitCommit}"
                    echo "Git Commit Hash: ${DOCKER_TAG}"
                }
            }
        }
        
        // stage('Install Dependencies') {
        //     steps {
        //         sh 'npm install'
        //     }
            
        // }
        
        // stage('Build') {
        //     steps {
        //         sh 'npm run build'
        //     }
        // }
        
        // stage('Test') {
        //     steps {
        //         sh 'npm test -- --watchAll=false'
        //     }
        // }

        // stage('Deploy') {
        //     steps {
        //         dir('react-app') {
        //             sh '''
        //                 npm install -g pm2
        //                 npm install -g http-server

        //                 pm2 delete react-app || true
        //                 pm2 start $(which http-server) --name "react-app" -- ./build -p 3000 --proxy http://localhost:3000
        //                 pm2 status
        //             '''
        //         }
        //     }
        // }

        stage('Docker Login') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com/', DOCKER_CREDENTIALS_ID) {
                        echo 'Logged into Docker Hub'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                // sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push') {
            steps {
                // sh '''
                //     docker stop react-app || true
                //     docker rm react-app || true
                //     docker run -d --name react-app -p 3000:80 ${DOCKER_IMAGE}:${DOCKER_TAG}
                // '''
                script {
                    docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIALS_ID) {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }

        // stage('Deploy') {
        //     steps {
        //         sh '''
        //             docker stop react-app || true
        //             docker rm react-app || true
        //             docker run -d --name react-app -p 3000:80 ${DOCKER_IMAGE}:${DOCKER_TAG}
        //         '''
        //     }
        // }


        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'build/**/*', fingerprint: true
            }
        }
    }
}
