class MessageModel {
  String? messageid;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdon;
  String? islocation;
  String? url;

  MessageModel({this.messageid, this.sender, this.text, this.seen, this.createdon, this.url,this.islocation});

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageid = map["messageid"];
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["createdon"].toDate();
    islocation = map["islocation"];
    url = map["url"];
  }

  Map<String, dynamic> toMap() {
    return {
      "messageid": messageid,
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdon": createdon,
      "islocation":islocation,
      "url":url
    };
  }
}