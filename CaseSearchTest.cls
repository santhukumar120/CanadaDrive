@isTest
public class CaseSearchTest {
	
    public static testmethod void testCaseSearchController(){
    
        case cs= new case();
        cs.origin='phone';
        cs.Status='New';
        cs.Priority='low';
        insert cs;
        
        Test.startTest();
        cs.Status='Escalated';
        update cs;
        Test.stopTest();
    }
    public static testmethod void testCaseSearchVFController(){
    
        case cs= new case();
        cs.origin='phone';
        cs.Status='New';
        cs.Priority='low';
        insert cs;
        Case caseObj = [select id, casenumber from case where id = : cs.id];
        system.debug('**'+caseObj.CaseNumber);
        Test.startTest();
        CaseSearch c=new CaseSearch();
        c.searchValue=caseObj.CaseNumber;
        c.searchCases();
        c.searchValue='';
        c.searchCases();
        
        PageReference p=c.updateCaseData();
        Test.stopTest();
    }
    
    
    public static testmethod void testcaseinsertmethod(){
        case cs=new case();
        cs.origin='phone';
        cs.Status='New';
        cs.Priority='low';
        Test.startTest();
        CaseSearch c=new CaseSearch();
        c.objCs=cs;
        PageReference pc= c.insertCaseData();
        Test.stopTest();
    }
    
}