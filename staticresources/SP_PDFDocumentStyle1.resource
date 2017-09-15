/**
* This file has been copied from SP_PDFDocumentStyle.css, only the bottom margin has been increased for first Page
*
* @author	Sarvinder Singh Sandhu
* @version	11-14-2012
*
*/
@page { 
	size: A4;
		
	margin-top: 100px;
	margin-bottom: 80px;
	
	@top-left {
		content: element(header_left);
	}
	
	@top-center {
		content: element(header_center);
	}
	
	@top-right {
		content: element(header_right);
	}
	
	@bottom-left {
		content: element(footer_left);
	}
	
	@bottom-center {
		content: element(footer_center);
	}
	
	@bottom-right {
		content: element(footer_right);
	}
}


@page :first {
  	margin-bottom: 210px;    /* Top margin on first page 10cm */
}

.header_left {
	text-align: left;
    position: running(header_left);
}

.header_center{
	text-align: center;
	position: running(header_center);
}

.header_right {
	text-align: right;
	position: running(header_right);
}

.footer_left {
	text-align: left;
	position: running(footer_left);
}

.footer_center {
	text-align: center;
	position: running(footer_center);
}

.footer_right {
	text-align: right;
	position: running(footer_right);
}

.pageNumber:before {
	content: counter(page); 
}

.pageCount:before {
	content: counter(pages);  
}