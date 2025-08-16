import 'package:bmsk_userapp/Toast.dart';
import 'package:bmsk_userapp/providers/FeedbackProvider.dart';
import 'package:bmsk_userapp/services/FeedbackService.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
late Box box;
  final _formKey = GlobalKey<FormState>();
  late Future<List> _feedbacksFuture;
  TextEditingController subjectController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _feedbacksFuture = FeedbackService().fetchFeedbacks();box=Hive.box('permission');
  }
  
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          if (context.watch<FeedbackProvider>().initForm) ...[
            Form(
              key: _formKey,
              child: Column(
                children:[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Subject',
                    ),
                    validator: (v){
                      if (v == null || v.isEmpty) {
                        return 'একটি টপিক লিখুন ';
                      }
                      if (v.length<4 || v.length>20) {
                        return 'অবশ্যই ৪ অক্ষরের বড় এবং ২০ অক্ষরের ছোট হতে হবে';
                      }
                      return null;
                    }
                  ),
                  TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your message...',
                    ),
                    validator: (v){
                      if (v == null || v.isEmpty) {
                        return 'একটি মেসেজ লিখুন ';
                      }
                      if (v.length<10 || v.length>500) {
                        return 'অবশ্যই ১০ অক্ষরের বড় এবং ৫০০ অক্ষরের ছোট হতে হবে';
                      }
                      return null;
                    },
                  ),
                  FilledButton(
                    child: Text('SUBMIT'),
                    onPressed: () async{
                      if(_formKey.currentState!.validate()) {
                        final res = await context.read<FeedbackProvider>().setFeedback(subjectController.text,descriptionController.text);
                        if (!res['success']) {
                          Toast(Map<String, dynamic>.from(res));return;
                        }
                        context.read<FeedbackProvider>().setForm(false);
                      }
                    }
                  )
                ]
              )
            )
          ]
          else ...[
          box.get('services').contains('feedback') ?FilledButton(
            onPressed: (){
              context.read<FeedbackProvider>().setForm(true);
            },
            child: Text('New Feedback')
          ):Text('এই মুহূর্তে ফিডব্যাক দেয়ার অনুমতি নেই'),
          FutureBuilder<List>(
            future: _feedbacksFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No products found'));
              } else {
                return Expanded(
                  child: ListView.builder(
                  itemCount: context.watch<FeedbackProvider>().items.length,
                  itemBuilder: (context, index){
                    final feedback = snapshot.data![index];
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
                );
              }
              }
          )
          ]
        ],
      ),
    );
  }
}