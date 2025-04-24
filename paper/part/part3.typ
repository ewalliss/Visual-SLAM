= Phương pháp

Chúng tôi cung cấp tổng quan về phương pháp của chúng tôi trong Hình 2. Chúng tôi biểu diễn hình học và ngoại hình của cảnh bằng cách sử dụng bốn lưới đặc trưng và các bộ giải mã tương ứng của chúng (Mục 3.1). Chúng tôi truy vết các tia quan sát cho mỗi điểm ảnh bằng cách sử dụng hiệu chuẩn máy ảnh đã ước tính. Bằng cách lấy mẫu các điểm dọc theo tia quan sát và truy vấn mạng, chúng tôi có thể hiển thị cả giá trị độ sâu và màu sắc của tia này (Mục 3.2). Bằng cách giảm thiểu các tổn thất tái hiển thị cho độ sâu và màu sắc, chúng tôi có thể tối ưu hóa cả vị trí máy ảnh và hình học cảnh theo cách luân phiên (Mục 3.3) cho các khung hình chính được chọn (Mục 3.4).

#figure(
    image("../data/Nice-Slam-system.png"),

    caption: [
        Tổng quan hệ thống. Phương pháp của chúng tôi nhận một luồng ảnh RGB-D làm đầu vào và xuất ra cả vị trí máy ảnh cùng với một biểu diễn cảnh đã học dưới dạng lưới đặc trưng phân cấp. Từ phải sang trái, quy trình của chúng tôi có thể được hiểu như một mô hình sinh tạo ra các ảnh độ sâu và màu từ một biểu diễn cảnh và vị trí máy ảnh đã cho. Trong thời gian thử nghiệm, chúng tôi ước tính cả biểu diễn cảnh và vị trí máy ảnh bằng cách giải quyết bài toán nghịch đảo thông qua việc lan truyền ngược lỗi tái tạo ảnh và độ sâu qua một bộ kết xuất có thể phân biệt (từ trái sang phải). Cả hai thực thể này được ước tính trong một tối ưu hóa thay phiên: Lập bản đồ: Việc lan truyền ngược chỉ cập nhật biểu diễn cảnh phân cấp; Theo dõi: Việc lan truyền ngược chỉ cập nhật vị trí máy ảnh. Để dễ đọc hơn, chúng tôi kết hợp lưới chi tiết cao dùng để mã hóa hình học với lưới màu có kích thước tương đương và hiển thị chúng như một lưới duy nhất với hai thuộc tính (đỏ và cam).
    ]
)

== Biểu diễn cảnh phân cấp
Bây giờ chúng tôi giới thiệu biểu diễn cảnh phân cấp của chúng tôi kết hợp các đặc trưng lưới đa cấp với các bộ giải mã được huấn luyện trước cho các dự đoán độ chiếm dụng. Hình học được mã hóa thành ba lưới đặc trưng $Phi^l_theta$ và các bộ giải mã MLP tương ứng $f^l$, trong đó $l in {0,1,2} $ được gọi là chi tiết cảnh ở mức thô, trung và tinh. Ngoài ra, chúng tôi cũng có một lưới đặc trưng duy nhất $psi_omega$ và bộ giải mã $g_omega$ để mô hình hóa ngoại hình của cảnh. Ở đây $theta$ và $omega$ chỉ ra các tham số có thể tối ưu hóa cho hình học và màu sắc, tức là các đặc trưng trong lưới và trọng số trong bộ giải mã màu.

*Biểu diễn hình học mức mid và fine.* Hình học cảnh quan sát được biểu diễn trong các lưới đặc trưng mức trung và tinh. Trong quá trình tái tạo, chúng tôi sử dụng hai lưới này trong cách tiếp cận từ thô đến tinh, trong đó hình học được tái tạo đầu tiên bằng cách tối ưu hóa lưới đặc trưng mức trung, tiếp theo là sự tinh chỉnh sử dụng mức tinh. Trong cài đặt, chúng tôi sử dụng lưới voxel với độ dài cạnh lần lượt là 32cm và 16cm, ngoại trừ TUM RGB-D, chúng tôi sử dụng 16cm và 8cm. Đối với mức trung, các đặc trưng được giải mã trực tiếp thành giá trị độ chiếm dụng bằng cách sử dụng MLP liên kết f1. Đối với bất kỳ điểm p ∈ $RR^3$, chúng tôi nhận được độ chiếm dụng là:

$
  o_1 (p) = f_1 (p, phi.alt_1^theta (p))
$

trong đó $Phi^l_theta (p)$ biểu thị rằng lưới đặc trưng được nội suy tam tuyến tại điểm p. Độ phân giải tương đối thấp cho phép chúng tôi tối ưu hóa hiệu quả các đặc trưng lưới để phù hợp với các quan sát. Để nắm bắt các chi tiết tần số cao nhỏ hơn trong hình học cảnh, chúng tôi thêm vào các đặc trưng mức tinh theo cách dư thừa. Cụ thể, bộ giải mã đặc trưng mức tinh lấy đầu vào cả đặc trưng mức trung tương ứng và đặc trưng mức tinh và xuất ra một độ lệch từ độ chiếm dụng mức trung, tức là:

$
Delta o_1 (p) = f_2 (p, phi.alt_1^theta (p), phi.alt_2^theta (p))
$               

trong đó độ chiếm dụng cuối cùng cho một điểm được cho bởi:

$
  o(p) = o_1 (p) + Delta o_1 (p)
$

*Lưu ý rằng* chúng tôi cố định các bộ giải mã được huấn luyện trước $f^1$ và $f^2$, và chỉ tối ưu hóa các lưới đặc trưng $Phi^1_theta$ và $Phi^2_theta$ trong suốt quá trình tối ưu hóa. Chúng tôi chứng minh rằng điều này giúp ổn định quá trình tối ưu hóa và học hình học nhất quán.

*Biểu diễn hình học mức thô.* Lưới đặc trưng mức thô nhằm nắm bắt hình học cấp cao của cảnh (ví dụ: tường, sàn, v.v.), và được tối ưu hóa độc lập với mức trung và tinh. Mục tiêu của lưới thô là có thể dự đoán giá trị độ chiếm dụng xấp xỉ bên ngoài hình học đã được quan sát (được mã hóa trong các mức trung/tinh), ngay cả khi mỗi voxel thô chỉ được quan sát một phần. Vì lý do này, chúng tôi sử dụng độ phân giải rất thấp, với độ dài cạnh là 2m trong cài đặt. Tương tự như lưới mức trung, chúng tôi giải mã trực tiếp thành giá trị độ chiếm dụng bằng cách nội suy các đặc trưng và chuyển qua MLP $f^0$, tức là:

$
  o_0 (p) = f_0 (p, phi.alt_0^theta (p))
$

Trong quá trình theo dõi, các giá trị độ chiếm dụng mức thô chỉ được sử dụng để dự đoán các phần cảnh chưa được quan sát trước đó. Hình học được dự báo này cho phép chúng tôi theo dõi ngay cả khi một phần lớn của hình ảnh hiện tại chưa được thấy trước đó.

*Huấn luyện trước các bộ giải mã đặc trưng*. Trong khuôn khổ của chúng tôi, chúng tôi sử dụng ba MLP cố định khác nhau để giải mã các đặc trưng lưới thành giá trị độ chiếm dụng. Các bộ giải mã mức thô và trung được huấn luyện trước như một phần của ConvONet bao gồm một bộ mã hóa CNN và một bộ giải mã MLP. Chúng tôi huấn luyện cả bộ mã hóa/giải mã bằng cách sử dụng hàm mất mát entropy chéo nhị phân giữa giá trị dự đoán và giá trị thực tế, giống như trong [37]. Sau khi huấn luyện, chúng tôi chỉ sử dụng bộ giải mã MLP, vì chúng tôi sẽ tối ưu hóa trực tiếp các đặc trưng để phù hợp với các quan sát trong đường dẫn tái tạo của chúng tôi. Bằng cách này, bộ giải mã được huấn luyện trước có thể tận dụng các đặc tính cụ thể về độ phân giải được học từ tập huấn luyện, khi giải mã các đặc trưng đã tối ưu hóa của chúng tôi.

Chiến lược tương tự được sử dụng để huấn luyện trước bộ giải mã mức tinh, ngoại trừ việc chúng tôi đơn giản nối đặc trưng $Phi^1_theta (p)$ từ mức trung cùng với đặc trưng mức tinh $Phi^2_theta (p)$ trước khi đưa vào bộ giải mã.
Biểu diễn màu sắc. Trong khi chúng tôi chủ yếu quan tâm đến hình học cảnh, chúng tôi cũng mã hóa thông tin màu sắc cho phép chúng tôi hiển thị hình ảnh RGB, cung cấp tín hiệu bổ sung cho việc theo dõi. Để mã hóa màu sắc trong cảnh, chúng tôi áp dụng một lưới đặc trưng khác ψω và bộ giải mã gω:

$
  c_p = g_omega (p, psi_omega (p)),
$

*Trong đó* ω chỉ ra các tham số có thể học được trong quá trình tối ưu hóa. Khác với hình học có kiến thức tiên nghiệm mạnh mẽ, chúng tôi nhận thấy qua thực nghiệm rằng việc tối ưu hóa đồng thời các đặc trưng màu ψω và bộ giải mã gω cải thiện hiệu suất theo dõi (xem Bảng 5). Lưu ý rằng, tương tự như iMAP [46], điều này có thể dẫn đến vấn đề quên và màu sắc chỉ nhất quán cục bộ. Nếu chúng tôi muốn hiển thị màu sắc cho toàn bộ cảnh, nó có thể được tối ưu hóa toàn cục như một bước hậu xử lý.

*Thiết kế mạng.* Đối với tất cả các bộ giải mã MLP, chúng tôi sử dụng kích thước đặc trưng ẩn là 32 và 5 khối được kết nối đầy đủ. Ngoại trừ biểu diễn hình học mức thô, chúng tôi áp dụng mã hóa vị trí Gaussian có thể học được [46, 49] cho p trước khi đưa vào các bộ giải mã MLP. Chúng tôi nhận thấy điều này cho phép khám phá các chi tiết tần số cao cho cả hình học và ngoại hình.

== Hiển thị độ sâu và màu sắc
Lấy cảm hứng từ thành công gần đây của kỹ thuật hiển thị thể tích trong NeRF [25], chúng tôi đề xuất cũng sử dụng một quy trình hiển thị khả vi phân tích hợp độ chiếm dụng và màu sắc dự đoán từ biểu diễn cảnh của chúng tôi trong Mục 3.1.

Với các tham số nội của máy ảnh và vị trí máy ảnh hiện tại, chúng tôi có thể tính toán hướng quan sát r của tọa độ điểm ảnh. Chúng tôi trước tiên lấy mẫu dọc theo tia này $N_"strat"$ điểm cho việc lấy mẫu phân tầng, và cũng lấy mẫu đồng đều $N_"imp"$ điểm gần độ sâu. Tổng cộng chúng tôi lấy mẫu $N = N_"strat" + N_"imp"$ điểm cho mỗi tia. Chính thức hơn, để $p_i= 0+ d_(i) r$, i ∈ {1, ..., N} biểu thị các điểm lấy mẫu trên tia r với gốc máy ảnh o, và di tương ứng với giá trị độ sâu của $p_i$ dọc theo tia này. Đối với mỗi điểm $p_i$, chúng tôi có thể tính toán xác suất độ chiếm dụng mức thô $o_(p_i)^0$, xác suất độ chiếm dụng mức tinh $o_(p_i)$, và giá trị màu sắc $c_(p_i)$ sử dụng Phương trình (4), Phương trình (3), và Phương trình (5). Tương tự như [34], chúng tôi mô hình hóa xác suất kết thúc tia tại điểm $p_i$ là $w_c^i = o_(p_i) product_(j = 1)^(i - 1)(1 - o_(p_j))$ cho mức thô, và$w_f^i = o_(p_i) product_(j = 1)^(i - 1)(1 - o_(p_j))$ cho mức tinh.

Cuối cùng đối với mỗi tia, độ sâu ở cả mức thô và tinh, và màu sắc có thể được hiển thị như sau:

$
hat(D)^(c) = sum_(i = 1)^N w_i^c d_i, \
hat(D)^(f) = sum_(i = 1)^N w_i^f d_i, \
hat(I) = sum_(i = 1)^N w_i^f c_i
$

Hơn nữa, chúng tôi cũng tính toán phương sai độ sâu dọc theo tia:

$
hat(D)_(v a r)^(c) = sum_(i = 1)^N w_i^c (hat(D)^c - d_i)^2, \ 
hat(D)_(v a r)^(f) = sum_(i = 1)^N w_i^f (hat(D)^f - d_i)^2 quad "(7)"
$
3.3. Lập bản đồ và theo dõi

Trong phần này, chúng tôi cung cấp chi tiết về việc tối ưu hóa các tham số hình học $theta$ và ngoại hình $ω$ của biểu diễn cảnh phân cấp của chúng tôi, và của các vị trí máy ảnh.

Lập bản đồ. Để tối ưu hóa biểu diễn cảnh đã đề cập trong Mục 3.1, chúng tôi lấy mẫu đồng đều tổng cộng M điểm ảnh từ khung hình hiện tại và các khung hình chính được chọn. Tiếp theo, chúng tôi thực hiện tối ưu hóa theo từng giai đoạn để giảm thiểu các tổn thất hình học và quang học.

Tổn thất hình học đơn giản là tổn thất $L_1$ giữa các quan sát và độ sâu dự đoán ở mức thô hoặc tinh:

$
  L_g^l = 1/M sum_(m = 1)^M lr(|D_m - hat(D)_m^l |), quad l in {c, f}
$

Tổn thất quang học cũng là tổn thất $L_1$ giữa các giá trị màu sắc được hiển thị và quan sát cho M điểm ảnh được lấy mẫu:

$
  L_p = 1/M sum_(m = 1)^M lr(|I_m - hat(I)_m |)
$

Ở giai đoạn đầu tiên, chúng tôi chỉ tối ưu hóa lưới đặc trưng mức mid $Phi^1_theta$ bằng cách sử dụng tổn thất hình học $L_g^l$ trong Phương trình (8). Tiếp theo, chúng tôi tối ưu hóa đồng thời cả đặc trưng mức mid-fine $Phi^1_theta$, $Phi^2_theta$ với cùng tổn thất độ sâu mức tinh $L_g^l$. Cuối cùng, chúng tôi tiến hành điều chỉnh bó cục bộ (BA) để tối ưu hóa đồng thời các lưới đặc trưng ở tất cả các mức, bộ giải mã màu, cũng như các tham số ngoại của máy ảnh {$R_i, t_i$} của K khung hình chính được chọn:

$
  min_(theta, omega, {R_i, t_i })(L_g^c + L_g^f + lambda_p L_p)
$

trong đó $λ_p$ là hệ số trọng số tổn thất.

Sơ đồ tối ưu hóa đa giai đoạn này dẫn đến sự hội tụ tốt hơn vì các đặc trưng ngoại hình và mức tinh có độ phân giải cao hơn có thể dựa vào hình học đã được tinh chỉnh từ lưới đặc trưng mức trung.

Lưu ý rằng chúng tôi song song hóa hệ thống của chúng tôi trong ba luồng để tăng tốc quá trình tối ưu hóa: một luồng cho lập bản đồ mức thô, một cho tối ưu hóa hình học và màu sắc mức trung & tinh, và một luồng khác cho theo dõi máy ảnh.

*Theo dõi máy ảnh.* Ngoài việc tối ưu hóa biểu diễn cảnh, chúng tôi cũng chạy song song việc theo dõi máy ảnh để tối ưu hóa các vị trí của máy ảnh cho khung hình hiện tại, tức là quay và dịch chuyển {R, t}. Để làm điều này, chúng tôi lấy mẫu $M_t$ điểm ảnh trong khung hình hiện tại và áp dụng cùng tổn thất quang học trong Phương trình (9) nhưng sử dụng tổn thất hình học được sửa đổi:

$
  L_(g - v a r) = 1/M_t sum_(m = 1)^(M_t) lr(|D_m - hat(D)_m^c |) 1/sqrt(hat(D)_(v a r)^c) + lr(|D_m - hat(D)_m^f |) 1/sqrt(hat(D)_(v a r)^f)
$

Tổn thất được sửa đổi giảm trọng số các vùng kém chắc chắn trong hình học được tái tạo [46, 62], ví dụ như các cạnh đối tượng. Việc theo dõi máy ảnh cuối cùng được xây dựng như bài toán tối thiểu hóa sau:
$
  min_(R, t)(L_(g - v a r) + lambda_(p t) L_p)
$

Lưới đặc trưng thô có khả năng thực hiện dự đoán hình học cảnh trong phạm vi ngắn. Hình học ngoại suy này cung cấp tín hiệu có ý nghĩa cho việc theo dõi khi máy ảnh di chuyển vào các khu vực chưa được quan sát trước đó. Điều này làm cho hệ thống mạnh mẽ hơn đối với mất khung hình đột ngột hoặc chuyển động máy ảnh nhanh. Chúng tôi cung cấp các thí nghiệm trong tài liệu bổ sung.

Khả năng chống chịu các đối tượng động. Để làm cho việc tối ưu hóa mạnh mẽ hơn đối với các đối tượng động trong quá trình theo dõi, chúng tôi lọc các điểm ảnh có tổn thất tái hiển thị độ sâu/màu sắc lớn. Cụ thể, chúng tôi loại bỏ bất kỳ điểm ảnh nào khỏi quá trình tối ưu hóa khi tổn thất Phương trình (12) lớn hơn 10× giá trị trung vị của tổn thất của tất cả các điểm ảnh trong khung hình hiện tại. Hình 6 cho thấy một ví dụ trong đó một đối tượng động bị bỏ qua vì nó không có mặt trong hình ảnh RGB và độ sâu được hiển thị. Lưu ý rằng đối với nhiệm vụ này, chúng tôi chỉ tối ưu hóa biểu diễn cảnh trong quá trình lập bản đồ. Việc tối ưu hóa đồng thời các tham số máy ảnh và biểu diễn cảnh trong môi trường động là không tầm thường, và chúng tôi xem xét nó như một hướng thú vị trong tương lai.

== Lựa chọn khung hình chính
Tương tự như các hệ thống SLAM khác, chúng tôi liên tục tối ưu hóa biểu diễn cảnh phân cấp của chúng tôi với một tập hợp các khung hình chính được chọn. Chúng tôi duy trì một danh sách khung hình chính toàn cục theo tinh thần của iMAP [46], nơi chúng tôi tăng dần thêm các khung hình chính mới dựa trên lợi ích thông tin. Tuy nhiên, trái ngược với iMAP [46], chúng tôi chỉ bao gồm các khung hình chính có sự chồng lấp trực quan với khung hình hiện tại khi tối ưu hóa hình học cảnh. Điều này có thể thực hiện được vì chúng tôi có khả năng thực hiện các cập nhật cục bộ cho biểu diễn dựa trên lưới của chúng tôi, và chúng tôi không gặp phải các vấn đề quên như [46]. Chiến lược lựa chọn khung hình chính này không chỉ đảm bảo hình học bên ngoài góc nhìn hiện tại vẫn tĩnh, mà còn dẫn đến một bài toán tối ưu hóa rất hiệu quả vì chúng tôi chỉ tối ưu hóa các tham số cần thiết mỗi lần. Trong thực tế, chúng tôi trước tiên lấy mẫu ngẫu nhiên các điểm ảnh và chiếu ngược các độ sâu tương ứng bằng cách sử dụng vị trí máy ảnh đã tối ưu hóa. Sau đó, chúng tôi chiếu đám mây điểm đến mọi khung hình chính trong danh sách khung hình chính toàn cục. Từ những khung hình chính có điểm được chiếu lên, chúng tôi chọn ngẫu nhiên K - 2 khung hình. Ngoài ra, chúng tôi cũng bao gồm khung hình chính gần đây nhất và khung hình hiện tại trong quá trình tối ưu hóa biểu diễn cảnh, tạo thành tổng số K khung hình hoạt động. Vui lòng tham khảo Mục 4.4 để biết nghiên cứu loại bỏ về chiến lược lựa chọn khung hình chính.
