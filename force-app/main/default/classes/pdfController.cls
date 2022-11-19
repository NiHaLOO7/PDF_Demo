/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-19-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class pdfController {

    @AuraEnabled
    public static string storeHtmlData(String pdfId, String htmlData){
        List<PDF_Data__b> pdfData = new List<PDF_Data__b>();
        PDF_Data__b content = new PDF_Data__b(PDF_Id__c=pdfId , Id__c='1234567890', PDF_Content__c=htmlData);
        // pdfId => Unique(timeStamp)
        pdfData.add(content);
        Database.insertImmediate(pdfData);
        return pdfId;
    }

    @AuraEnabled
    public static string generatePdf(String pdfId, String email){
        Pagereference page = Page.renderAsPDF;
        page.getParameters().put('pdfText', pdfId);
        List<Skill__c> sk = new List<Skill__c>();
        Skill__c ski = new Skill__c(Skill_Name__c='aa');
        sk.add(ski);
        Database.SaveResult srList = Database.insert(ski,true);
        String aa = srList.getId();
        Skill__c skiv = new Skill__c(Id = aa);
        Attachment objAttachment = new Attachment();
        objAttachment.Name='invoice.pdf';
        objAttachment.ParentId = skiv.Id;
        objAttachment.Body = page.getContentaspdf();
        objAttachment.IsPrivate = false;
        insert objAttachment;
        System.debug(page.getContentaspdf());
        sendPdfViaEmail(email, pdfId);
        return aa;
    }

    @future( Callout = true )
    public static void sendPdfViaEmail(String email, String pdfId){
        try {
            Pagereference page = new Pagereference('/apex/renderAsPDF?pdfText='+pdfId);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('document');
            attachment.setContentType('application/pdf');
            attachment.body = page.getContent();
            attachment.setInline(false);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {email});
            mail.setSubject('Hii Its Me');
            mail.setHtmlBody('Its really me');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

            for (Messaging.SendEmailResult res : results) {
                if (res.isSuccess()) {
                    System.debug('Email sent successfully');
                }
                else {
                System.debug('The following errors occurred: ' + res.getErrors());                 
                }
            }
        }
        catch (Exception e) {
            System.debug(e.getMessage());
        }
        
    }

    @AuraEnabled
    public static void deleteData(String pdfId){
        List<PDF_Data__b> pdfData = [SELECT PDF_Id__c FROM PDF_Data__b WHERE PDF_Id__c = :pdfId];
        //"Only indexed one needed in select statement[SELECT =>PDF_Id__c FROM PDF_Data__b WHERE PDF_Id__c = :pdfId]"
        database.deleteImmediate(pdfData);
    }

    //      /apex/renderAsPDF?pdfText=1643117439460






    // @AuraEnabled
    // public static String generatePDF(String htmlData){
    //     Pagereference page = Page.renderAsPDF;
    //     page.getParameters().put('pdfText', htmlData);
    //     List<Skill__c> sk = new List<Skill__c>();
    //     Skill__c ski = new Skill__c(Skill_Name__c='aa');
    //     sk.add(ski);
    //     Database.SaveResult srList = Database.insert(ski,true);
    //     String aa = srList.getId();
    //     Skill__c skiv = new Skill__c(Id = aa);
    //     Attachment objAttachment = new Attachment();
    //     objAttachment.Name='invoice.pdf';
    //     objAttachment.ParentId = skiv.Id;
    //     objAttachment.Body = page.getContentaspdf();
    //     objAttachment.IsPrivate = false;
    //     insert objAttachment;
    //     System.debug(page.getContentaspdf());
    //     return aa;
    // }
}