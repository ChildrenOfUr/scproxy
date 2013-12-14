import 'package:scproxy/scproxy.dart';



main() {
  SCproxy SC = new SCproxy('72ed25bc5f4c2a06ab8bf3d3e54eef6e');
  SC.initialize();
  SC.stream('/tracks/111477464');
  
}