@charset "UTF-8";
/* CSS Document */
<style>

body {
    font-family: Arial,Helvetica,sans-serif;
    font-size: small;
    margin: 0;
    padding: 0;
    voice-family: inherit;
}
html > body {
    font-size: small;
    margin: 0px 0 0;    
}

#topRowWrapper {
    background-color: #FFFFFF;
    border: 1px none #CCCCCC;
    height: 233px;
    margin-bottom: 20px;
    padding: 0;
    width: 936px;
}

#portletWrapper {
    float: left;
    margin: 0 0px 0px 0;
    position: relative;
    width: 410px;
}

#portletContent {
    background-color: #FFFFFF;
    border-left: 1px solid #bbbdc0;
    border-right: 1px solid #bbbdc0;
    border-bottom: 1px solid #bbbdc0;
    border-bottom-left-radius: 6px;
    border-bottom-right-radius: 6px;
    height: 202px;
    width: 406px;
}

#portletContent form {
    margin: 0;
}

#portletHeader {
    background-color: #bbbdc0;
    border-color: #bbbdc0;
    border-style: solid;
    border-width: 1px 1px 0px;
    color: #ffffff;
    font-family: Arial,Helvetica,sans-serif;
    font-size: 14px;
    font-weight: bold;
    height: 39px;
    position: relative;
    width: 406px;
    border-top-left-radius: 6px;
    border-top-right-radius: 6px;
}

#leftColumnWrapper {
    float: left;
    height: 176px;
    margin-top: 0px;
    overflow: hidden;
    width: 170px;
}

#portletLeftNav {
    margin: 0;
    padding: 0;
    width: 90%;
	
}

#leftSideBG {
    background-color: #F5F5F5;
    border-right: 0px solid #C9C9C9;
}

#portletLeftNav li {
    list-style-type: none;
    font-size: 85%;
	
}

#portletLeftNav li a {
    background-color: #CBCBCB;
    border-bottom: 1px solid #B4B4B4;
    border-right: 1px solid #CCCCCC;
    border-top: 1px solid #F5F5F5;
    color: #A41B1B;
    display: block;
    padding-bottom: 5px;
    padding-left: 10px;
    padding-top: 5px;
    text-decoration: none;
    width: 100%;
}

#portletLeftNav #selectedNav a {
    background-color: #FFFFFF;
    background-image: none;
    border-right: medium none;
    border-top: medium none;
    color: #000;
}

#portletwrapper
#portletLeftNav li a:hover {
    background-color: #CBCBCB;
    color: #000000;
    text-decoration: none;
    font: arial;
    display: block;
}
    
#portletRightNav {
    float: right;
    height: 167px;
    overflow: auto;
    padding: 20px 0 0;
    width: 50%;
}

#portletRightNav li {
    font-size: 85%;
    color: #A41B1B;
    list-style-type: none;
    margin-right: 10px;
    padding-bottom: 6px;
}

#portletRightNav li a {
    color: #000;
}

#portletClearBoth {
    clear: both;
}

#portletFooter {
    border-bottom: 0px solid #C9C9C9;
    height: 0;
    width: 408px;
}

#leftTitle {
    border-bottom: 0px solid #8A8A8A;
    float: left;
    height: 37px;
    position: relative;
    width: 50%;
}
#rightTitle {
    border-bottom: 0px solid #8A8A8A;
    float: right;
    height: 37px;
    position: relative;
    width: 50%;
}

#leftTitle h1 {
    font-size: 13px;
    font-weight: bold;
    margin: 0;
    padding-left: 10px;
    padding-top: 15px;
}    

#rightTitle h1 {
    font-size: 13px;
    font-weight: bold;
    margin: 0;
    padding-top: 32px;
}

#uiBoxWrapper {
    border: 1px solid #bbbdc0;
    border-top-left-radius: 6px;
    border-top-right-radius: 6px;
    border-bottom-left-radius: 6px;
    border-bottom-right-radius: 6px;
    float: left;
    font-family: Arial,Helvetica,sans-serif;
    height: 241px;
    margin-bottom: 20px;
    margin-right: 6px;
    position: relative;
    width: 265px;
}

#uiBoxWrappervst {
    background-color: #FFFFFF;
    border: 1px solid #000000;
    clear: both;
    float: left;
    font-family: Arial,Helvetica,sans-serif;
    height: 231px;
    margin-bottom: 20px;
    margin-right: 0;
    position: relative;
    width: 265px;
}

#uiEndBoxWrapper {
    background-color: #FFFFFF;
    border: 1px solid #C9C9C9;
    float: left;
    font-family: Arial,Helvetica,sans-serif;
    margin-bottom: 20px;
    margin-right: 0;
}

#uiBoxWrapper .endBox {
    background-color: #FFFFFF;
    margin-right: 0;
}

#uiBoxHeader {
    background: none repeat scroll 0 0 #bbbdc0;
    border-top-left-radius: 6px;
    border-top-right-radius: 6px;
    border-bottom: 0px solid #A41B1B;
    height: 39px;
    width: 100%;
}

#uiBoxHeader h1 {
    color: #FFFFFF;
    font-size: 13px;
    font-weight: bold;
    height: 27px;
    margin: 0;
    padding-bottom: 0;
    padding-left: 10px;
    padding-top: 10px;
    width: 290px;
}

#uiBoxContent {
    color: #000000;
    font-size: 11px;
    height: 131px;
    line-height: 125%;
    margin-top: 0;
    padding-left: 0;
    width: 263px;
}

#uiBoxContent p, {
    height: 10px;
}

#uiBoxContent p, #uiBoxContent a {
    margin-left: 10px;
    margin-right: 10px;
    color: #000000;
    font-size: 11px;
    text-decoration: none;
    height: 0px;	
}

#uiBoxContent a:hover {
    color: #A41B1B;
    text-decoration: underline;
}

#uiBoxImage {
    height: 69px;
    width: 263px;
}

#uiBoxContent sup {
    font-style: italic;
    margin-left: -10px;
}

#uiFooter {
    bottom: 0;
    height: 17px;
    position: absolute;
    width: 100%;
}
img {
    float: left;
    margin-bottom: 0;
    margin-right: 0;
}
#uiColWrapper:after {
    clear: both;
    content: ".";
    display: block;
    height: 0;
    visibility: hidden;
}
#uiColWrapper {
    border: 0 none #FFFFFF;
    float: left;
    margin-right: 6px;
	font-family: Arial,Helvetica,sans-serif;    
}
#uiRowWrapper {
    border: 0 none #FFFFFF;
    clear: both;
}
* + html #uiRowWrapper {
    min-height: 256px;
}
#textBoxWrapper {
    border: none;
    float: left;
    margin-bottom: 13px;
    margin-right: 0;
    position: relative;
    width: 100%;
    font-family: arial;
}
#textBoxWrappervst {
    border: 1px solid #C9C9C9;
    clear: both;
    float: left;
    margin-bottom: 13px;
    margin-right: 0;
    position: relative;
    width: 100%;
}
#textBoxWrapper #uiFooter {
    width: 100%;
}
#imageBoxWrapper {
    float: left;
    margin-bottom: 13px;
    margin-right: 0;
    width: 240px;
}
#imageBoxWrapperimgvst {
    clear: both;
    float: left;
    margin-bottom: 13px;
    margin-right: 0;
    width: 240px;
}
#uiSingleImage {
    float: left;
    margin-bottom: 0;
    margin-right: 0;
}
#uiSingleText {
    margin: 10px 0px 5px;
}
#uiSingleImage img {
    border: medium none;
}
#uiSingleText a {
    color: #A41B1B;
    font-size: 11px;
    text-decoration: none;
}
#uiSingleText a:hover {
    text-decoration: underline;
}
.twoBox {
    float: left;
    height: 262px;
}
.vst {
    clear: both;
}
.imgvst {
    clear: both;
}
#uiRowWrapper:after {
    clear: both;
    content: ".";
    display: block;
    height: 0;
    visibility: hidden;
}



a {
	border-bottom: 1px dotted;
    text-decoration: none;
}

u {
	text-decoration:none;
}

blockquote {
	margin: 0;
}

</style>
