({
	doInit : function(component, event, helper) {
        component.set("v.recordId", component.get("v.recordId"));
        helper.doInit(component, event, helper);
    },
    editRecord : function(component, event, helper) {
        helper.editRecord(component, event, helper);
    }, 
    handleSave: function(component, event, helper) {
        helper.handleSave(component, event, helper);
    },
    handleCancel: function(component, event, helper) {
        helper.handleCancel(component, event, helper);
    }
})