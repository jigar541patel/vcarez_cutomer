class BannerListModel {
  bool? success;
  String? message;
  Data? data;

  BannerListModel({this.success, this.message, this.data});

  BannerListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<TopBanners>? topBanners;
  List<MiddleBanners>? middleBanners;
  List<BottomBanners>? bottomBanners;

  Data({this.topBanners, this.middleBanners, this.bottomBanners});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['top_banners'] != null) {
      topBanners = <TopBanners>[];
      json['top_banners'].forEach((v) {
        topBanners!.add(new TopBanners.fromJson(v));
      });
    }
    if (json['middle_banners'] != null) {
      middleBanners = <MiddleBanners>[];
      json['middle_banners'].forEach((v) {
        middleBanners!.add(new MiddleBanners.fromJson(v));
      });
    }
    if (json['bottom_banners'] != null) {
      bottomBanners = <BottomBanners>[];
      json['bottom_banners'].forEach((v) {
        bottomBanners!.add(new BottomBanners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.topBanners != null) {
      data['top_banners'] = this.topBanners!.map((v) => v.toJson()).toList();
    }
    if (this.middleBanners != null) {
      data['middle_banners'] =
          this.middleBanners!.map((v) => v.toJson()).toList();
    }
    if (this.bottomBanners != null) {
      data['bottom_banners'] =
          this.bottomBanners!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TopBanners {
  int? id;
  String? title;
  String? descr;
  String? image;
  String? position;
  String? type;
  int? medicineId;

  TopBanners(
      {this.id,
      this.title,
      this.descr,
      this.image,
      this.position,
      this.type,
      this.medicineId});

  TopBanners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    descr = json['descr'];
    image = json['image'];
    position = json['position'];
    type = json['type'];
    medicineId = json['medicine_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['descr'] = this.descr;
    data['image'] = this.image;
    data['position'] = this.position;
    data['type'] = this.type;
    data['medicine_id'] = this.medicineId;
    return data;
  }
}

class MiddleBanners {
  int? id;
  String? title;
  String? descr;
  String? image;
  String? position;
  String? type;
  int? medicineId;

  MiddleBanners(
      {this.id,
      this.title,
      this.descr,
      this.image,
      this.position,
      this.type,
      this.medicineId});

  MiddleBanners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    descr = json['descr'];
    image = json['image'];
    position = json['position'];
    type = json['type'];
    medicineId = json['medicine_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['descr'] = this.descr;
    data['image'] = this.image;
    data['position'] = this.position;
    data['type'] = this.type;
    data['medicine_id'] = this.medicineId;
    return data;
  }
}

class BottomBanners {
  int? id;
  String? title;
  String? descr;
  String? image;
  String? position;
  String? type;
  int? medicineId;

  BottomBanners(
      {this.id,
      this.title,
      this.descr,
      this.image,
      this.position,
      this.type,
      this.medicineId});

  BottomBanners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    descr = json['descr'];
    image = json['image'];
    position = json['position'];
    type = json['type'];
    medicineId = json['medicine_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['descr'] = this.descr;
    data['image'] = this.image;
    data['position'] = this.position;
    data['type'] = this.type;
    data['medicine_id'] = this.medicineId;
    return data;
  }
}
