$(function(){
	
	var dropbox = $('#dropbox'),
		  message = $('.message', dropbox);
	
	dropbox.filedrop({
		// The name of the $_FILES entry:
		paramname:'upload',
		
		maxfiles: 5,
    maxfilesize: 2,
		url: '/',
		
		uploadFinished:function(i,file,response){
			$.data(file).addClass('done');
		},
		
    error: function(err, file) {
			switch(err) {
				case 'BrowserNotSupported':
					showMessage('Your browser does not support HTML5 file uploads!');
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

		var preview = $(template), 
	      image = $('img', preview);
			
		message.hide();
		preview.appendTo(dropbox);
		
		$.data(file,preview);
	}

	function showMessage(msg){
		message.html(msg);
	}

});
