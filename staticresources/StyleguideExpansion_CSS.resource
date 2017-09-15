/* SunPower Style Guide Expansion Pack
* - Components are USE AT YOUR OWN RISK 
* - Once verified/tested/approved will be made part of main styleguide
* - Do Not Modify below content without express permission
*
* CONTENTS:
* -Modal css markup - requires JQuery and the Expansion Pack JS
* -Progress Bar
* 
* 
*/

/*** PROGRESS BAR ***/
/*
SAMPLE MARKUP:
<div class="row" style="margin-bottom: 20px;">
	<div class="hide-mobile show-desktop" style="width: 100%;">
		<ol class="progress">
			<li class="progress-done" >General Information</li>
			<li class="progress-active" >Product Information</li>
			<li class="progress-todo" >Notes and Attachments</li>
			<li class="progress-todo" >Disclaimer</li>
		</ol>
	</div>
</div>
*/
@media only screen and (min-width: 992px) {
	ol.progress {
		display: table;
		list-style-type: none;
		margin-bottom: .5rem;
		padding: 0;
		table-layout: fixed;
		width: 100%;
	}
	ol.progress li {
		display: table-cell;
		text-align: center;
		line-height: 3.5em;
	}

	ol.progress[data-progress-steps="2"] li { width: 49%; }
	ol.progress[data-progress-steps="3"] li { width: 33%; }
	ol.progress[data-progress-steps="4"] li { width: 24%; }
	ol.progress[data-progress-steps="5"] li { width: 19%; }
	ol.progress[data-progress-steps="6"] li { width: 16%; }
	ol.progress[data-progress-steps="7"] li { width: 14%; }
	ol.progress[data-progress-steps="8"] li { width: 12%; }
	ol.progress[data-progress-steps="9"] li { width: 11%; }

	ol.progress li.progress-done {
		color: black;
		font-size: smaller;
		border-bottom: 4px solid #D8D8D8;
	}
	ol.progress li.progress-todo {
		color: black; 
		font-size: smaller;
		border-bottom: 4px solid #D8D8D8;
	}
	ol.progress li.progress-active {
		color: black; 
		font-size: smaller;
		border-bottom: 4px solid #D8D8D8;
	}

	ol.progress li:after {
		content: "\00a0\00a0";
	}
	ol.progress li:before {
		position: relative;
		bottom: -2.5em;
		float: left;
		left: 45%;
		line-height: 1em;
	}
	ol.progress li.progress-done:before {
		content: "\2714";
		color: #f7921e;
		background-color: white;
		height: 3em;
		width: 3em;
		line-height: 2.5em;
		border: solid;
		border-color: #f7921e;
		border-radius: 2em;
	}
	ol.progress li.progress-todo:before {
		content: "";
		color: #D8D8D8;
		background-color: white;
		height: 3em;
		width: 3em;
		line-height: 2em;
		border: solid;
		border-color: #D8D8D8;
		border-radius: 2em;
	}
	ol.progress li.progress-active:before {
		content: "";
		color: #f7921e;
		background-color: white;
		height: 3em;
		width: 3em;
		line-height: 2em;
		border: solid;
		border-color: #f7921e;
		border-radius: 2em;
	}
}

/*** MODAL ***/
/*

To create a scrolling height modal add below lines:
.modal-body {
	max-height: calc(100vh - 212px);
	overflow-y: auto;
}

*/

.modal-open {
  overflow: hidden;
}

.modal {
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 1050;
  display: none;
  overflow: hidden;
  -webkit-overflow-scrolling: touch;
  outline: 0;
}

.modal.fade .modal-dialog {
  -webkit-transition: -webkit-transform .3s ease-out;
  -o-transition: -o-transform .3s ease-out;
  transition: transform .3s ease-out;
  -webkit-transform: translate(0, -25%);
  -ms-transform: translate(0, -25%);
  -o-transform: translate(0, -25%);
  transform: translate(0, -25%);
}

.modal.in .modal-dialog {
  -webkit-transform: translate(0, 0);
  -ms-transform: translate(0, 0);
  -o-transform: translate(0, 0);
  transform: translate(0, 0);
}

.modal-open .modal {
  overflow-x: hidden;
  overflow-y: auto;
}

.modal-dialog {
  position: relative;
  width: auto;
  margin: 10px;
}

.modal-content {
  position: relative;
  background-color: #fff;
  -webkit-background-clip: padding-box;
  background-clip: padding-box;
  border: 1px solid #999;
  border: 1px solid rgba(0, 0, 0, .2);
  border-radius: 6px;
  outline: 0;
  -webkit-box-shadow: 0 3px 9px rgba(0, 0, 0, .5);
  box-shadow: 0 3px 9px rgba(0, 0, 0, .5);
}

.modal-backdrop {
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 1040;
  background-color: #000;
}

.modal-backdrop.fade {
  filter: alpha(opacity=0);
  opacity: 0;
}

.modal-backdrop.in {
  filter: alpha(opacity=50);
  opacity: .5;
}

.modal-header {
  min-height: 16.42857143px;
  padding: 15px;
  border-bottom: 1px solid #0076be;
}

.modal-header .close {
  margin-top: -2px;
}

.modal-title {
  margin: 0;
  line-height: 1.42857143;
}

.modal-body {
  position: relative;
  padding: 15px;
}

.modal-footer {
  padding: 15px;
  text-align: right;
  border-top: 1px solid #0076be;
}

.modal-footer .btn + .btn {
  margin-bottom: 0;
  margin-left: 5px;
}

.modal-footer .btn-group .btn + .btn {
  margin-left: -1px;
}

.modal-footer .btn-block + .btn-block {
  margin-left: 0;
}

.modal-scrollbar-measure {
  position: absolute;
  top: -9999px;
  width: 50px;
  height: 50px;
  overflow: scroll;
}

@media (min-width: 768px) {
  .modal-dialog {
    width: 650px;
    margin: 30px auto;
  }

  .modal-content {
    -webkit-box-shadow: 0 5px 15px rgba(0, 0, 0, .5);
    box-shadow: 0 5px 15px rgba(0, 0, 0, .5);
  }

  .modal-sm {
    width: 300px;
  }
}

@media (min-width: 992px) {
  .modal-lg {
    width: 900px;
  }
}

.modal-footer:before,
.modal-footer:after {
  display: table;
  content: " ";
}

.modal-footer:after {
  clear: both;
}

.close {
	float: right;
	font-size: 21px;
	font-weight: bold;
	line-height: 1;
	color: #000;
	text-shadow: 0 1px 0 #fff;
	filter: alpha(opacity=20);
	opacity: .2;
}
.close:hover,
.close:focus {
	color: #000;
	text-decoration: none;
	cursor: pointer;
	filter: alpha(opacity=50);
	opacity: .5;
}

button.close {
	-webkit-appearance: none !important;
	padding: 0;
	cursor: pointer;
	background: transparent;
	border: 0;
}

/*** DROPDOWN BUTTON ***/

/* sample markup */
/*
<div class="dropdown">
	<button class="dropdown-btn btn btn-secondary btn--small" onclick="myFunction('myDropdownId_1')" >
		HELIX DESIGN REQUEST
		<span class="icon-container">    
			<i class="icon icon-chevron-thin-down"></i>
		</span> 
	</button>
	<div id="myDropdownId_1}" class="dropdown-content">
		<apex:outputLink styleClass="dropdown-item" value="/apex/Page1" target="_parent">Page1</apex:outputLink>
		<apex:outputLink styleClass="dropdown-item" value="/apex/Page2" target="_parent">Page2</apex:outputLink>
	</div>
</div>
*/

/* script to open/close dropdown options */
/*
<script>
	function myFunction(myDropdownId) {
		document.getElementById(myDropdownId).classList.toggle("dropdown-show");
	}
</script>
*/

/* script to close dropdown options when clicked outside button included in StyleguideExpansion_JS */

.dropdown {
	position: relative;
	display: inline-block;
	border: 2px solid transparent;
	border-radius: .25rem;
	outline: 0;
}
.dropdown-content {
	list-style: none;
	width: 100%;
	padding: 0;
	margin: 0;
	margin-top: -0.2rem;
	position: absolute;
	display: none;
	border-bottom-left-radius: .25rem;
	border-bottom-right-radius: .25rem;
}
.btn-secondary + .dropdown-content {
	background:#FFF;
	border-bottom: 2px solid #016ca7;
}
.dropdown-item {
	outline: 0;
	cursor: pointer;
	display: -webkit-box;
	display: -ms-flexbox;
	display: flex;
	padding: .6rem;
}
.btn-secondary + .dropdown-content .dropdown-item {
	color: #016ca7;
	background: #fff;
	border-left: 2px solid #016ca7;
	border-right: 2px solid #016ca7;
}
.dropdown-show {
	display:block;
	z-index: 1;
}
.dropdown-item:focus,
.dropdown-item:active,
.dropdown-item:hover {
	outline: 0;
}
.btn-secondary + .dropdown-content .dropdown-item:hover {
	background-color: rgba(0, 108, 167, 0.1);
}
.btn-secondary + .dropdown-content .dropdown-item:active,
.btn-secondary + .dropdown-content .dropdown-item.active {
	background-color: rgba(0, 108, 167, 0.2);
}
.dropdown-item:last-of-type {
	border-bottom-right-radius: .25rem;
	border-bottom-left-radius: 0.25rem;
}
.dropdown-content a:hover {
	text-decoration: none;
}
