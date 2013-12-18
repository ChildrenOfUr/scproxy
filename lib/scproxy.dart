library scproxy;
import 'dart:js';
import 'dart:async';

class SCsound {
  JsObject _proxy;
  StreamController _state = new StreamController();
  SCsound(this._proxy){}

  
  play(){
    _proxy.callMethod('play');
  }
  stop(){
    _proxy.callMethod('stop');
  }
  pause(){
    _proxy.callMethod('pause');
  }
  volume(int value){
    _proxy.callMethod('setVolume', [value]);
  }
  toggleMute(){
    _proxy.callMethod('toggleMute');
  }
  destruct(){
    _proxy.callMethod('destruct');
  }

}

class SCproxy {
  String client_id;
  String redirect_uri;
  Map sounds = new Map();
  
  SCproxy(this.client_id) {
    initialize();
  }  
  
  initialize() {
    context['SC'].callMethod('initialize',
        [
         new JsObject.jsify({
           "client_id" : client_id           
         })         
         ]);
  }
  
  
  Future <SCsound> load(String name,String track_id){ 
    var completer = new Completer();
    
    context['SC'].callMethod('stream', [track_id, (sound) {
     sounds[name] = new SCsound(sound);
     Timer T;
     T = new Timer.periodic(new Duration(seconds : 1), 
        (_)  {
       if (sounds[name] != null)
        {completer.complete(); T.cancel();}
        });

   }]);
    return completer.future; 
  }
}