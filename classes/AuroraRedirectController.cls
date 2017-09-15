public with sharing class AuroraRedirectController {
    public Boolean isPartnerUser {get; private set;}
    public String siteId {get; private set;}
    public String designId {get; private set;}
    
    @TestVisible private String errorDesc;
    
    public AuroraRedirectController() {
        isPartnerUser = SPCommunityUtility.isPartnerUser();
    }
    
    public PageReference redirectToAurora() {
        PageReference pr;
        List <String> errors = new List <String>();
        
        // Create a savepoint to rollback all dmls if there are errors
        Savepoint sp;
        
        User currentUser = AuroraAPIUtil.getUser(UserInfo.getUserId());

        siteId = ApexPages.CurrentPage().getParameters().get('siteId');
        designId = ApexPages.CurrentPage().getParameters().get('designId');
        system.debug('siteId: ' + siteId);
        system.debug('designId: ' + designId);

        // initiate spectrum debug log
        AuroraAPIUtil.SpectrumLog sLog = new AuroraAPIUtil.SpectrumLog();
        AuroraAPIUtil.SpectrumLogParams slParams = new AuroraAPIUtil.SpectrumLogParams();
        slParams.siteId = siteId;
        slParams.designId = designId;

        try {
            if (String.IsNotBlank(designId)) {
                Design__c design = AuroraAPIUtil.getDesign(designId);
                if (design.Id != null) {
                    if (design.Roof_Design__r.Design_DesignId__c != null) {
                        // existing design
                        AuroraDesignAPI.GetDesignPageRequest request = new AuroraDesignAPI.GetDesignPageRequest();
                        request.auroraDesignId = design.Roof_Design__r.Design_DesignId__c;
                        AuroraDesignAPI.GetDesignPageResponse response = AuroraDesignAPI.getDesignPage(request);
                        if (response.errorMessageList.size() > 0) {
                            for (String errMsg : response.errorMessageList) {
                                errors.add(errMsg);
                            }
                        } else {
                            pr = response.designPageReference;
                        }
                    } else {
                        // new project if not available
                        String auroraProjectId = getAuroraProjectId(currentUser, design);
                        if (String.IsBlank(auroraProjectId)) {
                            AuroraProjectAPI.CreateProjectRequest request = new AuroraProjectAPI.CreateProjectRequest();
                            request.siteId = design.Site__c;
                            AuroraProjectAPI.CreateProjectResponse response = AuroraProjectAPI.CreateProject(request);
                            if (response.errorMessageList.size() > 0) {
                                for (String errMsg : response.errorMessageList) {
                                    errors.add(errMsg);
                                }
                                // write spectrum log
                                slParams.siteId = design.Site__c;
                                slParams.jsonPayload = response.httpReq.getBody();
                                slParams.response = response.httpRes.getBody();
                                slParams.responseStatusCode = response.httpRes.getStatusCode();
                                slParams.service = 'AuroraProjectAPI';
                                sLog.logList.add(sLog.getLog(slParams));
                            } else {
                                auroraProjectId = response.auroraProjectId;
                            }                       
                        }
                        if (String.IsNotBlank(auroraProjectId)) {
                            // new design
                            AuroraDesignAPI.CreateDesignRequest designRequest = new AuroraDesignAPI.CreateDesignRequest();
                            designRequest.auroraProjectId = auroraProjectId;
                            designRequest.designId = design.Id;
                            AuroraDesignAPI.CreateDesignResponse designResponse = AuroraDesignAPI.CreateDesign(designRequest);
                            if (designResponse.errorMessageList.size() > 0) {
                                for (String errMsg : designResponse.errorMessageList) {
                                    errors.add(errMsg);
                                }
                                // write spectrum log
                                slParams.designId = design.Id;
                                slParams.jsonPayload = designResponse.httpReq.getBody();
                                slParams.response = designResponse.httpRes.getBody();
                                slParams.responseStatusCode = designResponse.httpRes.getStatusCode();
                                slParams.service = 'AuroraDesignAPI';
                                sLog.logList.add(sLog.getLog(slParams));
                            } else {
                                // all callouts are completed. now do DML
                                sp = Database.setSavepoint();
                                doDesignDML(currentUser, design, auroraProjectId, designResponse.auroraDesignId);
                                pr = designResponse.designPageReference;
                            }
                        }
                    }
                } else {
                    errors.add('Salesforce design record not found for designId: ' + designId);
                }
            } else if (String.IsNotBlank(siteId)) {
                Site_Information_Form__c site = AuroraAPIUtil.getSite(siteId);
                if (site.Id != null) {
                    String auroraProjectId = getAuroraProjectId(currentUser, site);
                    if (String.IsNotBlank(auroraProjectId)) {
                        // existing project
                        AuroraProjectAPI.GetProjectPageRequest request = new AuroraProjectAPI.GetProjectPageRequest();
                        request.auroraProjectId = auroraProjectId;
                        AuroraProjectAPI.GetProjectPageResponse response = AuroraProjectAPI.getProjectPage(request);
                        if (response.errorMessageList.size() > 0) {
                            for (String errMsg : response.errorMessageList) {
                                errors.add(errMsg);
                            }
                        } else {
                            pr = response.projectPageReference;
                        }
                    } else {
                        // new project
                        AuroraProjectAPI.CreateProjectRequest request = new AuroraProjectAPI.CreateProjectRequest();
                        request.siteId = site.Id;
                        AuroraProjectAPI.CreateProjectResponse response = AuroraProjectAPI.CreateProject(request);
                        if (response.errorMessageList.size() > 0) {
                            for (String errMsg : response.errorMessageList) {
                                errors.add(errMsg);
                            }
                            // write spectrum log
                            slParams.siteId = site.Id;
                            slParams.jsonPayload = response.httpReq.getBody();
                            slParams.response = response.httpRes.getBody();
                            slParams.responseStatusCode = response.httpRes.getStatusCode();
                            slParams.service = 'AuroraProjectAPI';
                            sLog.logList.add(sLog.getLog(slParams));
                        } else {
                            sp = Database.setSavepoint();
                            doSiteDML(currentUser, site, response.auroraProjectId);
                            pr = response.projectPageReference;
                        }
                    }
                } else {
                    errors.add('Salesforce site record not found for siteId: ' + siteId);
                }
            }
        } catch(Exception e) {
            if (sp != null) {
                Database.rollback(sp);
            }
            errors.add(e.getMessage());
            // write spectrum log
            slParams.response = e.getMessage();
            sLog.logList.add(sLog.getLog(slParams));
        }

        // write spectrum log
        if (sLog.logList.size() > 0) {
            try {
                sLog.insertLog();
            } catch(Exception e) {
                errorMessage(e.getMessage());
            }
        }
        
        if (errors.size() > 0) {
            for (String error : errors) {
                system.debug('error: ' + error);
            }
            pr = Page.AuroraRedirectMessage;
            pr.setRedirect(true);
        }

        return pr;
    }
    
    private static String getAuroraProjectId(User currentUser, Site_Information_Form__c site) {
        String auroraProjectId;    
        if (currentUser.ContactId != null) {
            // external user
            auroraProjectId = site.External_Project_Id__c;
        } else {
            // internal user
            auroraProjectId = site.Internal_Project_Id__c;
        }
        return auroraProjectId;    
    }

    private static String getAuroraProjectId(User currentUser, Design__c design) {
        String auroraProjectId;    
        if (currentUser.ContactId != null) {
            // external user
            auroraProjectId = design.Site__r.External_Project_Id__c;
        } else {
            // internal user
            auroraProjectId = design.Site__r.Internal_Project_Id__c;
        }
        return auroraProjectId;    
    }
    
    private static void doSiteDML(User currentUser, Site_Information_Form__c site, String auroraProjectId) {
        if (currentUser.ContactId != null) {
            // external user
            site.External_Project_Id__c = auroraProjectId;
        } else {
            // internal user
            site.Internal_Project_Id__c = auroraProjectId;
        }
        update site;
    }
    
    private static void doDesignDML(User currentUser, Design__c design, String auroraProjectId, String auroraDesignId) {
        Roof_Design__c roofDesign = new Roof_Design__c();
           
        roofDesign.Design__c = Design.Id;   
                      
        if (design.Roof_Design__c != null) {            
            roofDesign = AuroraAPIUtil.getRoofDesign(design.Roof_Design__c);
        }
        roofDesign.Design_DesignId__c = auroraDesignId;
        if (roofDesign.Id == null) {      
            roofDesign.RecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Roof_Design__c.SobjectType).get('Commercial_Design');
                        
            insert roofDesign;
            design.Roof_Design__c = roofDesign.Id;
            update design;
        } else {
            update roofDesign;
        }
        if (currentUser.ContactId != null) {
            // external user
            if (design.Site__r.External_Project_Id__c != auroraProjectId) {
                design.Site__r.External_Project_Id__c = auroraProjectId;
                update design.Site__r;
            }
        } else {
            // internal user
            if (design.Site__r.Internal_Project_Id__c != auroraProjectId) {
                design.Site__r.Internal_Project_Id__c = auroraProjectId;
                update design.Site__r;
            }
        }
    }

    private void errorMessage(String msg) {
        errorDesc = msg;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
    }

}