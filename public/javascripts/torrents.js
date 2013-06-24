(function() {
  el = document.getElementsByClassName('index')[0];
  if (el !== undefined && el.tagName === 'A') {
    torrent_url = el.href;
    var x = new XMLHttpRequest();
    x.open("POST", "http://upload.kobayashi.cyanoryx.com/", true);
    x.setRequestHeader('Content-Type','application/x-www-form-urlencoded');

    var status_div = document.createElement('div');
    status_div.setAttribute('id', 'kobayashi_upload_status');
    document.body.appendChild(status_div);
    status_div.innerHTML = 'Saving...';

    styles = {
      'width': '100%',
      'height': '50px',
      'background': 'white',
      'opacity': '0.5',
      'font-size': '35px',
      'font-weight': 'bold',
      'font-family': 'Helvetica',
      'position': 'absolute',
      'top': '0',
      'left': '0',
      'padding-top': '10px',
      'color': 'black',
      'text-align': 'center'
    };

    var style;
    for (style in styles) {
      var value = styles[style];
      status_div.style[style] = value;
    }

    x.onreadystatechange = function(){
      try {
        if (x.readyState !== 4) { return; }
        if (x.status !== 200) { throw(0); }
        status_div.innerHTML = 'Saved.';
      } catch (e) {
        console.log(e);
        status_div.innerHTML = 'Could not save, check log.';
      }
    };

    x.send("url="+torrent_url);
  }
}).call(this);
