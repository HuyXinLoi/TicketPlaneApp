class PopularDestination {
  final String name;
  final String image; // Bạn có thể thay đổi kiểu dữ liệu nếu cần

  PopularDestination({
    required this.name,
    required this.image,
  });

  factory PopularDestination.fromJson(Map<String, dynamic> json) {
    return PopularDestination(
      name: json['name'],
      image: json['image'], //
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image, //
    };
  }
}
