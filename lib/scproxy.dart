library scproxy;
import 'dart:js';
import 'dart:html';
import 'dart:async';
import 'dart:convert';

class SCsound {
  JsObject _proxy;
  Map meta;
  SCsound(this._proxy){
  }

  
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
      
     HttpRequest.getString('http://api.soundcloud.com/tracks/124082151.json?client_id=' + client_id)
         .then((json){
           sounds[name] = new SCsound(sound);
           sounds[name].meta = JSON.decode(json);           
         });      

     
     
     
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