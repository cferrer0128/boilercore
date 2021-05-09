pipeline {
    agent any
    environment{
        registry="318267653548.dkr.ecr.us-east-1.amazonaws.com/docker-ecr"
        registryurl="318267653548.dkr.ecr.us-east-1.amazonaws.com"
    }
    stages{
        stage('Checkout'){
            steps{
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/cferrer0128/boilercore.git']]])
            }
        }
        stage('Docker Build'){
            steps {
                script {
                  dockerImage = docker.build registry
                }
            }
        }
        stage('Docker Push'){
            steps{
                script{
                    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $registryurl'
                    sh 'docker push $registryurl/docker-ecr:latest'
                }
            }
        }
        stage('stop previous containers') {
         steps {
            sh 'docker ps -f name=dotnetcoreContainer -q | xargs --no-run-if-empty docker container stop'
            sh 'docker container ls -a -fname=dotnetcoreContainer -q | xargs -r docker container rm'
         }
       }
       stage('Docker Run'){
           steps{
               script{
                        sh 'docker run -d -p 8096:8080 --rm --name dotnetcoreContainer $registryurl/docker-ecr:latest'
               }
           }
       }
    }
    
}