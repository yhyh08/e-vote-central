class OrganizationData {
  final String name;
  final String description;
  final String category;
  final OrgAddress address;
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
    // Create a default address when org_address is a string
    OrgAddress createAddress(dynamic addressData) {
      if (addressData is String) {
        return OrgAddress(
          line1: addressData, // Put the string in line1
          line2: '',
          city: '',
          state: '',
          country: '',
          postcode: '',
        );
      } else if (addressData is Map<String, dynamic>) {
        return OrgAddress(
          line1: addressData['line1'] ?? '',
          line2: addressData['line2'] ?? '',
          city: addressData['city'] ?? '',
          state: addressData['state'] ?? '',
          country: addressData['country'] ?? '',
          postcode: addressData['postcode'] ?? '',
        );
      } else {
        return OrgAddress(
          line1: '',
          line2: '',
          city: '',
          state: '',
          country: '',
          postcode: '',
        );
      }
    }

    return OrganizationData(
      name: json['org_name'] ?? '',
      description: json['org_desc'] ?? '',
      category: json['org_cat'] ?? '',
      address: createAddress(json['org_address']),
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

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'org_name': name,
      'org_desc': description,
      'org_address': address.toJson(),
      'org_website': website,
      'org_email': email,
      'pic_name': picName,
      'pic_phone': picPhone,
      'pic_email': picEmail,
      'org_cat': category,
      'org_size': size,
      'org_img': imageUrl,
      'is_active': isActive,
    };
  }
}

class OrgAddress {
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String country;
  final String postcode;

  OrgAddress({
    required this.line1,
    required this.line2,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
  });

  Map<String, dynamic> toJson() => {
        'line1': line1,
        'line2': line2,
        'city': city,
        'state': state,
        'country': country,
        'postcode': postcode,
      };
}
