public class CaseSearch {
    
    public Boolean canRender{get;set;}
    public case objCs {get; set;}
    public string cn{get; set;}
    
     public CaseSearch(ApexPages.StandardController sc)
    {
       
        objCs = new case();		
    }
    public CaseSearch(){}
    public string searchValue
    {
        get
        {
            if(searchValue == null)
                searchValue = '';
            return searchValue;
        }
        set;
    }
    
    public case searchResults
    {
        get
        {
            if(searchResults == null){
                searchResults = new case();// case initilization
                system.debug('searchResults'+searchResults);
            }
            
            return searchResults;
        }
        set;
    }
    
    
    public void searchCases()
    {
        canRender=true;
        if(searchValue == '')
        {
            canRender=false;
            return;
        }
        System.Debug('Initializing search, keyword is : ' + searchValue);               
        Case cs = new case();
        cs = [select Id, CaseNumber,Owner.name, Previous_Owner__c, Origin, type, status from case where CaseNumber =:searchValue limit 1];
        searchResults = cs;
    }
    
    
    
    public  pagereference updateCaseData()
    {
        update searchResults;
        canRender=false;
        searchValue='';
        return ApexPages.CurrentPage();
        
    }
     public ApexPages.PageReference insertCaseData()
    {
        insert objCs;
        case c =[select id, CaseNumber from case where id=:objCs.Id];
        cn=c.CaseNumber;
		return ApexPages.CurrentPage();
    }
    	
}