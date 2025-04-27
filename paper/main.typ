#import "iclr2025.typ": iclr2025
#set math.equation(numbering: "(1)")

#show table.cell.where(y: 0): strong
#set table(
  stroke: (x, y) => if y == 0 {
    (bottom: 0.7pt + black)
  },
  align: (x, y) => (
    if x > 0 { center }
    else { left }
  )
)

#let author-note = footnote[
  Use footnote for providing further information about author (webpage,
  Alternative address) --- *not* for acknowledging funding agencies.  Funding
  Acknowledgements go at the end of the paper.
]

/*
 * Authors should be specified as a list of entries. Each entry enumerates
 * authors with the same affilation and address. Field `names` is mandatory.
 */
#let authors = (
  (
    names: ([Nguyễn Bá Công], ),
    affilation: [ Mã Số Sinh Viên: 22127046 ],
    email: "nbcong22@clc.fitus.edu.vn",
  ),
  (
    names: ([Nguyễn Huỳnh Hải Đăng], ),
    affilation: [ Mã Số Sinh Viên: 22127052 ],
    email: "nhhdang22@clc.fitus.edu.vn",
  ),
  (
    names: ([Đặng Trần Anh Khoa], ),
    affilation: [ Mã Số Sinh Viên: 22127024 ],
    email: "dtakhoa22@clc.fitus.edu.vn",
  ),
)

#show: iclr2025.with(
  title: [Visual SLAM - an System for RGB-D Cameras],
  authors: authors,
  keywords: (),
  abstract: [
    NICE-SLAM (Neural Implicit Scalable Encoding for SLAM) giới thiệu một phương pháp mới cho việc xây dựng bản đồ 3D đồng thời và định vị (SLAM) thời gian thực bằng cách sử dụng đại diện ẩn thần kinh. Khác với các phương pháp SLAM truyền thống dựa vào việc so khớp đặc trưng điểm rời rạc, NICE-SLAM sử dụng mã hóa cảnh dựa trên lưới phân cấp, cho phép tối ưu hóa cục bộ các đặc trưng cảnh. Phương pháp dựa trên học sâu này mang lại nhiều lợi thế, bao gồm khả năng mở rộng cao, hiệu suất thời gian thực và tính bền vững với nhiễu và môi trường động. Bằng cách kết hợp bộ giải mã ẩn liên tục được huấn luyện trước và lưới đặc trưng đa cấp, NICE-SLAM nâng cao cả độ chính xác của bản đồ và độ chính xác trong việc theo dõi, ngay cả trong các cảnh lớn và phức tạp. Việc sử dụng bộ kết xuất khả di giúp tối ưu hóa chi tiết hình học cảnh và vị trí camera bằng cách tối thiểu hóa mất mát khi tái tạo độ sâu và màu sắc, từ đó duy trì độ trung thực cao trong các bản đồ 3D. Kết quả thử nghiệm cho thấy NICE-SLAM vượt trội hơn các hệ thống SLAM truyền thống, đạt kết quả tốt hơn trong môi trường trong nhà quy mô lớn và duy trì tính bền vững trong môi trường có đối tượng động. Điều này làm cho NICE-SLAM trở thành một giải pháp hứa hẹn cho các ứng dụng điều hướng tự động, khám phá robot và thực tế tăng cường, nơi mà việc xây dựng bản đồ thời gian thực, quy mô lớn là rất quan trọng.
  ],
  bibliography: bibliography("biblio.bib"),
  appendix: [
    #include "appendix.typ"
  ],
  accepted: true,
)

#show outline.entry.where(
  level: 1
): it => {
  v(12pt, weak: true)
  strong(it)
}
#outline(
    title: "Mục lục",
    indent: auto,
)

#let url(uri) = link(uri, raw(uri)) 

#set pagebreak()

= Giới thiệu

Trong một không gian chưa biết trước, việc để một robot di chuyển tự do xung quanh cần xây dựng một bản đề khu vực đấy đồng thời xác định vị trí chính nó trong bản đồ đấy. Để giải quyết quá trình này, một phương pháp tên là Simultaneous Localization And Mapping - SLAM (Định vị và Lập bản đồ Đồng thời). 

SLAM là một bài toán được sự quan tâm to lớn của cộng đồng thị giác máy tính, hơn nữa nó còn đang được ứng dụng mở rộng trong các lĩnh vực khác như công nghệ theo dõi cử động tay và nhận diện cử chỉ tay, công nghệ tích hợp LiDAR. 

Về lý thuyết, bài toán SLAM đã có phương án giải quyết. Tuy nhiên, thực tế cho thấy còn nhiều vấn đề phát sinh. Các khó khăn đến từ việc xử lý thông tin thời gian thực mà một hệ thống điều hướng cần đáp ứng. Với môi trường ngoài trời, bài toán sẽ được hệ thống GPS giải quyết và cung cấp vị trí chính xác để robot làm việc. Ngược lại, nếu ở trong nhà nơi GPS không có sẵn và có vẻ phức tạp kèm độ tin cậy kém, việc nhận định vị trí chính xác trở nên khó khăn hơn và cần giải pháp thay thế.

#figure(
  caption: [
    Quá trình xác định vị trí camera qua SLAM.
  ],
  image("data/Project Demomstrate Graph.png"),
)

\
Các thiết bị cảm biến thường được dùng trong hệ thống SLAM là:

- *Máy quét La-de*: Thiết bị cho độ chính xác cao trong việc thu thập thông tin độ sâu. Nhưng giá thành cao và nặng nên không thuận tiện trong việc di chuyển thiết bị.

- *Camera độ sâu*: Camera với cảm biến hỗ trợ tốt cho nghiên cứu áp dụng SLAM, rẻ hơn máy La-de. Camera đem lại nhiều thông tin hình ảnh hơn và không phải tính toán lại thông tin độ sâu như camera thông thường. Điểm mạnh lớn nhất là Camera độ sâu đem lại ứng dụng thực tiễn cao.

== Động lực nghiên cứu

Các hệ thống SLAM truyền thống chủ yếu dựa vào việc *trích xuất đặc trưng hình ảnh* và *khớp điểm* để ước tính vị trí của camera, sử dụng các thuật toán như *RANSAC* để xử lý các sai số trong quá trình so khớp. Mặc dù hiệu quả trong các môi trường nhỏ và có độ phức tạp thấp, các phương pháp này có một số hạn chế lớn khi phải xử lý các cảnh phức tạp và quy mô lớn. Việc khớp các đặc trưng rời rạc trong các môi trường có nhiều đối tượng động hay nhiễu có thể dẫn đến sai số lớn trong bản đồ và gây khó khăn trong việc duy trì độ chính xác của vị trí camera theo thời gian. Hơn nữa, việc sử dụng các mô hình đại diện cảnh vật rời rạc không đủ linh hoạt để xử lý các thay đổi trong cảnh vật và khó mở rộng cho các môi trường lớn.

Chính những hạn chế này của SLAM truyền thống đã thúc đẩy sự ra đời của *NICE-SLAM* (Neural Implicit Scalable Encoding for SLAM). NICE-SLAM sử dụng *đại diện ẩn thần kinh* để mô hình hóa hình học và màu sắc của cảnh vật, thay vì sử dụng các đặc trưng hình học rời rạc như trong các phương pháp truyền thống. Phương pháp này sử dụng *lưới phân cấp* để mã hóa thông tin cảnh vật, giúp hệ thống có thể tối ưu hóa cục bộ và thích ứng linh hoạt với các cảnh phức tạp mà không gặp phải vấn đề về mở rộng quy mô hoặc thiếu chính xác. NICE-SLAM giải quyết được các vấn đề mà SLAM truyền thống gặp phải, đặc biệt là trong việc *xử lý môi trường động*, *tái tạo các cảnh lớn*, và duy trì hiệu suất theo *thời gian thực*.

Với việc thay thế các phương pháp cũ bằng các đại diện cảnh liên tục và khả năng tối ưu hóa thông qua các bộ giải mã ẩn thần kinh, NICE-SLAM không chỉ cải thiện độ chính xác mà còn làm tăng khả năng *mở rộng* và *xử lý môi trường động*. Điều này giúp hệ thống hoạt động tốt hơn trong các tình huống thực tế phức tạp, nơi SLAM truyền thống không còn hiệu quả, mở ra khả năng ứng dụng mạnh mẽ hơn trong các lĩnh vực như robot tự hành, xe tự lái và thực tế ảo, nơi các môi trường thường xuyên thay đổi và yêu cầu khả năng tái tạo cảnh vật chính xác trong thời gian thực.

== Dàn ý
Phần còn lại của bài báo được cấu trúc như sau: 
- *Phần 2* trình bày các công trình nghiên cứu liên quan. 
- *Phần 3* trình bày cụ thể về phương pháp, với từng công đoạn cụ thể.
- *Phần 4* trình bày thực nghiệm của mô hình trên một số tập dữ liệu khác nhau, bao gồm mô tả bộ dữ liệu và phần mềm, cũng như đánh giá kết quả thực nghiệm trên từng bộ dữ liệu.

== Phương pháp truyền thống
Một hệ thống ứng dụng phương pháp truyền thống đã được phát triển. Quy trình cơ bản của hệ thống này bao gồm các bước sau:
- Lấy 1 dãy ảnh trong dữ liệu RGB-D từ máy Kinect;
- Thực hiện trích xuất và so khớp đặc trưng bằng SIFT/SURF;
- Tính toán các phép biến đổi tương đối bằng RANSAC;
- Tính các góc nhìn ban đầu và biến đổi chúng thành các đỉnh và cạnh $g^2 o$;
- Phát hiện các điểm kết thúc vòng lặp (loop closures) và thêm các cạnh tương ứng vào đồ thị;
- Tối ưu hoá đồ thị bằng $g^2 o$ và trích xuất những góc quay mới;
- Tái tạo toàn cảnh dữ liệu bằng cách sinh ra 1 file chứa các đám mây điểm.

Tuy nhiên, đây là một phương pháp cũ, đòi hỏi rất nhiều tài nguyên, vậy nên không thực tế. 

#include "part/part2.typ"

#include "part/part3.typ"

#include "part/part4.typ"

