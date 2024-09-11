class SubCategories{
        final int cid ;
        final String sCateName ;
        final String sCateIcon ;
        final String sDesc ;
        final int cateId ;
        final String routerLink ;
        final String btnStyle ;

    SubCategories({
      required this.cid,
      required this.sCateName,
      required this.sCateIcon,
      required this.sDesc,
      required this.cateId,
      required this.routerLink,
      required this.btnStyle,
    });
 factory SubCategories.fromJson(Map<dynamic, dynamic> json){
  return SubCategories(
cid: json['cid'],
sCateName: json['sCateName'],
sCateIcon: json['sCateIcon'],
sDesc: json['sDesc'],
cateId: json['cateId'],
routerLink: json['routerLink'],
btnStyle: json['btnStyl'],
  );
 }

}


       