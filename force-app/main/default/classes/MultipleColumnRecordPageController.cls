/**
 * This class is invoked from the Aura component named MultipleColumnRecordPage
 * Server call is made through this class to get the details of the specific object
 **/
public class MultipleColumnRecordPageController {
 	/**
     * This method makes a server call to get all the field set information required to be displayed on the UI
     * It also gets the Object Icon specified at the object level in the org
     **/
    @AuraEnabled(cacheable = true)
    public static MultipleColumnRecordPageController.FinalWrapperClass getFieldSetMember(String strFieldSetName, Integer numColumns, ID recordId) {
		String sObjName = recordId.getSObjectType().getDescribe().getName();
        String objLabel = String.valueOf(sObjName).replace('__c','').replace('_',' ');
        String objIcon = getIconUrl(String.valueOf(sObjName));

        Schema.SObjectType sObj = Schema.getGlobalDescribe().get(sObjName);
        Map<String, String> mapFieldInformation=new Map<String, String>();
        if(!String.isEmpty(strFieldSetName)) {
         	for(Schema.FieldSetMember fieldMember : sObj.getDescribe().fieldSets.getMap().get(strFieldSetName).getFields()) {
                String fieldAPIName = fieldMember.getFieldPath();
                /**
                 * Check whether field is updatable
				 **/
                Boolean accessCheck = sObj.getDescribe().fields.getMap().get(fieldMember.getFieldPath()).getDescribe().isUpdateable();
                /**
                 * Create a map of fieldApiName and a String which indicates whether the field is readonly 
				 **/
                if(accessCheck) { 
                	mapFieldInformation.put(fieldAPIName, 'updateable');	
                } else {
                    mapFieldInformation.put(fieldAPIName, 'readonly');	
                }              
            }   
        }  
        
        FinalWrapperClass objFinalWrapperClass = new FinalWrapperClass();
        objFinalWrapperClass.sObjectName = sObjName;
        objFinalWrapperClass.objectLabel = objLabel;
        objFinalWrapperClass.objectIcon = objIcon;
        objFinalWrapperClass.fieldAPIAccessMap = mapFieldInformation;
        return objFinalWrapperClass; 
    }
    
	/**
	 * Set Icon Name/URL
	 **/
    public static String getIconUrl(String objAPIName) {
    	String iconUrl;
    	List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();    	
		for(Schema.DescribeTabSetResult tsr : tabSetDesc) {
			List<Schema.DescribeTabResult> tabs = tsr.getTabs();		
			for(Schema.DescribeTabResult tr : tabs) {
				if(tr.getSobjectName() == objAPIName) {
					List<Schema.DescribeIconResult> icons = tr.getIcons();					
					for(Schema.DescribeIconResult ir : icons) {	 
						if(ir.getContentType() == 'image/svg+xml') {
							iconUrl = ir.getUrl();
							break;
						}
					}		           
				}			
			}			
		}
		
		if (iconUrl != null && iconUrl.contains('custom')) {
			Integer s = iconUrl.indexOf('/custom/') + '/custom/'.length();
			Integer e = iconUrl.length() - 4;
			iconUrl = 'custom:' + iconUrl.substring(s, e);
		}
		
		if (iconUrl != null && iconUrl.contains('standard')) {
			Integer s = iconUrl.indexOf('/standard/') + '/standard/'.length();
			Integer e = iconUrl.length() - 4;
			iconUrl = 'standard:' + iconUrl.substring(s, e);		
		}
		return iconUrl;	
	}

    public class FinalWrapperClass {
        @AuraEnabled
        public String sObjectName 						 { get; set; } 
        @AuraEnabled
        public String objectLabel 						 { get; set; }
        @AuraEnabled
        public String objectIcon 						 { get; set; }
        @AuraEnabled 
        public Map<String, String> fieldAPIAccessMap { get; set; }
    }
}