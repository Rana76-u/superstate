import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class FacebookVideoWidget extends StatelessWidget {
  FacebookVideoWidget ({super.key});

  /*String html = '''
           <iframe 
            src="https://www.facebook.com/v2.3/plugins/video.php? 
            allowfullscreen=false&autoplay=true&href=https://www.facebook.com/587654677/videos/276189938799049/" </iframe>
     ''';*/

  String html = '''
           <iframe 
            src="https://www.instagram.com/v2.3/plugins/video.php 
            allowfullscreen=false&autoplay=true&href=https://www.instagram.com/reel/C17VLogKyYG/?fbclid=IwAR2S7CE1VGS0tcmgVmiH36kXpchPlJN_x3UUUrs0I-DfBdC8GMr4TrOiJck" </iframe>
     ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: HtmlWidget(
            html
        ),
      ),
    );
  }
}
