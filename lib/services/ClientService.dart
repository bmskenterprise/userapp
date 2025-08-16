class ClientService {
  Future<List> fetchNotices() async {
    try{
      final response = await http.get(Uri.parse());
      if(response.statusCode==200){
        return jsonDecode(response.body);
      }
      throw Exception('Failed to load notices. status code ${response.statusCode}');
    }catch(e){
      throw Exception(e.toString());
    }
  }
}