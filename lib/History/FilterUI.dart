import 'package:flutter/material.dart';

class FilterUI extends StatelessWidget {
  final String selected;
  final List<String> states;
  final Function filterHandler,statusHandler;
  
  const FilterUI({super.key,required this.selected,required this.states,required this.filterHandler,required this.statusHandler});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        child: Row(
          children: [
              TextFormField(
                onChanged: (v){filterHandler(context,v);},
              ),
              DropdownButton<String>(
                value: selected,
                items: states.map<DropdownMenuItem<String>>((String item)=>DropdownMenuItem<String>(value:item, child:Text(item))).toList(),
                onChanged: (String? v){statusHandler(context,v);}
              )
          ],
        )
      )
    );
  }
}