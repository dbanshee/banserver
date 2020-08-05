(function(){var url="https://static.radioforge.com/radio2014/html5.html";var current_location=window.location.hostname;var currentTime=Date.now()||+new Date();if(typeof id!='undefined'){url+="?id="+id;}
else
{url+="?id="+currentTime;}
if(typeof radiostream!='undefined'){url+="&url="+radiostream;}
if(typeof current_location!='undefined'){url+="&host="+encodeURI(current_location);}
if(typeof title!='undefined'){url+="&title="+title;}
if(typeof width!='undefined'){url+="&width="+width;}
if(typeof height!='undefined'){url+="&height="+height;}
if(typeof source!='undefined'){url+="&source="+source;}
if(typeof version!='undefined'){url+="&version="+version;}
if(typeof autoplay!='undefined'){url+="&autoplay="+autoplay;}
if(typeof artwork!='undefined'){url+="&artwork="+artwork;}
if(typeof artist!='undefined'){url+="&artist="+artist;}
if(typeof radiostream!='undefined'){document.write("<iframe src='"+url+"' frameborder='0' scrolling='no' marginwidth='0' marginheight='0' height='"+height+"' width='"+width+"'></iframe>");}else{document.write('<p>Radio Stream URL is not found</p>');}})()