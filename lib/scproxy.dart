library scproxy;
import 'dart:js';

class SCproxy {
  JsObject proxy = context['SC'];
  String client_id;
  
  SCproxy(this.client_id) {
    
  }  
  
  initialize() {
    proxy.callMethod('initialize', [client_id]);
  }
  stream(String track_id){
   var track = new JsObject(proxy.callMethod('stream',[track_id]));
   print(track);
  }
  
  
}