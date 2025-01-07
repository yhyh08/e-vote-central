class OrganizationData {
  final String name;
  final String description;
  final String category;
  final String address;
  final String website;
  final String email;
  final String size;
  final String imageUrl;
  final String picName;
  final String picPhone;
  final String picEmail;
  final bool isActive;

  OrganizationData({
    required this.name,
    required this.description,
    required this.category,
    required this.address,
    required this.website,
    required this.email,
    required this.size,
    required this.imageUrl,
    required this.picName,
    required this.picPhone,
    required this.picEmail,
    required this.isActive,
  });

  // Define the fromJson method
  factory OrganizationData.fromJson(Map<String, dynamic> json) {
    return OrganizationData(
      name: json['org_name'] ?? '',
      description: json['org_desc'] ?? '',
      category: json['org_cat'] ?? '',
      address: json['org_address'] ?? '',
      website: json['org_website'] ?? '',
      email: json['org_email'] ?? '',
      size: json['org_size']?.toString() ?? '',
      imageUrl: json['org_img'] ?? '',
      picName: json['pic_name'] ?? '',
      picPhone: json['pic_phone'] ?? '',
      picEmail: json['pic_email'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }
}
