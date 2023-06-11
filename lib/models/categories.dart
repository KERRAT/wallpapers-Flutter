class Category {
  final String id;
  final String name;
  final String hint;
  final String image;

  Category({required this.id, required this.name, required this.hint, required this.image});

  factory Category.fromJson(Map<String, dynamic> json, int index) {
    return Category(
      id: json['category_ids'][index],
      name: json['category_names'][index],
      hint: json['category_hints'][index],
      image: 'assets/categories/imgs/${json['category_images'][index]}.jpg',
    );
  }
}