.sp-blue {
	color: #0076be;
}

.topper {
	display: block;
	background-color: #0076be;
	color: #c0dae7;
	height: 1.25rem;
	width: 100%;
	margin-bottom: 20px;
}

h4 {
	margin-bottom: .5rem !important;
}

p {
	font-size: small;           
}

.page-header {
	margin-bottom: 20px;
	border-bottom: 1px solid #eee;
}

.section-header {
	border-bottom: 2px solid #0073C5;
	padding-left: 0px;
	margin-bottom: .5rem;
	margin-top: .5rem;
}

.pretty-inputs {
	color: #0076be;
	font-size: medium;
	font-weight: 500;
	border-radius: 4px;
	background-color: #F4F4F4;
	border: none;
	padding-left: .5rem;            
}

.radio label input[type=radio]:checked+span:before,
.checkbox label input[type=checkbox]:checked+span:before {
	color: #0076be !important;
}

.form-group label {
	font-weight: 600;
	font-size: .80rem;
	color: black;
	text-align: left;
	width: inherit;
}

.form-group .input-container {
	width: 100%; 
	display: inline-block;
	height: 2.5rem;
}

.sunpower-style select {
	display: inline-block;
	-webkit-box-flex: 1;
	flex-grow: 1;
	flex-wrap: wrap;
	height: 2.5rem;
	text-transform: none;
	border-radius: 0;
	font: inherit;
	margin: 0;
	color: #0076be;
	background-color: #F4F4F4;
	border: none;
	padding-left: .5rem;
	width: 100%
}

.sunpower-style .table tbody tr:nth-of-type(odd) {
	background-color: transparent;
}

.sunpower-style .copyright {
	margin-left: auto;
	margin-right: auto;
	margin-top: 2rem;
}

.tabs {
	width: 100%;
}

.tabs__header-item {
	width: 100%;
}

.sunpower-style .tabs__header-item--active {
	border-bottom: #f7921e 2px solid;
}

.subtab-styling {
	border-bottom: 1px solid #e5e5e5
	width: 100%;
}

.subtab-styling__header-container {
	overflow: hidden
}

.subtab-styling__header-container::-webkit-scrollbar {
	width: 0;
	display: none;
	background: transparent
}

.subtab-styling__header {
	cursor: pointer;
	list-style: none;
	display: -webkit-box;
	display: -ms-flexbox;
	display: flex;
	-webkit-box-orient: horizontal;
	-webkit-box-direction: normal;
	-ms-flex-direction: row;
	flex-direction: row;
	padding: 0;
	margin: 0;
	color: #9b9b9b;
	overflow: hidden;
}

.subtab-styling__header::after {
	content: " ";
	-webkit-box-flex: 1;
	-ms-flex-positive: 1;
	flex-grow: 1;
	cursor: default;
	display: -webkit-box;
	display: -ms-flexbox;
	display: flex;
	border-bottom: 1px solid #e5e5e5
}

.subtab-styling__header-item {
	background-color: #f5f5f5;
	border-right: 1px solid #e5e5e5;
	border-top: 1px solid #e5e5e5;
	border-bottom: 1px solid #e5e5e5;
	padding: 1rem;
	min-width: 5rem;
	text-align: center;
	width: 100%;
}

.subtab-styling__header-item:first-of-type {
	border-left: 1px solid #e5e5e5;
	border-top-left-radius: 2px
}

.subtab-styling__header-item:last-of-type {
	border-top-right-radius: 2px
}

.subtab-styling__header-item--active {
	background-color: #fff;
	color: #1a1919;
	font-weight: 700;
	border-bottom: #f7921e 2px solid;
	width: 100%;
}

.subtab-styling__content-container {
	border-left: 1px solid #e5e5e5;
	border-right: 1px solid #e5e5e5
}

.subtab-styling__content-item {
	display: none;
	padding: 1rem
}

.subtab-styling__content-item--active {
	display: block
}		

.all-borders,
.all-borders tr,
.all-borders td {
	border: solid 1px #e5e5e5;
}

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