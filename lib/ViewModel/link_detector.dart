import 'package:any_link_preview/any_link_preview.dart';
import 'package:linkify/linkify.dart';

class LinkDetector {

  List detect(String text) {
    List links = [];

    List<LinkifyElement> linkifyItems = linkify(text);
    for (int i = 1; i < linkifyItems.length; i = i + 2) {
      if (linkifyItems[i] is UrlElement) {
        UrlElement urlElement = linkifyItems[i] as UrlElement;
        links.add(urlElement.url);
      }
    }
   return links;
  }

  Future<String> fetchTitle(String link) async {
    Metadata? metadata = await AnyLinkPreview.getMetadata(link: link,);

    return metadata!.title ?? '';
  }


}