class Categories{
  final int cid ;
  final String categoryName ;
  final String cateIcon ;
  final String subString ;
  final String routerLink ;
  final String btnStyle ;

    Categories({
      required this.cid,
      required this.categoryName,
      required this.cateIcon,
      required this.subString,
      required this.routerLink,
      required this.btnStyle,
    });
 factory Categories.fromJson(Map<dynamic, dynamic> json){
  return Categories(
cid: json['cid'],
categoryName: json['categoryName'],
cateIcon: json['cateIcon'],
subString: json['subString'],
routerLink: json['routerLink'],
btnStyle: json['btnStyl'],
  );
 }

}