// Code generated by jsonToDartModel http://json.fluttergeeks.in/
class ChatUser {
  String? image;
  String? name;
  String? lastActive;
  bool? isOnline;
  String? id;
  String? createAt;
  String? pushToken;
  String? email;
  String? biodata;

  ChatUser({
    this.image,
    this.name,
    this.lastActive,
    this.isOnline,
    this.id,
    this.createAt,
    this.pushToken,
    this.email,
    this.biodata
  });

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ??
        "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.flipkart.com%2Fsalman-khan-poster-multicolor-photo-paper-print-photographic-18-inch-x-12-inch-rolled%2Fp%2Fitmddf8ffcf3a286&psig=AOvVaw1_sfXI0urPj-HEPKXN7ANV&ust=1738585067122000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCKD73pz8pIsDFQAAAAAdAAAAABAE ";
    name = json['name'] ?? "";
    lastActive = json['last_active'] ?? "";
    isOnline = json['is_online'] ?? "";
    id = json['id'] ?? "";
    createAt = json['create_at'] ?? "";
    pushToken = json['pushToken'] ?? "";
    email = json['email'] ?? "";
    biodata = json['biodata'] ?? "";
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['last_active'] = lastActive;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['create_at'] = createAt;
    data['pushToken'] = pushToken;
    data['email'] = email;
    data['biodata'] = biodata;
    return data;
  }
}
