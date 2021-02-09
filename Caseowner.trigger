trigger Caseowner on Case (before update) {
    
    
    Map<Id,Case> updatedcaseMap=new Map<Id,Case>();
    for(case c:Trigger.New){
        if(c.status != Trigger.oldMap.get(c.Id).status){
            updatedcaseMap.put(c.Id,c);
        }
        
    }
    if(updatedcaseMap!=null){
    casehandler.updateownercase(updatedcaseMap,Trigger.oldMap);
    }
}