public class InstallerWrapper{

public Boolean bSelected;
public Account insAcc{ get { return insAcc;} set {insAcc = value;} }
public Boolean propSelected { get { return bSelected; } set { bSelected= value; } }
public String propBillingAddress {get; set;}

    public InstallerWrapper(Account installerAcc, Boolean installerSelected)
    {
        bSelected = installerSelected;
        insAcc = installerAcc;
        if(installerAcc.BillingStreet != null)
            propBillingAddress = installerAcc.BillingStreet;
        if(installerAcc.BillingCity != null)
            propBillingAddress +=  ', ' + installerAcc.BillingCity;
        if(installerAcc.BillingState != null)
            propBillingAddress +=  ', ' + installerAcc.BillingState;
        if(installerAcc.BillingPostalCode != null)
            propBillingAddress += '  ' +installerAcc.BillingPostalCode;
    }
 }