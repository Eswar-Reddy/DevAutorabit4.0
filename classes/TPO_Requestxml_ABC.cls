/*** Class added in Sunpower TPO Phase 1 -- 20/10/2013, To Generate ABCXml and Made a call in callABC ***/

global class TPO_Requestxml_ABC{/*
    
    Public String quoteId;
    Public String accountId;
    Public Quote qt;
//      Public Quote quote;
   // public List<System_Production__c> systemProd;
    Public List<Rental_Schedule__c> RentalSchedule = new List<Rental_Schedule__c>();
    Public Quote quotes;
    Public Account account1;

// Method is used to Generate ABC XML    
public void generateABCXml(String qtID, String actID,Decimal DealerFee,Decimal FitRate,Decimal FitEsc)   
    {        
        System.debug(LoggingLevel.error,'In generateABCXml method start');
        quoteId = qtID;
        accountId = actID;
        Integer cnt = 1;
        String Qinstalldate;
      
       try{
       
           
          quotes = [select id,
                                        //System_Cost__c ,
                                        Down_Payment__c,
                                         Start_Date__c,
                                         TPO_System_Size__c,
                                         Dealer_Fees__c,
                                         Total_Energy__c,
                                         Fit_Rate__c,
                                         Fit_Annual_Esc__c, 
                                        Feasibility_Indicator__c,
                                        Customer_s_DownPayment_1__c,
                                        Customer_s_DownPayment_2__c,
                                        Total_Yr_1_Production__c,
                                        System_Price__c,
                                      SystemCost_FR__c
                                        
                                      //  Quote.Accounts.PersonDepartment
                                       
                                        from Quote where id =: quoteId];

        
           account1 = [select Oracle_County__c from Account where id =: accountId];                            

         Decimal finalSystemCost=  Quotes.SystemCost_FR__c - Dealerfee;                        
       
          Xmlstreamwriter xmlW = new Xmlstreamwriter();
          
            xmlW.writeStartDocument('utf-8','1.0');
            
        xmlW.writeStartElement(null,'abc',null);
            xmlW.writeAttribute(null,null,'xmlns','http://www.warren-selbert.com');
            xmlW.writeAttribute(null,null,'xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');
            xmlW.writeStartElement(null,'username',null);
            xmlW.writeCharacters('spquote');
        xmlW.writeEndElement(); //Close username
        
        xmlW.writeStartElement(null,'password',null);
            xmlW.writeCharacters('qq101010');
        xmlW.writeEndElement(); //Close password
        
        xmlW.writeStartElement(null,'version',null);
            xmlW.writeCharacters('2');
        xmlW.writeEndElement(); //Close version
        
        xmlW.writeStartElement(null,'batch',null);
            xmlW.writeAttribute(null,null,'id','1');
            
            xmlW.writeStartElement(null,'filename',null);
                xmlW.writeCharacters(Label.FR_ABCInputFile);
            xmlW.writeEndElement(); //Close filename
            
          // String startDate= system.today().format();
          // Date dt = Date.parse(startDate);
            Datetime dt = system.today();
            string dtFrmt = dt.format('MM/dd/yyyy');
            xmlW.writeStartElement(null,'inputcommand',null);
            xmlW.writeAttribute(null,null,'name','APIInput');
            
              { 
                            xmlW.writeStartElement(null,'input',null);
                            xmlW.writeAttribute(null,null,'name','Start Date');
                            xmlW.writeCharacters(dtFrmt);
                            system.debug('ABC RequestXML - dtFrmt  : ' + dtFrmt );
                            //xmlW.writeCharacters(String.valueOf('8/23/2013'));
                            xmlW.writeEndElement(); //Close input
                        }   
                        
                        
                        { 
                            xmlW.writeStartElement(null,'input',null);
                            xmlW.writeAttribute(null,null,'name','Territory');
                            system.debug('ABC RequestXML - PersonDepartment  : ' + account1.Oracle_County__c );
                            if(account1.Oracle_County__c != null) 
                            {
                                xmlW.writeCharacters(String.valueOf(account1.Oracle_County__c));
                            }
                            else
                            {
                                xmlW.writeCharacters(String.valueOf('Lyonnew'));
                            }
                            xmlW.writeEndElement(); //Close input
                        }   
                 if(quotes != null)
                    {    system.debug('ABC RequestXML - Quote : ' + quotes );                   
                         
                        if(quotes.SystemCost_FR__c!= null)
                        {

                            xmlW.writeStartElement(null,'input',null);
                            xmlW.writeAttribute(null,null,'name','System Cost');
                            system.debug('ABC RequestXML - SystemCost_FR__c: ' + quotes.SystemCost_FR__c);
                            xmlW.writeCharacters(String.valueOf(finalSystemCost));
                            xmlW.writeEndElement(); //Close input
                        }
                        else
                        {
                            xmlW.writeStartElement(null,'input',null);
                            xmlW.writeAttribute(null,null,'name','System Cost');
                            xmlW.writeCharacters('22000');
                            xmlW.writeEndElement(); //Close input
                        }
                       
                       
                      
                        if(quotes.TPO_System_Size__c != null)
                        {

                            xmlW.writeStartElement(null,'input',null);
                            xmlW.writeAttribute(null,null,'name','System Size');
                            system.debug('ABC RequestXML - TPO_System_Size__c  : ' + quotes.TPO_System_Size__c );
                            xmlW.writeCharacters(String.valueOf(quotes.TPO_System_Size__c));
                            xmlW.writeEndElement(); //Close input
                        }
                        else
                        {

                            xmlW.writeStartElement(null,'input',null);
                            xmlW.writeAttribute(null,null,'name','System Size');
                            xmlW.writeCharacters('7');
                            xmlW.writeEndElement(); //Close input
                        }
                      
                          if(DealerFee != null)
                        { 
                            xmlW.writeStartElement(null,'input',null);
                            xmlW.writeAttribute(null,null,'name','Dealer Fees');
                            system.debug('ABC RequestXML - Dealer_Fees__c  : ' + quotes.Dealer_Fees__c );
                            xmlW.writeCharacters(String.valueOf(DealerFee));
                            xmlW.writeEndElement(); //Close input
                        }
                        else
                        {

                            xmlW.writeStartElement(null,'input',null);
                            xmlW.writeAttribute(null,null,'name','Dealer Fees');
                            xmlW.writeCharacters('15000');
                            xmlW.writeEndElement(); //Close input
                        }  
                       
                          if(quotes.Total_Yr_1_Production__c!= null)
                        {
                            xmlW.writeStartElement(null,'input',null);
                            xmlW.writeAttribute(null,null,'name','Total Yr1 Production');
                            system.debug('ABC RequestXML - Total_Energy__c  : ' + quotes.Total_Yr_1_Production__c);
                             xmlW.writeCharacters(String.valueOf(quotes.Total_Yr_1_Production__c));
                            xmlW.writeEndElement(); //Close input
                        }
                        
                 if(FitRate != null)
                        {   
                            xmlW.writeStartElement(null,'input',null);
                            xmlW.writeAttribute(null,null,'name','Fit Rate');
                            system.debug('ABC RequestXML - Fit_Rate__c  : ' + FitRate  );
                            xmlW.writeCharacters(String.valueOf(FitRate));
                            xmlW.writeEndElement(); //Close input
                            
                        }
                        else
                        {   
                            xmlW.writeStartElement(null,'input',null);
                            xmlW.writeAttribute(null,null,'name','Fit Rate');
                            xmlW.writeCharacters('0.3');
                            xmlW.writeEndElement(); //Close input
                            
                        }
                 
                   if(FitEsc != null)
                        {
                            xmlW.writeStartElement(null,'input',null);
                            xmlW.writeAttribute(null,null,'name','Fit Annual ESC');
                            system.debug('ABC RequestXML - Fit_Annual_Esc__c  : ' + FitEsc );
                            xmlW.writeCharacters(String.valueOf(FitEsc));
                            xmlW.writeEndElement(); //Close input
                        }
                        else
                        {
                            xmlW.writeStartElement(null,'input',null);
                            xmlW.writeAttribute(null,null,'name','Fit Annual ESC');
                            xmlW.writeCharacters('2');
                            xmlW.writeEndElement(); //Close input
                        }
                  }
            xmlW.writeEndElement(); //Close inputcommand
            xmlW.writeStartElement(null,'outputcommand',null);
            xmlW.writeAttribute(null,null,'name','APIOutput');
            
            xmlW.writeStartElement(null,'outputoption',null);
            xmlW.writeEndElement(); //Close outputoption

            xmlW.writeEndElement(); //Close outputcommand
            
            xmlW.writeEndElement(); //Close batch
            xmlW.writeEndElement(); //Close abc
           
            String xmlStringxmlReq1 = xmlW.getXmlString();           
            string xmlStringxmlReq = xmlStringxmlReq1.replaceAll('&'+'amp;','&');
                      
          //string endpoint = 'https://ws.wns-sb-cable.com/cgi-bin/ws.pl';
          // xmlW.close();
           system.debug(LoggingLevel.error,'###xmlRequest##### ABC' +xmlStringxmlReq +'<<<<<<<<<<<<<<<<<<<The END>>>>>>>>>>>>>>>');
           string xmlResponse = RequestABCCall(xmlStringxmlReq);
           system.debug(LoggingLevel.error,'###xmlResponse##### ABC' +xmlResponse);
           
           try{
               List<Attachment> attch = [select Id from Attachment where parentId=: quoteID and (name = 'ABC Request XML' or name = 'ABC Response XML')];
                 if(! attch.isEmpty())    
                    Delete attch;
           }catch(Exception e)
           {
                System.debug('Unable to delete the attachment : ' + e.getMessage());
           }
           
           List<Attachment> attachmentsList = new List<Attachment>();
           
           Attachment reqAttachment = new Attachment(name = 'ABC Request XML',parentId = QTID,body = Blob.valueOf(xmlStringxmlReq));
           
           Attachment resAttachment = new Attachment (name = 'ABC Response XML', parentId = QTID, body = Blob.valueOf(xmlResponse));
           
           attachmentsList.add(reqAttachment);
           attachmentsList.add(resAttachment);
           
           insert  attachmentsList;
           
           
          insertOutput(xmlResponse);
        }
        
       catch(Exception e){
           throw e;
        }
           
 }
 
 // Method is used to Get a Response for ABCXml Request
 public string  RequestABCCall(string Bodyreq){
           
            //string endpoint = 'https://ws.wns-sb-cable.com/cgi-bin/ws.pl'; //NA endpoint
            string endpoint = 'https://ws.wns-sb-t1.com/cgi-bin/ws.pl';
          
            system.debug('>>>++++>>>>'+Bodyreq);
            string responsebody;
            
                       
            try
            {
                HttpRequest req = new HttpRequest();
                req.setMethod('POST');
                req.setEndpoint(endpoint);
                req.setHeader('Content-Type', 'text/xml');
                req.setHeader('X-ws-apikey', Label.abcwsapikey);
                req.setTimeout(120000);
               
                req.setBody(Bodyreq);
               
                Http http = new Http();
                 if(!test.isRunningTest()){
                HttpResponse res = http.send(req);
               
                system.debug('>>> response >>>>'+res.getBody());
       
                XmlStreamReader reader1 = res.getXmlStreamReader();
                
                responsebody = res.getBody();
                }
                else{
                    responsebody = '<?xml version="1.0" encoding="utf-8" ?><batchoutput id="1"><output name="Avoided Cost of Power"><value>18</value></output><output name="Upfront Payment"><value>5000.00</value></output><output name="Monthly Rent Payments"><value>329.49</value><value>339.05</value><value>348.88</value><value>359.00</value><value>369.41</value><value>380.12</value><value>391.14</value><value>402.49</value><value>414.16</value><value>426.17</value><value>438.53</value><value>451.24</value><value>464.33</value><value>477.80</value><value>491.65</value><value>505.91</value><value>520.58</value><value>535.68</value><value>551.21</value><value>567.20</value></output><output name="Termination Payments"><value>62600.27</value><value>63220.10</value><value>59073.13</value><value>54481.50</value><value>49584.96</value><value>44378.17</value><value>38927.25</value><value>39035.12</value><value>38998.87</value><value>38793.06</value><value>38388.48</value><value>37751.55</value><value>36843.73</value><value>35620.73</value><value>34031.78</value><value>32018.58</value><value>29514.29</value><value>26442.25</value><value>22714.60</value><value>18230.61</value></output><output name="Monthly Rent Payment_A"><value>80.00</value></output><output name="Lease Implied Rate_A"><value>0.165</value></output><output name="Yr1 Savings_A"><value>5.0%</value></output><output name="Monthly Rent Payment_B"><value>250.00</value></output><output name="Lease Implied Rate_B"><value>0.165</value></output><output name="Yr1 Savings_B"><value>5.0%</value></output><output name="Down Payment_B"><value>1000.00</value></output><output name="Escalator_B"><value>2.0%</value></output><output name="Monthly Rent Payment_C"><value>250.00</value></output><output name="Lease Implied Rate_C"><value>0.165</value></output><output name="Yr1 Savings_C"><value>5.0%</value></output><output name="Down Payment_C"><value>1000.00</value></output><output name="Escalator_C"><value>2.0%</value></output><output name="System Price"><value>1000</value></output><output name="Feasibility Indicator"><value>1</value></output><output name="Payments to the Customer_1"><value>223.28</value><value>225.51</value><value>227.77</value><value>230.04</value><value>232.34</value><value>234.67</value><value>237.01</value><value>239.38</value><value>241.78</value><value>244.20</value><value>246.64</value><value>249.10</value><value>251.59</value><value>254.11</value><value>256.65</value><value>259.22</value><value>261.81</value><value>264.43</value><value>267.07</value><value>269.74</value>  </output><output name="Customer\''+'s Downpayment_1"><value>0.00</value></output><output name="TVs_1"><value>10837.42</value><value>10449.72</value><value>10008.35</value><value>9516.60</value><value>8977.44</value><value>8393.57</value><value>7767.51</value><value>7101.58</value><value>6398.03</value><value>5659.04</value><value>5295.41</value><value>4945.63</value><value>4616.92</value><value>3908.50</value><value>3191.12</value><value>2467.57</value><value>1654.71</value><value>742.95</value><value>-278.35</value><value>-1421.01</value></output><output name="Payments to the Customer_2"><value>223.28</value><value>225.51</value><value>227.77</value><value>230.04</value><value>232.34</value><value>234.67</value><value>237.01</value><value>239.38</value><value>241.78</value><value>244.20</value><value>246.64</value><value>249.10</value><value>251.59</value><value>254.11</value><value>256.65</value><value>259.22</value><value>261.81</value><value>264.43</value><value>267.07</value><value>269.74</value>  </output><output name="Customer\''+'s Downpayment_2"><value>0.00</value></output><output name="TVs_2"><value>10837.42</value><value>10449.72</value><value>10008.35</value><value>9516.60</value><value>8977.44</value><value>8393.57</value><value>7767.51</value><value>7101.58</value><value>6398.03</value><value>5659.04</value><value>5295.41</value><value>4945.63</value><value>4616.92</value><value>3908.50</value><value>3191.12</value><value>2467.57</value><value>1654.71</value><value>742.95</value><value>-278.35</value><value>-1421.01</value></output></batchoutput>';
                    //responsebody ='<?xml version="1.0" encoding="utf-8"?><abc><batchoutput id="1"><output name="Feasibility Indicator"><value>1</value></output><output name="System Price"><value>18454.53</value></output><output name="Payments to the Customer_1"><value>455.38</value><value>459.93</value><value>464.53</value><value>469.17</value><value>473.87</value><value>478.60</value><value>483.39</value><value>488.22</value><value>493.11</value><value>498.04</value><value>503.02</value><value>508.05</value><value>513.13</value><value>518.26</value><value>523.44</value><value>528.68</value><value>533.96</value><value>539.30</value><value>544.70</value><value>550.14</value></output><output name="Customer's Downpayment_1"><value>0.00</value></output><output name="TV1_VP1"><value>36530.76</value><value>34620.72</value><value>32710.68</value><value>30800.64</value><value>28890.60</value><value>26980.56</value><value>25070.52</value><value>23160.48</value><value>21250.44</value><value>19340.40</value><value>17430.36</value><value>15520.32</value><value>13610.28</value><value>11700.24</value><value>9790.20</value><value>7880.16</value><value>5970.12</value><value>4060.08</value><value>2150.04</value><value>240.00</value></output><output name="TV2_VP1"><value>37130.76</value><value>35220.72</value><value>33310.68</value><value>31400.64</value><value>29490.60</value><value>27580.56</value><value>25670.52</value><value>23760.48</value><value>21850.44</value><value>19940.40</value><value>18030.36</value><value>16120.32</value><value>14210.28</value><value>12300.24</value><value>10390.20</value><value>8480.16</value><value>6570.12</value><value>4660.08</value><value>2750.04</value><value>840.00</value></output><output name="Payments to the Customer_2"><value>0.00</value><value>0.00</value><value>0.00</value><value>0.00</value><value>0.00</value><value>0.00</value><value>0.00</value><value>0.00</value><value>0.00</value><value>0.00</value><value>0.00</value><value>0.00</value><value>0.00</value><value>0.00</value><value>0.00</value><value>0.00</value><value>0.00</value><value>0.00</value><value>0.00</value><value>0.00</value></output><output name="Customer's Downpayment_2"><value>0.00</value></output><output name="TV1_VP2"><value>36530.76</value><value>34620.72</value><value>32710.68</value><value>30800.64</value><value>28890.60</value><value>26980.56</value><value>25070.52</value><value>23160.48</value><value>21250.44</value><value>19340.40</value><value>17430.36</value><value>15520.32</value><value>13610.28</value><value>11700.24</value><value>9790.20</value><value>7880.16</value><value>5970.12</value><value>4060.08</value><value>2150.04</value><value>240.00</value></output><output name="TV2_VP2"><value>37130.76</value><value>35220.72</value><value>33310.68</value><value>31400.64</value><value>29490.60</value><value>27580.56</value><value>25670.52</value><value>23760.48</value><value>21850.44</value><value>19940.40</value><value>18030.36</value><value>16120.32</value><value>14210.28</value><value>12300.24</value><value>10390.20</value><value>8480.16</value><value>6570.12</value><value>4660.08</value><value>2750.04</value><value>840.00</value></output></batchoutput></abc>';
                }
            }
            catch ( Exception ex ) 
            {
                //string callerror = 'Error in call out'+ '  ' + ex.getMessage();
              //  system.debug('Https request failed due to'+callerror);
                throw ex;
                system.debug('--EX--');
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Exception' + ex);
                ApexPages.addMessage(errorMsg);
                throw ex;
            }

                return responsebody ;   

       
        }
        
// Method is used to Update Quote Details and Rental Schedule With ABCXml Response        
public void insertOutput(String response){



        try
        {
         List<Rental_Schedule__c> delRentalSched = [select id from Rental_Schedule__c
                                           where quote__c =: Quotes.id];
            delete delRentalSched;
        
            
            TG_XmlDom dom = new TG_XmlDom(response);
            
            TG_XmlNode root = dom.root; 
            
            List<TG_XmlNode> abcOutPut= root.getElementsByTagName('output'); 
            
            System.debug('abcOutPut is : ' + abcOutPut);
            
            String nodeName;
            
            String nodeVal;
            
            Integer Year=0;
            Integer Count=0;
            
            Map<String,String> attrib;
                
            for(TG_XMLNode node : abcOutPut)
            {
              if(node.getElementByTagName('output') != null)    
              {
                nodeVal = node.getElementByTagName('value').nodeValue ;
                attrib = node.attributes;
                System.debug(logginglevel.error,'node.attributes is : ' + attrib);
                System.debug(logginglevel.error,'nodeVal is : ' + nodeVal);
                 
                if(quotes != null)
                {
                    // to fill feasibility indicator at quote level
                    if(attrib.get('name') == 'Feasibility Indicator' )
                    {
                         
                         
                         quotes.Feasibility_Indicator__c = nodeVal ;
                          
                 
                         System.debug(logginglevel.error,' quotes.Feasibility_Indicator__c : ' + Decimal.valueof(node.getElementByTagName('value').nodeValue) );
                    }
                    // to fill system price at quote level
                    if(attrib.get('name') == 'System Price')
                    {
                         quotes.System_Price__c = Decimal.valueof(nodeVal) ;
                         System.debug(logginglevel.error,' quotes.System_Price__c : ' + Decimal.valueof(node.getElementByTagName('value').nodeValue) );
                    } 

                    if(attrib.get('name') == 'Customer\''+'s Downpayment_1')
                    {
                         quotes.Customer_s_DownPayment_1__c = Decimal.valueof(nodeVal) ;
                         System.debug(logginglevel.error,' quotes.Customer_s_DownPayment_1__c : ' + Decimal.valueof(node.getElementByTagName('value').nodeValue) );
                    }

                    if(attrib.get('name') == 'Customer\''+'s Downpayment_2')
                    {
                         quotes.Customer_s_DownPayment_2__c = Decimal.valueof(nodeVal) ;
                         System.debug(logginglevel.error,' quotes.Customer_s_DownPayment_2__c : ' + Decimal.valueof(node.getElementByTagName('value').nodeValue) );
                    }


                    
                    if ((attrib.get('name') =='Payments to the Customer_1' ))
                    {

                        Datetime dt = system.today();
                        string dtFrmt = dt.format('yyyy');
                        //Year = Integer.Valueof(dtFrmt);
                        Year = 1;
                        List<TG_XMLNode> PaymentstoCustomer1 = node.childNodes;
                            for(TG_XMLNode CustomerPayment1 : PaymentstoCustomer1)
                            {

                            //  System.debug('monthlyRentPayNode is : ' + monthlyRentPayNode);
                                System.debug('CustomerPayment1.nodetype is : ' + CustomerPayment1.nodetype);
                                 //if(cashFlow.size() > count ) {
                                    if(CustomerPayment1.nodeType == 1)
                                    {
                                      Rental_Schedule__c rentalSched = new Rental_Schedule__c ();
                                      rentalSched.Quote__c = quotes.id;
                                      rentalSched.Year__c = Year;
                                //    cashFlow[count].Monthly_Payment__c = node.getElementByTagName('value').nodevalue;
                                     // RentalSchedule[count].Quote__c = quotes.id;
                                     System.debug('CustomerPayment1.nodevalue is ' + CustomerPayment1.nodeValue);
                                     System.debug('CustomerPayment1.textContent is ' + CustomerPayment1.textContent );
                                    //  RentalSchedule[count].Payments_to_the_customer_1__c = Decimal.valueof(CustomerPayment1.nodeValue);
                                      rentalSched.Payments_to_the_customer_1__c = Decimal.valueof(CustomerPayment1.nodeValue);
                                      rentalSched.Customer_Downpayment_Type__c = 'DownPayment1';
                                      //System.debug('CustomerPayment1.textContent is ' + CustomerPayment1.textContent );
                                    System.debug( '==value1Payments_to_the_customer_1__c=='+rentalSched.Payments_to_the_customer_1__c); 
                                    RentalSchedule.add(rentalSched);
                                    Year ++;
                                    }
                                 //}
                                
                            }

                    }

                    if ((attrib.get('name') =='Payments to the Customer_2' ))
                    {
                        

                        Datetime dt = system.today();
                        string dtFrmt = dt.format('yyyy');
                        //Year = Integer.Valueof(dtFrmt);
                        Year = 1;
                        List<TG_XMLNode> PaymentstoCustomer1 = node.childNodes;
                            for(TG_XMLNode CustomerPayment1 : PaymentstoCustomer1)
                            {

                            //  System.debug('monthlyRentPayNode is : ' + monthlyRentPayNode);
                                System.debug('CustomerPayment2.nodetype is : ' + CustomerPayment1.nodetype);
                                 //if(cashFlow.size() > count ) {
                                    if(CustomerPayment1.nodeType == 1)
                                    {
                                      Rental_Schedule__c rentalSched = new Rental_Schedule__c ();
                                      rentalSched.Quote__c = quotes.id;
                                      rentalSched.Year__c = Year;
                                //    cashFlow[count].Monthly_Payment__c = node.getElementByTagName('value').nodevalue;
                                     // RentalSchedule[count].Quote__c = quotes.id;
                                     System.debug('CustomerPayment2.nodeValue is ' + CustomerPayment1.nodeValue);
                                     System.debug('CustomerPayment2.textContent is ' + CustomerPayment1.textContent );
                                    //  RentalSchedule[count].Payments_to_the_customer_1__c = Decimal.valueof(CustomerPayment1.nodeValue);
                                      rentalSched.Payments_to_the_customer_1__c = Decimal.valueof(CustomerPayment1.nodeValue);
                                      rentalSched.Customer_Downpayment_Type__c = 'DownPayment2';
                                      //System.debug('CustomerPayment1.textContent is ' + CustomerPayment1.textContent );
                                    System.debug( '==value1Payments_to_the_customer_2__c=='+rentalSched.Payments_to_the_customer_1__c); 
                                    RentalSchedule.add(rentalSched);
                                    Year ++;
                                    }
                                 //}
                                
                            }

                    }
                    //Modified Code -- Sunpower TPO TV2 Requirement -- 10/03/2014
                    // Payment Customer1 TV1 Values
                    //if ((attrib.get('name') =='TVs_1' ))
                    if ((attrib.get('name') =='TV1_VP1' ))
                    {
                        count = 0;
                        List<TG_XMLNode> TV1_VP1 = node.childNodes;
                            for(TG_XMLNode singleTV1 : TV1_VP1)
                            {
                            //  System.debug('monthlyRentPayNode is : ' + monthlyRentPayNode);
                                System.debug('singleTV1.nodetype for TV1_VP1 is : ' + singleTV1.nodetype);
                                 //if(cashFlow.size() > count ) {
                                    if(singleTV1.nodeType == 1)
                                    {
                                //    cashFlow[count].Monthly_Payment__c = node.getElementByTagName('value').nodevalue;
                                      RentalSchedule[count].TVs_1__c = Decimal.valueof(singleTV1.textContent);
                                      System.debug('singleTV1.textContent for TV1_VP1 is ' + singleTV1.textContent );
                                    system.debug( '==value1TV1_VP1=='+RentalSchedule[count].TVs_1__c); 
                                    count ++;
                                    }
                                 //}
                                
                            }

                    }
                    // Payment Customer1 TV2 Values 
                    //if ((attrib.get('name') =='TVs_2' ))
                    if ((attrib.get('name') =='TV2_VP1' ))
                    {
                        count = 0;
                        List<TG_XMLNode> TV2_VP1 = node.childNodes;
                            for(TG_XMLNode singleTV2 : TV2_VP1)
                            {
                            //  System.debug('monthlyRentPayNode is : ' + monthlyRentPayNode);
                                System.debug('singleTV2.nodetype for TV2_VP1 is : ' + singleTV2.nodetype);
                                 //if(cashFlow.size() > count ) {
                                    if(singleTV2.nodeType == 1)
                                    {
                                //    cashFlow[count].Monthly_Payment__c = node.getElementByTagName('value').nodevalue;
                                      RentalSchedule[count].TVs_2__c = Decimal.valueof(singleTV2.textContent);
                                      System.debug('singleTV2.textContent for TV2_VP1 is ' + singleTV2.textContent );
                                    system.debug( '==value1TV2_VP1=='+RentalSchedule[count].TVs_2__c); 
                                    count ++;
                                    }
                                 //}
                                
                            }

                    }
                    //End Modified Code -- Sunpower TPO TV2 Requirement -- 10/03/2014

                     //New Code -- Sunpower TPO VP2 -- 10/04/2014
                    // VP2 TV1 Values
                    if ((attrib.get('name') =='TV1_VP2' ))
                    {
                        count = 20;
                        List<TG_XMLNode> TV2_VP1 = node.childNodes;
                            for(TG_XMLNode singleTV1 : TV2_VP1)
                            {
                            //  System.debug('monthlyRentPayNode is : ' + monthlyRentPayNode);
                                System.debug('singleTV1.nodetype for TV1_VP2 is : ' + singleTV1.nodetype);
                                 //if(cashFlow.size() > count ) {
                                    if(singleTV1.nodeType == 1)
                                    {
                                //    cashFlow[count].Monthly_Payment__c = node.getElementByTagName('value').nodevalue;
                                      RentalSchedule[count].TVs_1__c = Decimal.valueof(singleTV1.textContent);
                                      System.debug('singleTV1.textContent for TV1_VP2 is ' + singleTV1.textContent );
                                    system.debug( '==value1TV1_VP2=='+RentalSchedule[count].TVs_1__c); 
                                    count ++;
                                    }
                                 //}
                                
                            }

                    }

                    // VP2 TV2 Values
                    if ((attrib.get('name') =='TV2_VP2' ))
                    {
                        count = 20;
                        List<TG_XMLNode> TV2_VP2 = node.childNodes;
                            for(TG_XMLNode singleTV2 : TV2_VP2)
                            {
                            //  System.debug('monthlyRentPayNode is : ' + monthlyRentPayNode);
                                System.debug('singleTV2.nodetype for TV2_VP2 is : ' + singleTV2.nodetype);
                                 //if(cashFlow.size() > count ) {
                                    if(singleTV2.nodeType == 1)
                                    {
                                //    cashFlow[count].Monthly_Payment__c = node.getElementByTagName('value').nodevalue;
                                      RentalSchedule[count].TVs_2__c = Decimal.valueof(singleTV2.textContent);
                                      System.debug('singleTV2.textContent for TV2_VP2 is ' + singleTV2.textContent );
                                    system.debug( '==value1TV2_VP2=='+RentalSchedule[count].TVs_2__c); 
                                    count ++;
                                    }
                                 //}
                                
                            }

                    }
                    //End New Code -- Sunpower TPO VP2 -- 10/04/2014
                              
                }
               }
              } 
            upsert quotes;
            upsert RentalSchedule;
            
             
            System.debug(Logginglevel.error,'Limits.getScriptStatements : ' + Limits.getScriptStatements());
            }
            catch(DMLException e)
            {
                throw e;
                system.debug('ABC Request XML Error : ' + e.getMessage());
            }
            catch(Exception e){
                throw e;
            }
            
   }
 */
 }