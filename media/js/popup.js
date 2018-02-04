function launchCenter(url, name, width, height, winstyle) 
	{
		var str = "height=" + height + ",innerHeight=" + height;
		str += ",width=" + width + ",innerWidth=" + width;  if (window.screen) {
		var ah = screen.availHeight - 30;    var aw = screen.availWidth - 10;
		var xc = (aw - width) / 2;    var yc = (ah - height) / 2;
		str += ",left=" + xc + ",screenX=" + xc;
		str += ",top=" + yc + ",screenY=" + yc;  }
		return window.open(url, name, str + "," + winstyle);
	}
	function PopWindow(strURL, width, height)
	{		
		launchCenter(strURL, '_blank', width, height, 'scrollbars=yes,toolbar=no,location=no,menubar=no,resizable=no')
	}
	function launchFullScreen( aURL )
	{
	   var wOpen;
	   var sOptions;

	   sOptions = 'status=yes,menubar=yes,scrollbars=yes,resizable=yes,toolbar=yes';
	   sOptions = sOptions + ',width=' + (screen.availWidth - 10).toString();
	   sOptions = sOptions + ',height=' + (screen.availHeight - 122).toString();
	   sOptions = sOptions + ',screenX=0,screenY=0,left=0,top=0';

	   wOpen = window.open( '', '_blank', sOptions );
	   wOpen.location = aURL;
	   wOpen.focus();
	   wOpen.moveTo( 0, 0 );
	   wOpen.resizeTo( screen.availWidth, screen.availHeight );
	   return wOpen;
	}