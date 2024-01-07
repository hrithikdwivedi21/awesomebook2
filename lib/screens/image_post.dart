import 'package:flutter/material.dart';

class AddImage extends StatefulWidget {
  const AddImage({Key? key}) : super(key: key);

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  String? selectedValue='Entertainment';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Add Post"),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Post',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 487/451,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://caknowledge.com/wp-content/uploads/2021/03/Hrithik-Roshan-hot-body.jpeg"
                      ),
                      fit: BoxFit.fill,
                      alignment: FractionalOffset.topCenter,
                    )
                ),
              ),
            ),
          ),
              SizedBox(height: 10.0,),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.9,
                child: DropdownButtonFormField(
                  value: selectedValue,
                  onChanged: (newValue){
                    setState(() {
                      selectedValue=newValue as String;
                    });
                  },
                  items: ['Entertainment', 'Gaming', 'Bollywood','Tollywood','Politics','Food'].map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 10.0,),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.9,
                child: TextField(

                  decoration: const InputDecoration(
                    hintText: 'Write caption here...',
                  ),
                  maxLines: 3,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.9,
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  width: MediaQuery.of(context).size.width * .90,
                  height: MediaQuery.of(context).size.width * .14,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Center(
                    child:const Text(
                      'Post Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ),
                ),
                ),


              const Divider(),

        ],
      ),
    );
  }
}
