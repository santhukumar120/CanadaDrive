public class casehandler {
    
    public static void updateownercase(Map<Id,Case> c,Map<Id,Case> oldcaseMap){
        
        Map<String,String> casestatusVsUsernames=new Map<String,String>();        
        for(Case_Owner__mdt cmd:[select Id,masterLabel,Type__c from Case_Owner__mdt]){
            casestatusVsUsernames.put(cmd.Type__c,cmd.masterLabel);
            System.debug('Case Status VS Username: '+casestatusVsUsernames );
        }
        
        Map<String,String> caseIdVsUsernames=new Map<string,string>();        
        if(c.values()!=null)
        {
            for(Case newcase:c.values()){
                if(casestatusVsUsernames.containsKey(newcase.status))
                {
                    caseIdVsUsernames.put(newcase.Id,casestatusVsUsernames.get(newcase.status));
                }
            }
        }
        system.debug('Case id vs user name :'+ caseIdVsUsernames);
        
        
        Map<String,Id> usernameVsuserId=new Map<String,Id>();
        if(caseIdVsUsernames.values()!=null)
        {
            for(User u:[select Id,username from User where username in :caseIdVsUsernames.values()])
            {
                usernameVsuserId.put(u.username,u.Id); 
            }            
        }
        System.debug('user names vs User ids:'+ usernameVsuserId);
        
        Map<String,Case> mailMap=new Map<String,Case>();
        for(Case cas:c.values()){
            cas.ownerId=usernameVsuserId.get(caseIdVsUsernames.get(cas.id));
            cas.previous_owner__c=oldcaseMap.get(cas.id).ownerid;
            
            mailMap.put(oldcaseMap.get(cas.id).ownerid,cas);
        }
        if(mailMap.size()!=0)
        {
            EmailTemplate et= [select id,Subject,HtmlValue,Body from EmailTemplate where name ='Case owner change Notification'];
            for(String str:mailMap.keySet()){
                sendEmailtoOwner(mailMap.get(str),et);
            }  
        }
        
        
    }
    public static void sendEmailtoOwner(case c,EmailTemplate et){
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
        String mailHtmlBody = et.HtmlValue;
        mailHtmlBody=mailHtmlBody.replace('{!Case.CaseNumber}', c.caseNumber);
        mailHtmlBody=mailHtmlBody.replace('{!Case.OwnerId}', c.ownerId);
        mailHtmlBody=mailHtmlBody.replace('{!Case.Previous_Owner__c}', c.previous_owner__c);
        String mailSubject = et.Subject;
        msg.setHtmlBody(mailHtmlBody);
        msg.setSubject(mailSubject);
        msg.setTargetObjectId(c.ownerId);
        msg.setSaveAsActivity(false);
        msgList.add(msg);
        Messaging.sendEmail(msgList); 
    }
}