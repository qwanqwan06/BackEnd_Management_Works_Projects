pipeline {
    agent any

    environment {
        // 1. Thông tin Docker Hub (Lấy an toàn từ Credentials)
        // ID 'dockerhub-credentials' phải khớp với cái bạn tạo trong Jenkins
        DOCKER_CRED = credentials('dockerhub-credentials')
        
        // 2. Thông tin Image
        IMAGE_NAME = 'wan066/project-manager-api'
        TAG = 'latest'

        // 3. Link Deploy Hook của Render (Lấy an toàn từ Credentials)
        // ID 'render-deploy-hook' phải khớp với cái bạn tạo trong Jenkins
        RENDER_HOOK_URL = credentials('render-deploy-hook')
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
                    echo '🔨 Đang build Docker Image...'
                    // Dùng 'bat' cho Windows
                    bat "docker build -t ${IMAGE_NAME}:${TAG} ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    echo '☁️ Đang đẩy Image lên Docker Hub...'
                    // Đăng nhập và đẩy lên dùng Credential bảo mật
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        docker.image("${IMAGE_NAME}:${TAG}").push()
                    }
                }
            }
        }

        stage('Deploy to Render') {
            steps {
                script {
                    echo '🚀 Đang kích hoạt Render Deploy...'
                    // Gọi Webhook bí mật để Render tự kéo code về
                    // Lưu ý: Trên Windows (bat), curl cần xử lý cẩn thận
                    try {
                        // Cách gọi đơn giản nhất trên Windows Jenkins
                        bat "curl -X POST \"${RENDER_HOOK_URL}\""
                    } catch (Exception e) {
                        echo "Lỗi khi gọi Webhook: ${e.getMessage()}"
                        // Đánh dấu build là thất bại nếu không gọi được Render
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ Build & Push thành công! Hãy kiểm tra Dashboard Render.'
        }
        failure {
            echo '❌ Có lỗi xảy ra. Vui lòng kiểm tra log.'
        }
    }
}