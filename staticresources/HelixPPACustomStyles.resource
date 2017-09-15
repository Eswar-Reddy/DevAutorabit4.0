/*
Helix PPA Custom Style Sheet
*/

/*COLORS, FONTS, and CURSORS*/
.hand {
	cursor: pointer;
}
.tiny-bold {
    font-weight: bold;
    font-size: smaller;
}
.large-font {
    font-size: 1.5rem;
}
.big-bold-center {
    font-size:3rem;
    margin-left: auto;
    margin-right: auto;
}
.sunpower-style h4 {
    margin-bottom: 6px;
}
.sunpower-style h5 {
    margin-bottom: 4px;
}
.sunpower-style .form-group label {
    font-size: 14px;
}
.sunpower-style .radio label span {
    margin-right: 0.1rem;
    font-size: 0.75rem;
}
.sunpower-style .radio label span:before {
    font-size: 1.7rem;
    text-align: center;
    line-height: .8rem;
    border-radius: 50%;
}
.sunpower-style .radio label input[type=radio]:checked + span:before {
    color: #0076be;
}
.sunpower-style .image-icon-tooltip {
    vertical-align: bottom;
    width: 1.25rem;
    height: 1.25rem;
}
.sunpower-style a,
.sunpower-style a:focus, 
.sunpower-style a:hover {
    text-decoration: none;
}


/*MARGINS, SPACING, and PADDING*/
.lower4 {
    margin-bottom: 4rem;
}
.lower2 {
	margin-bottom: 2rem;
}
.lower1 {
    margin-bottom: 1rem;
}
.upper2 {
	margin-top: 2rem;
}
.right1 {
	margin-right: .75rem !important;
}
.no-padding {
    padding-right: 0px;
    padding-left: 0px;
}   
.img-sizing {
    height: 1.5rem !important;
    width: auto !important;
}
.divider {
    border-bottom: 2px solid #0076be;
    margin-bottom: 2rem;
}
.grey-divider {
    border-bottom: 1px solid #e5e5e5;
    margin-bottom: 2rem;
}


/*Page Padding*/
@media all and (max-width: 1250px) {
    .sunpower-style {
        padding-left: 2rem;
        padding-right: 2rem;
    }
}

@media all and (max-width: 1024px) {
    /* styles for narrow desktop browsers and iPad landscape */
    .sunpower-style {
        margin-left: auto !important; 
        margin-right: auto !important;
        padding-left: 1rem;
        padding-right: 1rem;
    }
}

@media all and (max-width: 768px) {
    /* styles for narrower desktop browsers and iPad portrait */
    .sunpower-style {
        padding-left: 2rem;
        padding-right: 2rem;
        margin-left: none;
        margin-right: none;
    }
}

@media all and (max-width: 480px) {
    /* styles for iPhone/Android landscape (and really narrow browser windows) */
    .sunpower-style {
        padding-left: 1rem;
        padding-right: 1rem;
        margin-left: none;
        margin-right: none;
    }
}

/*TYPEAHEAD SPECIAL*/
.suggest-name {
    display: block;
    color: #9b9b9b;
}

.suggest-holder {
    list-style: none;
    margin: 0;
    padding: 0;
    width: 100%;
}

.suggest-holder ul {
    display: none;
    list-style: none;
    margin: 0;
    -webkit-padding-start: 0px;          
    position: absolute;
    overflow: hidden;
    background: #fff;
    border: 1px solid #f7921e;
    border-top: none;
}

.suggest-holder span {
    padding: 1em;
    white-space: nowrap;
    text-overflow: ellipsis;
}

.suggest-holder li:hover, li.active {
    background: #ffdfb8;
    cursor: pointer;
}

.suggest-holder span:hover {
    color: #1a1919;
}