package com.quanlyduan.project_manager_api.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig {

    // Lấy giá trị từ application.properties
    // Local: http://localhost:3000
    // Render: https://worknet-frontend.vercel.app
    @Value("${app.frontend.url}")
    private String frontendUrl;

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**") // Áp dụng cho TẤT CẢ các API
                        .allowedOrigins(frontendUrl) // CHỈ CHO PHÉP frontend này gọi vào
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH") // Cho phép các method này
                        .allowedHeaders("*") // Cho phép mọi header (như Authorization, Content-Type...)
                        .allowCredentials(true) // Cho phép gửi kèm cookies hoặc thông tin xác thực
                        .maxAge(3600); // Cache cấu hình này trong 1 giờ để đỡ phải hỏi lại
            }
        };
    }
}