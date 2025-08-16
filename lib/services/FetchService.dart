import 'dart:convert';
import 'package:http/http.dart' as http;


class DrivepackService{
  static Future<List<Drivepack>> getDrivepacks() async {
    try {
        //if(){
        final response = await http.get(
          Uri.parse('https://bmsk-api.com/api/drivepacks?operator=$_selectedOperator'),
        );

        if (response.statusCode == 200) {
          List<dynamic> data = jsonDecode(response.body);
          allPacks = data.map((json) => Drive.fromJson(json)).toList();
        }
        /*}else{
        final box = Hive.box('drivepacks');
        final drivepacks = box.get('drivepacks');
        return drivepacks.map((json) => Drive.fromJson(json)).toList();
      }*/
        for (Map operator in _operators) {
          _all[operator['name']] =
              allPacks
                  .where((pack) => pack.operator == operator['name'])
                  .toList(); //operator['drivepacks'].map((json) => Drive.fromJson(json)).toList();//llTodos.where((todo) => todo.completed).toList();
          //_all['incompleteTodos'] = allTodos.where((todo) => !todo.completed).toList();
        }
      } catch (err) {
        Toast('message':err.toString(),'success':false);
      }
  }
}