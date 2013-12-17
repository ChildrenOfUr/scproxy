library scproxy;
import 'dart:js';

class SCproxy {
  String client_id;
  String redirect_uri;
  
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
  stream(String track_id){   
    context['SC'].callMethod('stream', [track_id, (sound) {
     sound.callMethod('play');
   }]);
  }
  
}