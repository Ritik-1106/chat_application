/// Code generated by jsonToDartModel http://json.fluttergeeks.in/
class Message {
/*
{
  "msg": "hii",
  "read": "232323",
  "told": "test2",
  "type": "12345",
  "sent": "123456",
  "fromid": "test1"
} 
*/

  String? msg;
  String? read;
  String? told;
  String? type;
  String? sent;
  String? fromid;

  Message({
    this.msg,
    this.read,
    this.told,
    this.type,
    this.sent,
    this.fromid,
  });
  Message.fromJson(Map<String, dynamic> json) {
    msg = json['msg']?.toString();
    read = json['read']?.toString();
    told = json['told']?.toString();
    type = json['type']?.toString();
    sent = json['sent']?.toString();
    fromid = json['fromid']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['read'] = read;
    data['told'] = told;
    data['type'] = type;
    data['sent'] = sent;
    data['fromid'] = fromid;
    return data;
  }
}
