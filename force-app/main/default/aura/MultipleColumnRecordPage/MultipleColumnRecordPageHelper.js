({
    doInit : function(component, event, helper) {
		/**
		 * Server call to fetch the Object and Fieldset details  
		 */
        var action = component.get('c.getFieldSetMember');
        action.setParams({ strFieldSetName : component.get('v.fieldsetName') ,
                           numColumns : component.get("v.numOfColumns") ,
                           recordId : component.get("v.recordId") });
                           
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var serverResult = response.getReturnValue();
                var fieldDataFromApex = serverResult.fieldAPIAccessMap;
                var fieldSetList = component.get('v.fieldsList');
                for(var key in fieldDataFromApex) {
                    fieldSetList.push({value:fieldDataFromApex[key], key:key});
                }
                component.set('v.renderRecordViewForm', true);
                component.set('v.renderRecordEditForm', false);
                component.set('v.sObjectName',serverResult.sObjectName);
                component.set('v.fieldsList',fieldSetList);
                component.set('v.cardTitle',serverResult.objectLabel);
                component.set('v.iconUrl',serverResult.objectIcon);
                var checkCol = component.get("v.numOfColumns");
                var viewModeColStyle = 'slds-col slds-size_1-of-1'+' slds-medium-size_1-of-'+checkCol+' slds-large-size_1-of-'+checkCol+' slds-list_horizontal';
                var editModeColStyle = 'slds-col slds-size_1-of-1'+' slds-medium-size_1-of-'+checkCol+' slds-large-size_1-of-'+checkCol;
                component.set('v.viewModeColStyle',viewModeColStyle);
                component.set('v.editModeColStyle',editModeColStyle);
            }
            else if(state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } 
                else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    editRecord : function(component, event, helper) {
        component.set('v.renderRecordViewForm', false);
        component.set('v.renderRecordEditForm', true);
    },
    handleSave: function(component, event, helper) {
        component.find("editForm").submit();
        component.set('v.renderRecordViewForm', true);
        component.set('v.renderRecordEditForm', false);
    },
    handleCancel: function(component, event, helper) {
        component.set('v.renderRecordViewForm', true);
        component.set('v.renderRecordEditForm', false);
    }
})