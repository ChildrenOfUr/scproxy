import 'package:scproxy/scproxy.dart';
import 'dart:html';

main() {
  SCproxy SC = new SCproxy('72ed25bc5f4c2a06ab8bf3d3e54eef6e');  
  SC.load('/tracks/124082151')
  .then((s) 
      {
    s.play();
    document.onClick.listen((_) => s.play());
      })

  .catchError((err) => print(err));
}