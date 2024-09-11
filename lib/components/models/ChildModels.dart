class ChildModels{
        final int cid;
        final int cateId;
        final int sCateId;
        final String postName;
        final String subString;
        final String btnStyle;
        final String routerLink;
        final String contactNo;
        final String pAddress;
        final int gender;
        final String contactName;
        final String postIcon;

    ChildModels({
required this.cid,
required this.cateId,
required this.sCateId,
required this.postName,
required this.subString,
required this.btnStyle,
required this.routerLink,
required this.contactNo,
required this.pAddress,
required this.gender,
required this.contactName,
required this.postIcon
    });
 factory ChildModels.fromJson(Map<dynamic, dynamic> json){
  return ChildModels(
cid: json['cid'],
cateId: json['cateId'],
sCateId: json['sCateId'],
postName: json['postName'],
subString: json['subString'],
btnStyle: json['btnStyle'],
routerLink: json['routerLink'],
contactNo: json['contactNo'],
pAddress: json['pAddress'],
gender: json['gender'],
contactName: json['contactName'],
postIcon: json['postIcon']
  );
 }

}


        



