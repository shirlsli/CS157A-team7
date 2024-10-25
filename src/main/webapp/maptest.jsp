<%@ page import="java.util.Properties, java.io.FileInputStream, java.io.IOException" %>
<%
	String apiKey = System.getenv("GOOGLE_MAPS_API_KEY");

%>
<!doctype html>
<!--
 @license
 Copyright 2019 Google LLC. All Rights Reserved.
 SPDX-License-Identifier: Apache-2.0
-->
<html>
  <head>
    <title>Add Map</title>
    <link rel="stylesheet" type="text/css" href="./css/style.css" />
  </head>
  <body>
    <h3>My Google Maps Demo</h3>
    <!--The div element for the map -->
    <div id="map"></div>
    <script src="./js/script.js"></script>

    <!-- prettier-ignore -->
    <script async
	    src="https://maps.googleapis.com/maps/api/js?key=<%= apiKey %>&callback=initMap">
	</script>
    
    <!-- I'm not sure why the example Google provided doesn't work.
    
    <script>(g=>{var h,a,k,p="The Google Maps JavaScript API",c="google",l="importLibrary",q="__ib__",m=document,b=window;b=b[c]||(b[c]={});var d=b.maps||(b.maps={}),r=new Set,e=new URLSearchParams,u=()=>h||(h=new Promise(async(f,n)=>{await (a=m.createElement("script"));e.set("libraries",[...r]+"");for(k in g)e.set(k.replace(/[A-Z]/g,t=>"_"+t[0].toLowerCase()),g[k]);e.set("callback",c+".maps."+q);a.src=`https://maps.${c}apis.com/maps/api/js?`+e;d[q]=f;a.onerror=()=>h=n(Error(p+" could not load."));a.nonce=m.querySelector("script[nonce]")?.nonce||"";m.head.append(a)}));d[l]?console.warn(p+" only loads once. Ignoring:",g):d[l]=(f,...n)=>r.add(f)&&u().then(()=>d[l](f,...n))})
        ({key: "API_KEY", v: "weekly"});</script> 
        
        -->
  </body>
</html>
