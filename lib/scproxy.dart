library scproxy;
import 'dart:js';
import 'dart:html';
import 'dart:async';
import 'dart:convert';

class SCsound {
  JsObject _proxy;
  Map meta;
  
  bool paused = false;
  bool muted = false;
  bool repeat = false;
  bool _stopped = false;
  
  StreamController _playController;
  Stream onPlay;
  StreamController _stopController;
  Stream onStop;
  StreamController _doneController;
  Stream onDone;
  StreamController _pauseController;
  Stream onPause;
  StreamController _resumeController;
  Stream onResume;
  
  SCsound(this._proxy){
    _playController = new StreamController();
    onPlay = _playController.stream;
    
    _stopController = new StreamController();
    onStop = _stopController.stream;    
    
    _doneController = new StreamController();
    onDone = _doneController.stream; 
    
    _pauseController = new StreamController();
    onPause = _pauseController.stream; 
    
    _resumeController = new StreamController();
    onResume = _resumeController.stream; 
  }
  
  // methods act on the sound object and trigger relevant events.
  
  play(){
    if (_stopped == false)
      _proxy.callMethod('stop');
    _stopped = false;
    Timer t = new Timer(new Duration(milliseconds: meta['duration']),() 
        {
      if (repeat == true && _stopped == false)
        play();
      _doneController.add(null);
      });
    _proxy.callMethod('play');
    _playController.add(null);
  }
  
  stop(){
    _stopped = true;
    _proxy.callMethod('stop');
    _stopController.add(null);
  }
  pause(){
    _proxy.callMethod('pause');
    paused = true;
    _pauseController.add(null);
  }
  resume(){
    _proxy.callMethod('resume');
    paused = false;
    _resumeController.add(null);
  }
  togglePause(){
    _proxy.callMethod('togglePause');
    if (paused == true)
    paused = false;
    else
    paused = true;
  }
  volume(int value){// takes values 0 to 100
    _proxy.callMethod('setVolume', [value]);
  }
  setPan(int value){// takes values -100 to 100
    _proxy.callMethod('setPan', [value]);
  }
  mute(){
    _proxy.callMethod('mute');
    muted = true;
  }
  unmute(){
    _proxy.callMethod('unmute');
    muted = false;
  }
  toggleMute(){
    _proxy.callMethod('toggleMute');
    if (muted == true)
    muted = false;
    else
    muted = true;
  }
  
  // Destroy the sound object,and close all the event listeners
  destruct(){
    _proxy.callMethod('destruct');
    _playController.close();  
    _stopController.close();  
    _doneController.close();   
    _pauseController.close();
    
  }

}

class SCproxy {
  String client_id;
  String redirect_uri;
  
  SCproxy(this.client_id) {
    context['SC'].callMethod('initialize',
        [
         new JsObject.jsify({
           "client_id" : client_id           
         })         
         ]);
  } 
  
  
  Future <SCsound> load(String track_id){ 
    var completer = new Completer();
    SCsound newSound;
    
    // set up the proxy sound 
    context['SC'].callMethod('stream', [track_id, (sound) {
      newSound = new SCsound(sound);
      
      // Get the metadata for the sound
      HttpRequest.getString('http://api.soundcloud.com'+ track_id +'.json?client_id=' + client_id)
        .then((json){
          newSound.meta = JSON.decode(json);           
        });   
      
      
      // Continually checks if the soundmanager2 object is ready, then returns a proxy SCsound.
      Timer T;
      T = new Timer.periodic(new Duration(milliseconds : 100), 
          (_)  {
        if (newSound._proxy is JsObject && newSound.meta != null)
        {completer.complete(newSound);T.cancel();}
        });
      
   }]);
   
    return completer.future; 
  }
}