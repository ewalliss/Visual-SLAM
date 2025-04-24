= Các công trình nghiên cứu liên quan

Trong những năm gần đây, nhiều nghiên cứu đã được thực hiện để giải quyết các vấn đề liên quan đến việc xây dựng bản đồ 3D và định vị đồng thời (SLAM) trong các môi trường phức tạp, đặc biệt là khi sử dụng dữ liệu từ các cảm biến RGB-D. Một số phương pháp truyền thống đã đạt được những thành công nhất định, tuy nhiên, chúng vẫn gặp phải nhiều hạn chế khi xử lý các cảnh lớn và động.

Một trong những nghiên cứu đáng chú ý là KinectFusion của Newcombe et al. (2011), nghiên cứu này giới thiệu một phương pháp xây dựng bản đồ dày đặc theo thời gian thực với sự hỗ trợ của camera Kinect, giúp tái tạo các bề mặt 3D chi tiết từ các ảnh RGB và độ sâu . Hệ thống này đã mở ra hướng đi mới trong việc tái tạo không gian 3D với độ chính xác cao, nhưng vẫn gặp phải khó khăn trong việc duy trì hiệu suất khi môi trường có sự thay đổi hoặc thiếu hụt dữ liệu.

Các nghiên cứu gần đây hơn, chẳng hạn như DTAM của Newcombe et al. (2011) và ElasticFusion của Whelan et al. (2015) , đã tiếp tục phát triển các phương pháp SLAM dày đặc mà không cần đồ thị vị trí, mang lại kết quả tốt hơn trong môi trường không có điểm đánh dấu rõ ràng. Tuy nhiên, các phương pháp này vẫn gặp vấn đề khi mở rộng quy mô và xử lý môi trường phức tạp.

Với sự phát triển của học sâu và các mô hình đại diện ẩn, các phương pháp mới như NICE-SLAM và Nerf (Mildenhall et al., 2020) đã mở ra một kỷ nguyên mới trong việc mô hình hóa và tái tạo hình học 3D. NICE-SLAM sử dụng đại diện ẩn thần kinh để xây dựng bản đồ 3D một cách chính xác hơn, vượt qua được nhiều hạn chế của các phương pháp SLAM truyền thống. Đồng thời, việc sử dụng các mạng thần kinh sâu giúp hệ thống có thể thích ứng với các thay đổi trong cảnh vật và tăng tính ổn định khi xử lý dữ liệu nhiễu hoặc thiếu hụt​.

Bên cạnh đó, các nghiên cứu về Nerf (Neural Radiance Fields) như Mildenhall et al. (2020) và Martin-Brualla et al. (2021) đã đưa ra các phương pháp sử dụng các trường độ sáng thần kinh để tái tạo cảnh vật một cách chi tiết từ các bộ ảnh chụp khác nhau, cho phép tổng hợp hình ảnh và hình học 3D ở độ phân giải cao .

Những tiến bộ này trong việc sử dụng các mô hình đại diện ẩn và học sâu cho thấy tiềm năng lớn của các phương pháp SLAM mới trong việc cải thiện hiệu quả và độ chính xác của việc tái tạo 3D trong các môi trường phức tạp và động.