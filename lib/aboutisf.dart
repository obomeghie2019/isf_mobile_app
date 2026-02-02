import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("About Iyekhei Sport Festival (ISF)",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "About Iyekhei Sport Festival (ISF)",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              //Ads Banner
              //  BannerAdWidget(
              //adUnitId: 'ca-app-pub-8686875793330353/6579589869',
              //),
              SizedBox(height: 12),
              Text(
                "The Iyekhei Sport Festival (ISF) is an annual festival for various sporting activities managed by the Iyekhei Sport Festival Committee (ISFC), which is a committee under the Auchi Dynamic Youth Association (Zone E) Iyekhei. "
                "The ISF was initiated under the reign of Abubakar Abdulazeez in 2018 to organise annual sporting activities aimed at bringing out the spirit of sportsmanship from Iyekhei sons, daughters, and other individuals."
                "The festival is designed to promote unity, friendship, and healthy competition among participants 2018 which the Chairman of the ISF Committe was Jimba Abdulwahab (Sawi) and Seceretary was Amb. Comr. Lukman Adam Obomeghie (Oraya)."
                "The current Chairman of the ISF Committee is Dr. Muhammed Awwal Bawa and the Secretary is Muhammed Taofiq\n"
                "Winner of the ISF editions since;\n-Odikoko FC 2018 \n-Odikoko FC 2019 \n-Osighue FC 2020 \n-Oge FC 2021 \n-Ikharia FC 2022 \n-Oge FC 2023 \n-Oge FC 2024 \n This make Oge FC the most successful team in the history of ISF with 3 titles and the current champion of ISF.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  height: 1.5, // Line height adjustment for better readability
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
