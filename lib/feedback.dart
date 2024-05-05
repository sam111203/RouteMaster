import 'package:flutter/material.dart';
import 'prehomepage.dart';
class FeedbackSender extends StatefulWidget {
  const FeedbackSender({super.key});

  @override
  State<FeedbackSender> createState() => _FeedbackSenderState();
}

class _FeedbackSenderState extends State<FeedbackSender> {
  final TextEditingController Textcontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Feedback Section'),
          backgroundColor: Colors.grey,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Please enter your feedback below",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
              Padding(padding: EdgeInsets.all(30.0),
              child: TextFormField(
                controller: Textcontroller,
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    hintText: 'Enter your Feedback',
                    hintStyle: TextStyle(
                        color: Colors.grey
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )
                ),
              ),),
              ElevatedButton(
                  onPressed: (){
                 if(Textcontroller.value.text.isNotEmpty){

                 }
                 else{
                   showDialog(context: context, builder: (context)=>AlertDialog(
                     title: Text('Feedback empty!!! Please enter a feedback!',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
                     actions: <Widget>[
                       ElevatedButton(onPressed: (){
                         Navigator.pop(context);
                       }, child: Text("Ok!")),
                     ],
                   ));
                 }

              },
                  child: Text('Send feedback'))
            ],
          ),
        ),
      ),
    );

  }
}
