class PrivilegePlanModel {
  bool? success;
  String? message;
  String? validity;
  ActivePlan? activePlan;
  List<Plans>? plans;

  PrivilegePlanModel(
      {this.success, this.message, this.validity, this.activePlan, this.plans});

  PrivilegePlanModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    validity = json['validity'];
    activePlan = json['active_plan'] != null
        ? new ActivePlan.fromJson(json['active_plan'])
        : null;
    if (json['plans'] != null) {
      plans = <Plans>[];
      json['plans'].forEach((v) {
        plans!.add(new Plans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['validity'] = this.validity;
    if (this.activePlan != null) {
      data['active_plan'] = this.activePlan!.toJson();
    }
    if (this.plans != null) {
      data['plans'] = this.plans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActivePlan {
  int? id;
  String? title;
  var price;
  var duration;
  String? type;
  String? createdAt;

  ActivePlan(
      {this.id,
        this.title,
        this.price,
        this.duration,
        this.type,
        this.createdAt});

  ActivePlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    duration = json['duration'];
    type = json['type'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['duration'] = this.duration;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Plans {
  int? id;
  String? title;
  var price;
  var duration;
  String? type;

  Plans({this.id, this.title, this.price, this.duration, this.type});

  Plans.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    duration = json['duration'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['duration'] = this.duration;
    data['type'] = this.type;
    return data;
  }
}

