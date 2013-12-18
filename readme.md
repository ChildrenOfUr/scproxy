
SCproxy is your proxy to the realm of SoundCloud

SCproxy SC = new SCproxy('api key goes here');

Load some songs
SC.load('firebog','/tracks/111477464');// Returns a future

SCsound firebog = SC.sounds['firebog']; // all loaded songs are stored in the proxy's sounds map.

firebog.play(); //Play