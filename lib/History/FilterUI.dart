import 'package:flutter/material.dart';

Widget FilterUI(List<String> states,String selected,Function handleState,Function filter) {
  //List<String> states = ['pending','success','failed'];
  return Container(
    padding: EdgeInsets.all(10),
    child: Form(
      child: Row(
        children: [
            TextFormField(
              onChanged: (v){filter(v);},
            ),
            DropdownButton<String>(
              value: selected,
              items: states.map<DropdownMenuItem<String>>((String item)=>DropdownMenuItem<String>(value:item, child:Text(item))).toList(),
              onChanged: (String? v){handleState(v);}
            )
        ],
      )
    )
  );
}