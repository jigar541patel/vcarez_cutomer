class MedicineDetailModel {
  bool? success;
  String? message;
  Medicine? medicine;
  List<Suggestions>? suggestions;

  MedicineDetailModel(
      {this.success, this.message, this.medicine, this.suggestions});

  MedicineDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    medicine = json['medicine'] != null
        ? new Medicine.fromJson(json['medicine'])
        : null;
    if (json['suggestions'] != null) {
      suggestions = <Suggestions>[];
      json['suggestions'].forEach((v) {
        suggestions!.add(new Suggestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.medicine != null) {
      data['medicine'] = this.medicine!.toJson();
    }
    if (this.suggestions != null) {
      data['suggestions'] = this.suggestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Medicine {
  int? id;
  String? name;
  String? manufacturer;
  String? saltComposition;
  String? medicineType;
  var stock;
  String? introduction;
  String? benefits;
  String? description;
  String? howToUse;
  List<SafetyAdvise>? safetyAdvise;
  String? ifMiss;
  String? packaging;
  var packInfo;
  var mrp;
  String? type;
  String? prescriptionRequired;
  var label;
  String? factBox;
  String? primaryUse;
  String? storage;
  String? useOf;
  String? commonSideEffect;
  String? alcoholInteraction;
  String? pregnancyInteraction;
  String? lactationInteraction;
  String? drivingInteraction;
  String? kidneyInteraction;
  String? liverInteraction;
  var otherDrugsInteraction;
  String? manufacturerAddress;
  String? countryOfOrigin;
  List<Faqs>? faqs;
  List<String>? imageUrl;
  String? createdAt;
  String? updatedAt;
  var ingredients;
  List<Varients>? varients;
  int? quantity;

  Medicine(
      {this.id,
        this.name,
        this.manufacturer,
        this.saltComposition,
        this.medicineType,
        this.stock,
        this.introduction,
        this.benefits,
        this.description,
        this.howToUse,
        this.safetyAdvise,
        this.ifMiss,
        this.packaging,
        this.packInfo,
        this.mrp,
        this.type,
        this.prescriptionRequired,
        this.label,
        this.factBox,
        this.primaryUse,
        this.storage,
        this.useOf,
        this.commonSideEffect,
        this.alcoholInteraction,
        this.pregnancyInteraction,
        this.lactationInteraction,
        this.drivingInteraction,
        this.kidneyInteraction,
        this.liverInteraction,
        this.otherDrugsInteraction,
        this.manufacturerAddress,
        this.countryOfOrigin,
        this.faqs,
        this.imageUrl,
        this.createdAt,
        this.updatedAt,
        this.ingredients,
        this.varients,
        this.quantity});

  Medicine.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    manufacturer = json['manufacturer'];
    saltComposition = json['salt_composition'];
    medicineType = json['medicine_type'];
    stock = json['stock'];
    introduction = json['introduction'];
    benefits = json['benefits'];
    description = json['description'];
    howToUse = json['how_to_use'];
    if (json['safety_advise'] != null) {
      safetyAdvise = <SafetyAdvise>[];
      json['safety_advise'].forEach((v) {
        safetyAdvise!.add(new SafetyAdvise.fromJson(v));
      });
    }
    ifMiss = json['if_miss'];
    packaging = json['packaging'];
    packInfo = json['pack_info'];
    mrp = json['mrp'];
    type = json['type'];
    prescriptionRequired = json['prescription_required'];
    label = json['label'];
    factBox = json['fact_box'];
    primaryUse = json['primary_use'];
    storage = json['storage'];
    useOf = json['use_of'];
    commonSideEffect = json['common_side_effect'];
    alcoholInteraction = json['alcohol_interaction'];
    pregnancyInteraction = json['pregnancy_interaction'];
    lactationInteraction = json['lactation_interaction'];
    drivingInteraction = json['driving_interaction'];
    kidneyInteraction = json['kidney_interaction'];
    liverInteraction = json['liver_interaction'];
    otherDrugsInteraction = json['other_drugs_interaction'];
    manufacturerAddress = json['manufacturer_address'];
    countryOfOrigin = json['country_of_origin'];
    if (json['faqs'] != null) {
      faqs = <Faqs>[];
      json['faqs'].forEach((v) {
        faqs!.add(new Faqs.fromJson(v));
      });
    }
    imageUrl = json['image_url'].cast<String>();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    ingredients = json['ingredients'];
    if (json['varients'] != null) {
      varients = <Varients>[];
      json['varients'].forEach((v) {
        varients!.add(new Varients.fromJson(v));
      });
    }
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['manufacturer'] = this.manufacturer;
    data['salt_composition'] = this.saltComposition;
    data['medicine_type'] = this.medicineType;
    data['stock'] = this.stock;
    data['introduction'] = this.introduction;
    data['benefits'] = this.benefits;
    data['description'] = this.description;
    data['how_to_use'] = this.howToUse;
    if (this.safetyAdvise != null) {
      data['safety_advise'] =
          this.safetyAdvise!.map((v) => v.toJson()).toList();
    }
    data['if_miss'] = this.ifMiss;
    data['packaging'] = this.packaging;
    data['pack_info'] = this.packInfo;
    data['mrp'] = this.mrp;
    data['type'] = this.type;
    data['prescription_required'] = this.prescriptionRequired;
    data['label'] = this.label;
    data['fact_box'] = this.factBox;
    data['primary_use'] = this.primaryUse;
    data['storage'] = this.storage;
    data['use_of'] = this.useOf;
    data['common_side_effect'] = this.commonSideEffect;
    data['alcohol_interaction'] = this.alcoholInteraction;
    data['pregnancy_interaction'] = this.pregnancyInteraction;
    data['lactation_interaction'] = this.lactationInteraction;
    data['driving_interaction'] = this.drivingInteraction;
    data['kidney_interaction'] = this.kidneyInteraction;
    data['liver_interaction'] = this.liverInteraction;
    data['other_drugs_interaction'] = this.otherDrugsInteraction;
    data['manufacturer_address'] = this.manufacturerAddress;
    data['country_of_origin'] = this.countryOfOrigin;
    if (this.faqs != null) {
      data['faqs'] = this.faqs!.map((v) => v.toJson()).toList();
    }
    data['image_url'] = this.imageUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['ingredients'] = this.ingredients;
    if (this.varients != null) {
      data['varients'] = this.varients!.map((v) => v.toJson()).toList();
    }
    data['quantity'] = this.quantity;
    return data;
  }
}

class SafetyAdvise {
  String? title;
  String? instruction;
  String? message;

  SafetyAdvise({this.title, this.instruction, this.message});

  SafetyAdvise.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    instruction = json['instruction'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['instruction'] = this.instruction;
    data['message'] = this.message;
    return data;
  }
}

class Faqs {
  String? ques;
  String? ans;

  Faqs({this.ques, this.ans});

  Faqs.fromJson(Map<String, dynamic> json) {
    ques = json['ques'];
    ans = json['ans'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ques'] = this.ques;
    data['ans'] = this.ans;
    return data;
  }
}

class Varients {
  int? id;
  var mrp;
  String? type;
  String? packaging;
  var packInfo;
  int? quantity;

  Varients(
      {this.id,
        this.mrp,
        this.type,
        this.packaging,
        this.packInfo,
        this.quantity});

  Varients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mrp = json['mrp'];
    type = json['type'];
    packaging = json['packaging'];
    packInfo = json['pack_info'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mrp'] = this.mrp;
    data['type'] = this.type;
    data['packaging'] = this.packaging;
    data['pack_info'] = this.packInfo;
    data['quantity'] = this.quantity;
    return data;
  }
}

class Suggestions {
  int? id;
  String? name;
  String? type;
  var mrp;
  String? manufacturer;
  String? imageUrl;

  Suggestions(
      {this.id,
        this.name,
        this.type,
        this.mrp,
        this.manufacturer,
        this.imageUrl});

  Suggestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    mrp = json['mrp'];
    manufacturer = json['manufacturer'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['mrp'] = this.mrp;
    data['manufacturer'] = this.manufacturer;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
