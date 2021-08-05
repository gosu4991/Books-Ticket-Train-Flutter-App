class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent(
      {required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Thông tin ga tàu',
      image: 'assets/vetau.jpg',
      discription:
          "Xem thông tin về ga tàu nhanh chóng như: Mác tàu, ga đi - đến, khoảng cách, thời gian khởi hành"),
  UnbordingContent(
      title: 'Thông tin ghế',
      image: 'assets/vetau.jpg',
      discription:
          "Dễ dàng tra cứu giá cả các loại ghế như: ghế cứng, ghế mềm,.... "),
  UnbordingContent(
      title: 'Đặt vé',
      image: 'assets/vetau.jpg',
      discription:
          "Đặt vé nhanh chóng, trực tuyến, dễ dàng tra cứu thông tin giá vé sau khi đặt vé "),
];
