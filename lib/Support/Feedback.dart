import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../providers/AppProvider.dart';
import '../providers/ApiProvider.dart';
//import '../widgets/Toast.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
//late Box box;
  final _formKey = GlobalKey<FormState>();
  //late Future<List> _feedbacksFuture;
  //bool _initForm = false;
  final TextEditingController _controllerDescription = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){context.read<ApiProvider>().getFeedbacks();});//box=Hive.box('permission');
  }
  @override
  void dispose() {
    _controllerDescription.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final app = context.read<AppProvider>();
    final api = context.watch<ApiProvider>();       
    final auth = context.read<AuthProvider>();     
    return  Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          if (context.watch<AppProvider>().initFeedbackForm) ...[
            Form(
              key: _formKey,
              child: Column(
                children:[
                  /*TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Subject',
                    ),
                    validator: (v){
                      if(v==null || v.isEmpty) {return 'একটি টপিক লিখুন'}
                        //return 'একটি টপিক লিখুন ';
                      
                      if (v.length<4 || v.length>20) {
                        return 'অবশ্যই ৪ অক্ষরের বড় এবং ২০ অক্ষরের ছোট হতে হবে';
                      }
                      return null;
                    }),*/
                  TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your message...',
                    ),
                    validator: (v){
                      if(v==null || v.isEmpty) return 'একটি ম্যাসেজ লিখুন';
                      if (v.length<10 || v.length>100) {return 'অবশ্যই ১০ অক্ষরের বড় এবং ১০০ অক্ষরের ছোট হতে হবে';}
                      return null;
                    },
                  ),
                  FilledButton(
                    child: Text('SUBMIT'),
                    onPressed: () async{
                      if(_formKey.currentState!.validate()) {
                        /*final res = await */context.read<ApiProvider>().addFeedback(/*subjectController.text,*/_controllerDescription.text);
                        //if (!res['success']) {Toast(Map<String, dynamic>.from(res));return;}
                        app.setFeedbackFormState(false);
                      }
                    }
                  )
                ]
              )
            )
          ]
          else ...[
          /*!(auth.authPrefs['accesses']??[]).contains('feedback')?Text('এই মুহূর্তে ফিডব্যাক দেয়ার অনুমতি নেই') :*/FilledButton(
            onPressed: (){app.setFeedbackFormState(true);},
            child: Text('New Feedback')
          ),
          /*FutureBuilder<List>(
            future: _feedbacksFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No products found'));
              } else {
                return */SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ListView.builder(
                  itemCount: /*context.watch<FeedbackProvider>().items*/api.feedbacks.length,
                  itemBuilder: (context, index){
                    final feedback = /*snapshot.data!*/api.feedbacks[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:[Text(feedback.subject),Text(feedback.date)]
                          ),
                          Text(feedback.message)
                        ],
                      ),
                    );
                  },
                                ),
                )
              /*}
              }
          )*/
          ]
        ],
      ),
    );
  }
}
                        //return 'একটি মেসেজ লিখুন ';
                      //}
                        //return 'অবশ্যই ১০ অক্ষরের বড় এবং ১০০ অক্ষরের ছোট হতে হবে';
                      //}
                          //Toast(Map<String, dynamic>.from(res));return;
                        //}