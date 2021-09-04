import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project2/api/API.dart';
import 'package:project2/utils/styles.dart';
import 'package:provider/provider.dart';


class DetailsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Story",
          style: CustomTextStyles.appBarText,
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Consumer<API>(builder: (context, model, child) {
        return Container(
            height: MediaQuery.of(context)
      .size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width*0.80,
            child: ListView.builder( scrollDirection: Axis.vertical,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      getCard1(context,model.getStory(model.getIndexElement()).text1,"${API.url}down?path="+model.getStory(model.getIndexElement()).image1),
                      getCard1(context,model.getStory(model.getIndexElement()).text2,"${API.url}down?path="+model.getStory(model.getIndexElement()).image2),

                    ],
                  );
                })),


          ),

        );}),




    );
  }
  Widget getCard1(BuildContext context,String text,String imagePath) {
    return Card(
      margin: EdgeInsets.all(16),
      color: CustomColors.primaryColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height*0.60,
          width: MediaQuery.of(context).size.width*0.80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                child: Container(
                  height: MediaQuery.of(context).size.height*0.30,
                    width: MediaQuery.of(context).size.width*0.80,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(6),
                    image: DecorationImage(
                      scale: 10,

                        image: NetworkImage(imagePath), fit: BoxFit.cover),
                  ),


                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(text,textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
