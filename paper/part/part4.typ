= Thí nghiệm

Chúng tôi đánh giá hệ thống SLAM của mình trên nhiều bộ dữ liệu khác nhau, cả thực tế và tổng hợp, với các kích thước và độ phức tạp khác nhau. Chúng tôi cũng tiến hành một nghiên cứu loại trừ toàn diện để hỗ trợ các lựa chọn thiết kế của mình.

== Cài đặt thí nghiệm

Bộ dữ liệu. Chúng tôi xem xét 5 bộ dữ liệu đa năng: Replica [44], ScanNet [13], bộ dữ liệu TUM RGB-D [45], bộ dữ liệu Co-Fusion [39], cùng với một bộ dữ liệu tự chụp từ một căn hộ lớn với nhiều phòng. Chúng tôi thực hiện các bước tiền xử lý giống như cho bộ dữ liệu TUM RGB-D theo [53].

Cơ sở so sánh. Chúng tôi so sánh với TSDF-Fusion [11] sử dụng các vị trí camera của mình với độ phân giải lưới voxel $256^3$ (kết quả với độ phân giải cao hơn được báo cáo trong tài liệu bổ sung), DI-Fusion [16] sử dụng cài đặt chính thức của họ, cùng với iMAP của chúng tôi [46] (phiên bản tái triển khai): iMAP`*`. Phiên bản tái triển khai của chúng tôi có hiệu suất tương tự như iMAP gốc trong cả tái cấu trúc cảnh và theo dõi camera.

Đo lường. Chúng tôi sử dụng cả chỉ số 2D và 3D để đánh giá hình học cảnh. Đối với chỉ số 2D, chúng tôi đánh giá mất mát $L_1$ trên 1000 bản đồ độ sâu lấy mẫu ngẫu nhiên từ cả mô hình tái cấu trúc và mô hình thật. Để so sánh công bằng, chúng tôi áp dụng bộ giải đối xứng [2] cho DI-Fusion [16] và TSDF-Fusion để lấp đầy các lỗ độ sâu trước khi tính toán mất mát $L_1$ trung bình. Đối với các chỉ số 3D, chúng tôi làm theo [46] và xem xét Độ chính xác [cm], Hoàn thành [cm], và Tỷ lệ hoàn thành [$< 5 c m$], ngoại trừ việc chúng tôi loại bỏ các khu vực chưa được nhìn thấy không nằm trong phạm vi quan sát của bất kỳ camera nào. Để đánh giá theo dõi camera, chúng tôi sử dụng ATE RMSE [45]. Nếu không được chỉ định, mặc định chúng tôi báo cáo kết quả trung bình của 5 lần chạy.

Chi tiết triển khai. Chúng tôi chạy hệ thống SLAM của mình trên một PC để bàn với CPU Intel i7-10700K 3.80GHz và GPU NVIDIA RTX 3090. Trong tất cả các thí nghiệm của mình, chúng tôi sử dụng số điểm lấy mẫu trên một tia $N_"strat"$ = 32 và $N_"imp"$ = 16, trọng số mất mát quang học $λ_p$ = 0.2 và $λ_"pt"$ = 0.5. Đối với các bộ dữ liệu tổng hợp quy mô nhỏ (Replica và Co-Fusion), chúng tôi chọn K = 5 keyframes và lấy mẫu M = 1000 và Mt = 200 điểm ảnh. Đối với các bộ dữ liệu thực tế quy mô lớn (ScanNet và cảnh tự ghi lại của chúng tôi), chúng tôi sử dụng K = 10, M = 5000, $M_t$ = 1000. 

#figure(
  image("../data/Result of Replica.png"),
  caption: [
    Kết quả tái tạo trên bộ dữ liệu Replica [44]. iMAP`*` đề cập đến việc tái triển khai iMAP của chúng tôi.
  ]
)

\

Đối với bộ dữ liệu khó khăn TUM RGB-D, chúng tôi sử dụng K = 10, M = 5000, Mt = 5000. Đối với việc tái triển khai iMAP`*` của chúng tôi, chúng tôi tuân theo tất cả các siêu tham số đã đề cập trong [46] ngoại trừ việc chúng tôi đặt số điểm ảnh lấy mẫu là 5000 vì nó mang lại hiệu suất tốt hơn trong cả tái tạo và theo dõi.

\
#figure(
  align(
    center,
  )[
    #table(
      columns: 5, align: (left, center, center, center, center,), table.header([Method], table.cell(
        align: center, colspan: 4,
      )[Reconstruction Results (average over 8 scenes)]), table.hline(), [2-5], [Mem. (MB)], [Depth L1 $arrow.b$], [Acc. $arrow.b$], [Comp. $arrow.b$], [TSDF-Fusion \[11\]], [67.10], [7.57], [1.60], [3.49], [iMAP \[46\]], [1.04], [23.33], [6.95], [5.33], [iMAP$ast.basic$ \[46\]], [3.78], [23.53], [19.40], [10.19], [DI-Fusion \[16\]], [12.02], [3.53], [2.85], [3.00], [NICE-SLAM], [12.96], [2.85], [2.65], [3.00],
    )], 
    supplement: "Bảng",
    caption: 
    [iMAP`*` chỉ đến việc tái triển khai lại iMAP của chúng tôi. TSDF-Fusion sử dụng vị trí camera từ NICE-SLAM.
      ],
)

== Đánh giá về Bản đồ hóa và Theo dõi

*Đánh giá trên Replica [44].
*Để đánh giá trên tập dữ liệu Replica [44], chúng tôi sử dụng cùng chuỗi ảnh RGB-D đã được render do tác giả của iMAP cung cấp. Với biểu diễn cảnh theo phân cấp, phương pháp của chúng tôi có thể tái tạo hình học một cách chính xác trong số vòng lặp giới hạn. Như được trình bày trong Bảng 1, NICE-SLAM vượt trội hơn đáng kể so với các phương pháp nền tảng ở hầu hết các chỉ số, đồng thời duy trì mức tiêu thụ bộ nhớ hợp lý. Về mặt chất lượng, như thể hiện ở Hình 3, phương pháp của chúng tôi tạo ra hình học sắc nét hơn và ít tạo ra các hiện tượng nhiễu (artifact) hơn.

*Đánh giá trên TUM RGB-D [45].*
Chúng tôi cũng đánh giá hiệu suất theo dõi camera trên tập dữ liệu nhỏ TUM RGB-D. Như thể hiện trong Bảng 2, phương pháp của chúng tôi vượt trội hơn iMAP và DI-Fusion mặc dù về thiết kế, phương pháp của chúng tôi phù hợp hơn với các cảnh lớn. Có thể nhận thấy rằng các phương pháp hiện đại nhất trong việc theo dõi (ví dụ: BAD-SLAM [42], ORB-SLAM2 [26]) vẫn vượt trội hơn các phương pháp dựa trên biểu diễn cảnh ẩn (iMAP [46] và phương pháp của chúng tôi). Tuy nhiên, phương pháp của chúng tôi đã rút ngắn đáng kể khoảng cách giữa hai nhóm phương pháp này, đồng thời vẫn giữ được lợi thế về biểu diễn của mô hình cảnh ẩn.

\

#figure(
  align(
    center,
  )[#table(
      columns: 5, align: (left, center, center, center, center,), table.header([Scene ID], [fr1/desk], [fr2/xyz], [fr3/office], []), table.hline(), [iMAP \[46\]], [4.9], [2.0], [5.8], [], [iMAP$ast.basic$ \[46\]], [7.2], [2.1], [9.0], [], [DI-Fusion \[16\]], [4.4], [2.3], [15.6], [], [NICE-SLAM], [2.7], [1.8], [3.0], [], [BAD-SLAM \[42\]], [1.7], [1.1], [1.7], [], [Kintinuous \[59\]], [3.7], [2.9], [3.0], [], [ORB-SLAM2 \[26\]], [1.6], [0.4], [1.0], [],
    )], caption: [*Kết quả theo dõi camera trên ScanNet \[13\].* Kết quả theo dõi camera trên bộ dữ liệu TUM RGB-D \[45\]. ATE RMSE \[cm\] ($arrow.b$) được sử dụng làm chỉ số đánh giá. NICE-SLAM giảm khoảng cách giữa các phương pháp SLAM với đại diện ẩn và các phương pháp truyền thống. Chúng tôi báo cáo kết quả tốt nhất trong 5 lần chạy cho tất cả các phương pháp trong bảng này. Các số liệu cho iMAP, BAD-SLAM, Kintinuous và ORB-SLAM2 được lấy từ \[46\].], supplement: "Bảng", 
)

*Đánh giá trên ScanNet [13].*
Chúng tôi chọn nhiều cảnh lớn từ tập dữ liệu ScanNet [13] để đánh giá khả năng mở rộng của các phương pháp khác nhau. Về mặt hình học, như thể hiện ở Hình 4, có thể thấy rõ rằng NICE-SLAM tạo ra hình học sắc nét và chi tiết hơn so với TSDF-Fusion, DI-Fusion và iMAP$ast.basic$. Về theo dõi, có thể quan sát thấy rằng iMAP$ast.basic$ và DI-Fusion hoặc là thất bại hoàn toàn hoặc xuất hiện lỗi trôi lớn, trong khi phương pháp của chúng tôi thành công trong việc tái tạo toàn bộ cảnh. Về mặt định lượng, kết quả theo dõi của chúng tôi cũng chính xác hơn đáng kể so với cả DI-Fusion và iMAP$ast.basic$ như thể hiện trong Bảng 3.

*Đánh giá trên Cảnh Lớn hơn.
*Để đánh giá khả năng mở rộng của phương pháp, chúng tôi đã thu thập một chuỗi dữ liệu trong một căn hộ lớn với nhiều phòng. Hình 1 và Hình 5 cho thấy các bản dựng lại bằng NICE-SLAM, DI-Fusion [16] và iMAP$ast.basic$[46]. Để tham khảo, chúng tôi cũng trình bày bản dựng 3D bằng công cụ offline Redwood [10] trong Open3D [69]. Có thể thấy rằng NICE-SLAM đạt được kết quả tương đương với phương pháp offline, trong khi iMAP$ast.basic$ và DI-Fusion không thể dựng lại toàn bộ chuỗi dữ liệu.

\

#figure(
  align(
    center,
  )[#table(
      columns: 8, align: (left, center, center, center, center,), table.header([Scene ID], [0000], [0059], [0106], [0169], [0181], [0207], [Avg]), table.hline(), 
      [*iMAP*$ast.basic$ \[46\]], 
      [55.95], [32.06], [17.50], [70.51],[32.10], [11.91], [36.67],
       [*DI-Fusion* \[16\]], [62.99], [128.00], [18.50], [75.80], [87.88], [100.19], [78.89],
       [*NICE-SLAM*], [8.64], [12.25], [8.09], [10.28],[12.93], [5.59], [9.63],
    )],
    supplement: "Bảng",
     caption: [*Camera Tracking trên ScanNet*.Phương pháp của chúng tôi cho kết quả tốt hơn trên bộ dữ liệu này. ATE RMSE ($arrow.b$) được sử dụng làm chỉ số đánh giá.],
)

== Phân tích hiệu suất 
Ngoài việc đánh giá tái tạo cảnh và theo dõi camera trên các bộ dữ liệu khác nhau, trong phần tiếp theo, chúng tôi cũng đánh giá các đặc điểm khác của pipeline được đề xuất. 

#figure(
  image("/paper/data/3D Reconstruction and Tracking on ScanNet .png"),
  caption: [
    Tái tạo 3D và Theo dõi trên ScanNet [13].
Đoạn đường màu đen là kết quả theo dõi từ ScanNet [13], trong khi đoạn đường màu đỏ là kết quả theo dõi của các phương pháp. Chúng tôi đã thử nghiệm nhiều tham số khác nhau cho iMAP`*` và trình bày các kết quả tốt nhất, nhưng hầu hết đều không đạt.
  ]
)

#figure(
  image("/paper/data/3D Reconstruction and Tracking on a Multi-room Apartment..png"), 
  caption: [Tái tạo 3D và Theo dõi trên Căn hộ nhiều phòng. Đoạn đường theo dõi camera được hiển thị bằng màu đỏ. iMAP`*` và DI-Fusion không thể tái tạo toàn bộ chuỗi. Chúng tôi cũng cho thấy kết quả từ một phương pháp ngoại tuyến [10] để tham khảo.

  ]
)

\

#figure(
  align(
    center,
  )[#table(
      columns: 4, align: (left, center, center, center,), table.header(
        [#strong[Phương pháp];], [#strong[FLOPs \[$times$10³\]$arrow.b$];], [#strong[Theo dõi (ms)$arrow.b$];], [#strong[Tạo bản đồ (ms)$arrow.b$];],
      ), table.hline(), [iMAP \[46\]], [443.91], [101], [448], [NICE-SLAM], [104.16], [47], [130],
    )], caption: [Tính toán và Thời gian chạy. Đại diện cảnh của chúng tôi không chỉ cải thiện chất lượng tái tạo và theo dõi mà còn nhanh hơn. Thời gian chạy cho iMAP được lấy từ \[46\].], supplement: "Bảng"
)

#strong[Độ phức tạp tính toán.] Trước tiên, chúng tôi so sánh số lượng phép toán điểm nổi (FLOPs) cần thiết để truy vấn màu sắc và mật độ chiếm đóng/thể tích của một điểm 3D, xem Bảng 4. Phương pháp của chúng tôi yêu cầu chỉ 1/4 FLOPs so với iMAP. Đáng chú ý, FLOPs trong phương pháp của chúng tôi vẫn giữ nguyên ngay cả đối với những cảnh rất lớn. Ngược lại, do việc sử dụng một MLP duy nhất trong iMAP, giới hạn dung lượng của MLP có thể yêu cầu nhiều tham số hơn dẫn đến nhiều FLOPs hơn.

#strong[Thời gian chạy.] Chúng tôi cũng so sánh trong Bảng 4 thời gian chạy cho theo dõi và tạo bản đồ sử dụng cùng số lượng mẫu pixel ($M_t$ = 200 cho theo dõi và M = 1000 cho tạo bản đồ). Chúng tôi nhận thấy rằng phương pháp của chúng tôi nhanh hơn hơn 2x và 3x so với iMAP trong theo dõi và tạo bản đồ. Điều này chỉ ra lợi thế của việc sử dụng các lưới đặc trưng với bộ giải MLP nông thay vì một MLP nặng.

#strong[Độ bền với các đối tượng động.] Ở đây, chúng tôi xem xét bộ dữ liệu Co-Fusion \[39\] chứa các đối tượng di chuyển động. Như minh họa trong Hình 6, phương pháp của chúng tôi đúng đắn nhận diện và bỏ qua các mẫu pixel rơi vào đối tượng động trong quá trình tối ưu hóa, giúp cải thiện mô hình đại diện cảnh (xem các RGB và độ sâu đã được render). Hơn nữa, chúng tôi cũng so sánh với iMAP$ast.basic$ trên cùng một chuỗi cho theo dõi camera. Kết quả ATE RMSE của chúng tôi và iMAP$ast.basic$ lần lượt là 1.6cm và 7.8cm, điều này rõ ràng chứng minh độ bền của chúng tôi với các đối tượng động.

#strong[Dự báo hình học và Lấp đầy lỗ.] Như minh họa trong Hình 7, chúng tôi có thể hoàn thiện các khu vực cảnh chưa được quan sát nhờ vào việc sử dụng cảnh prior mức độ thô. Ngược lại, các khu vực chưa thấy được tái tạo lại bởi iMAP$ast.basic$ rất ồn ào do không có thông tin prior cảnh nào được mã hóa trong iMAP$ast.basic$.

#figure(
  image("/paper/data/Robustness to Dynamic Objects.png"),
  caption: [Độ bền với các đối tượng động.
Chúng tôi hiển thị các pixel mẫu được chồng lên một hình ảnh có một đối tượng động ở giữa (bên trái), RGB đã render của chúng tôi (giữa) và độ sâu đã render của chúng tôi (phải) để minh họa khả năng xử lý môi trường động. Các mẫu pixel bị che khuất trong quá trình theo dõi được tô màu đen, trong khi các mẫu đã sử dụng được hiển thị bằng màu đỏ.
  ]
)

#figure(
  image("/paper/data/Geometry Forecast and Hole Filling.png"),
  caption: [Dự báo hình học và Lấp đầy lỗ.
Khu vực được tô màu trắng là khu vực có quan sát, và màu xanh lam chỉ ra khu vực chưa được quan sát nhưng đã được dự đoán. Nhờ vào việc sử dụng cảnh prior mức độ thô, phương pháp của chúng tôi có khả năng dự đoán tốt hơn so với iMAP`*`, điều này cũng cải thiện hiệu suất theo dõi của chúng tôi.
  ]
)

#pagebreak()

== Nghiên cứu loại trừ

Trong phần này, chúng tôi nghiên cứu sự lựa chọn của kiến trúc phân cấp và tầm quan trọng của đại diện màu sắc.

Kiến trúc phân cấp. Hình 8 so sánh kiến trúc phân cấp của chúng tôi với: a) một lưới đặc trưng với độ phân giải giống như đại diện cấp thấp của chúng tôi (Chỉ độ phân giải cao); b) một lưới đặc trưng với độ phân giải mức trung bình (Chỉ độ phân giải thấp). Kiến trúc phân cấp của chúng tôi có thể nhanh chóng thêm các chi tiết hình học khi đại diện cấp thấp tham gia vào tối ưu hóa, điều này cũng dẫn đến việc hội tụ tốt hơn.

BA cục bộ. Chúng tôi xác minh hiệu quả của việc điều chỉnh theo nhóm cục bộ trên ScanNet [13]. Nếu chúng tôi không tối ưu hóa đồng thời các vị trí camera cho K keyframes cùng với đại diện cảnh (không có BA cục bộ trong Bảng 5), việc theo dõi camera không chỉ kém chính xác hơn mà còn kém bền vững.

Đại diện màu sắc. Trong Bảng 5, chúng tôi so sánh phương pháp của chúng tôi mà không có mất mát quang học $L_p$ trong phương trình (9). Kết quả cho thấy mặc dù các màu sắc ước tính của chúng tôi không hoàn hảo do ngân sách tối ưu hóa hạn chế và thiếu điểm mẫu, việc học một đại diện màu sắc vẫn đóng vai trò quan trọng trong việc theo dõi camera chính xác.

Lựa chọn keyframe. Chúng tôi kiểm tra phương pháp của mình bằng cách sử dụng chiến lược lựa chọn keyframe của iMAP (với keyframe iMAP trong Bảng 5) nơi chúng chọn keyframes từ toàn bộ cảnh. Điều này là cần thiết cho iMAP để ngăn chặn MLP đơn giản của họ quên đi hình học trước đó. Tuy nhiên, nó cũng dẫn đến hội tụ chậm và theo dõi không chính xác.

#figure(
  image("../data/Hierarchical Architecture Ablation.png"),
  caption: [Thử nghiệm với Kiến trúc phân cấp.
Tối ưu hóa hình học trên một ảnh độ sâu duy nhất của Replica [44] với các kiến trúc khác nhau. Các đường cong đã được làm mịn để dễ dàng hình dung hơn.
  ]
)


\

#figure(
  align(center,
  )[#table(
    columns: 5, align: (left, center, center, center, center),
    table.header(
      [ATE RMSE ($arrow.b$)],
      [#strong[w/o Local-BA]],
      [#strong[w/o $cal(L)_p$]],
      [#strong[w/ iMAP-keyframes]],
      [#strong[Full]],
      table.hline(),
    [Mean], [37.74], [32.02], [12.10], [9.63],
    [Std.], [30.97], [21.98], [3.38], [0.62]

  ))],
  caption: [ *Nghiên cứu loại trừ.*
Chúng tôi nghiên cứu tính hữu ích của BA cục bộ, đại diện màu sắc, cũng như chiến lược lựa chọn keyframe của chúng tôi. Chúng tôi chạy mỗi cảnh 5 lần và tính toán giá trị trung bình và độ lệch chuẩn của ATE RMSE ($arrow.b$) trên 6 cảnh trong ScanNet [13].],
  supplement: "Bảng"
)
