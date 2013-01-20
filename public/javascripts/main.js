$(function(){
	
	var dropbox = $('#dropbox'),
		  message = $('.message', dropbox);
	
	dropbox.filedrop({
		paramname: 'upload',
		
    maxfilesize: 20,
		url: '/',
		
		uploadFinished: function(i,file,response){
			$.data(file).addClass('done');
		},
		
    error: function(err, file) {
			switch(err) {
				case 'BrowserNotSupported':
					alert('Your browser does not support HTML5 file uploads!');
					break;
				case 'TooManyFiles':
					alert('Too many files! Please select 5 at most! (configurable)');
					break;
				case 'FileTooLarge':
					alert(file.name+' is too large! Please upload files up to 2mb (configurable).');
					break;
				default:
					break;
			}
		},
		
		uploadStarted:function(i, file, len){
      message.hide();
			createImage(file);
		},

	});
	
	var template = '<div class="preview">'+
						'<span class="imageHolder">'+
							'<img id="spinner" src="/images/spinner.gif" />'+
							'<span class="uploaded"></span>'+
						'</span>'+
					'</div>'; 
	
	
	function createImage(file){
		var preview = $(template);

		preview.appendTo(dropbox);
		$.data(file,preview);
	}

});
