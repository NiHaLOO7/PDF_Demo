/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-25-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class pdfPageController {
    public String pdfText{get;set;}
    public pdfPageController() {
        String pdfId = ApexPages.currentPage().getParameters().get('pdfText');
        pdfText = String.escapeSingleQuotes(
            [SELECT PDF_Id__c, PDF_Content__c FROM PDF_Data__b WHERE PDF_Id__c = :pdfId].PDF_Content__c
        );
    }
}