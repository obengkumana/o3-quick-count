$(document).ready( function () 
{
var oTable = $('#example').dataTable( {
 "sDom": 'RC<"clear">lfrtip'
} );
new FixedHeader( oTable );
} );
