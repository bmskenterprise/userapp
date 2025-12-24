import 'package:flutter/material.dart';

class Pages extends StatefulWidget {
  final int totalPage,currentPage;
  final Function onPageChange;
   Pages({super.key,required this.totalPage,required this.currentPage,required this.onPageChange});
  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  @override
  Widget build(BuildContext context) {
    return  Row(
      children:[
        widget.currentPage>1?IconButton(onPressed:(){widget.onPageChange(widget.currentPage-1);},icon:Icon(Icons.arrow_back_ios)):SizedBox(width:40,height:40),
        widget.currentPage==widget.totalPage?IconButton(onPressed:(){widget.onPageChange(widget.currentPage+1);},icon:Icon(Icons.arrow_forward_ios)):SizedBox(width:40,height:40)
      ]
    );
  }
}