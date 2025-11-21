pipeline {
    agent any
    
    environment {
        // Thông tin Docker Hub
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials'
        IMAGE_NAME = 'wan066/project-manager-api' 
        TAG = 'latest'
        
        // --- THÔNG TIN RAILWAY ---
        ENV_DB_URL = 'jdbc:mysql://hopper.proxy.rlwy.net:24325/railway?useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=UTF-8'
        ENV_DB_USER = 'root'
        ENV_DB_PASS = 'zPWNrnKJchrSOVkVWKMMNezWuuqLoLNC'
        
        // Các biến khác
        ENV_MAIL_USER = 'etterery@gmail.com'
        ENV_MAIL_PASS = 'scnloftlqieoxoaa'
        ENV_JWT_SECRET = 'YS12ZXJ5LWxvbmctYW5kLXN1cGVyLXNlY3VyZS1zZWNyZXQta2V5LWZvci1oczUxMi10aGF0LWlzLWF0LWxlYXN0LTY0LWJ5dGVz'
        ENV_FRONTEND_URL = 'http://localhost:3000' 
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Lấy code về
                git branch: 'main', url: 'https://github.com/qwanqwan06/BackEnd_Management_Works_Projects.git' 
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Dùng 'bat' thay vì 'sh' cho Windows
                    bat "docker build -t ${IMAGE_NAME}:${TAG} ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        docker.image("${IMAGE_NAME}:${TAG}").push()
                    }
                }
            }
        }

        stage('Deploy Local') {
            steps {
                script {
                    // 1. Dọn dẹp container cũ (Dùng try-catch hoặc || exit 0 để không lỗi nếu chưa có container)
                    // Trên Windows lệnh '|| true' đôi khi không chạy như ý, ta dùng lệnh stop/rm đơn giản
                    try {
                        bat 'docker stop backend-api'
                        bat 'docker rm backend-api'
                    } catch (Exception e) {
                        echo 'Container chưa tồn tại hoặc đã dừng, tiếp tục deploy...'
                    }
                    
                    // 2. Chạy container mới
                    // Lưu ý: Windows dùng dấu ^ để xuống dòng, Linux dùng \
                    // Nhưng để an toàn nhất trong Jenkinsfile Windows, ta viết liền hoặc dùng block '''
                    bat """
                        docker run -d --name backend-api -p 8082:8082 ^
                        -e DB_URL="${ENV_DB_URL}" ^
                        -e DB_USER="${ENV_DB_USER}" ^
                        -e DB_PASSWORD="${ENV_DB_PASS}" ^
                        -e MAIL_USERNAME="${ENV_MAIL_USER}" ^
                        -e MAIL_PASSWORD="${ENV_MAIL_PASS}" ^
                        -e JWT_SECRET="${ENV_JWT_SECRET}" ^
                        -e FRONTEND_URL="${ENV_FRONTEND_URL}" ^
                        ${IMAGE_NAME}:${TAG}
                    """
                }
            }
        }
    }
}