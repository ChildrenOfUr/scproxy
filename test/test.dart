import 'package:scproxy/scproxy.dart';


main() {
  SCproxy SC = new SCproxy('72ed25bc5f4c2a06ab8bf3d3e54eef6e');
  SC.load('firebog','/tracks/111477464').then( (_) => SC.sounds['firebog'].play())
  .then((_)
      {
    SCsound firebog = SC.sounds['firebog'];
    firebog.volume(50);
    print(firebog.meta);
      });
}