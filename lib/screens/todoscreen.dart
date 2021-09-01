// import 'package:flutter/material.dart';

// class TodoScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//           child: Container(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Expanded(
//                 child: TextField(
//               autofocus: true,
//               decoration: InputDecoration(
//                 hintText: "Add Task",
//                 border: OutlineInputBorder(
//                     borderSide: BorderSide(
//                         style: BorderStyle.solid, color: Colors.blueAccent)),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(
//                       style: BorderStyle.solid,
//                       width: 3.0,
//                       color: Colors.blueAccent),
//                 ),
//               ),
//               keyboardType: TextInputType.multiline,
//               maxLines: 3,
//               style: TextStyle(fontSize: 20),
//             )),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 FlatButton(
//                     color: Colors.red,
//                     onPressed: () {},
//                     child: Text(
//                       "Cancel",
//                       style: TextStyle(color: Colors.white),
//                     )),
//                 FlatButton(
//                     color: Colors.green,
//                     onPressed: () {},
//                     child: Text(
//                       "Add",
//                       style: TextStyle(color: Colors.white),
//                     ))
//               ],
//             )
//           ],
//         ),
//       )),
//     );
//   }
// }


import 'package:flutter/material.dart';

class RishiPage extends StatefulWidget {
  const RishiPage({ Key? key }) : super(key: key);

  @override
  _RishiPageState createState() => _RishiPageState();
}

class _RishiPageState extends State<RishiPage> {
  List name = [];
  List school = [];
  late String input;
  late String schInpu;
  
  
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   data.add("Rishi");
  //   data.add("Btech");
  //   data.add("Naga");
  // }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
            title: Text("Add Details"),
            content: Column(children: [
              TextField(onChanged:  (String value){
                input = value;
                
              },),
              TextField(onChanged:  (String value2){
                schInpu = value2;
                
              },),
              
            ],
            
            ),
            actions: [
              TextButton(onPressed: (){
                setState(() {
                  name.add(input);
                  school.add(schInpu);
                });
              }, child: Text("Add"))
            ],
          );
        });
      },child: Icon(Icons.add,color: Colors.white,),),
      body: ListView.builder(
        itemCount: name.length,
        itemBuilder: (context,index){
        return Dismissible(key: Key(name[index]), child: Card(
          child: ListTile(
            title: Column(
              children: [
                Text(name[index]),
                Text(school[index]),
              ],
            ),
          ),
        ));
      })
      );
      
    
  }
}