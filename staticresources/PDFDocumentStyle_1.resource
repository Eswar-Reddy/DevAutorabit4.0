/**
* Custom CSS Stylesheet that utilizes CSS 3.0 techniques to create repeating headers
* when applied to a PDF that is rendered from a Salesforce Visualforce page.
*
* @author	John De Santiago
* @version	2010-09-23
*
* Liability and Warranty Disclaimer: This script is provided "as is" and without any warranties 
* as to performance or merchantability, or any other warranties, whether expressed or implied. 
* All scripts are supplied free but are unsupported. Do enjoy!
*/
@page
{
	
	size: 8.27in 11.69in;/* width height */
	margin-right: 30px;
	margin-left: 60px;
	margin-top: 20px;
	margin-bottom: 130px;	

	


	@top-left {
		content: element(header_left, first-except);
	}
	
	@top-center {
		content: element(header_center, first-except);
	}
	
	

	@top-right {
		content: element(header_right, first-except);
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

.header_left {
	
	margin-left: 60px;
        position: running(header_left);
}

.header_center{
	margin-left: 100px;
	
	position: running(header_center);
}



.header_right {
	margin-left: 500px;
	
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
	font-size:10px;
	position: running(footer_right);
}

.pageNumber:before {
	content: counter(page); 
}

.pageCount:before {
	content: counter(pages);  
}

p{
   margin:8px;
}

.even
{
	background-color:#F5F5F5;
}
