import { LightningElement, api } from 'lwc';
//import generatePDF from '@salesforce/apex/pdfController.generatePDF'
import updateData from '@salesforce/apex/pdfController.storeHtmlData'
import generatePdf from '@salesforce/apex/pdfController.generatePdf'
import deleteCurrentPDFData from '@salesforce/apex/pdfController.deleteData'
export default class PdfGenerationDemo extends LightningElement {
    openModal = false;

    showModal() {
        this.openModal = true;
    }
    closeModal() {
        this.openModal = false;
    }

    constructor() {
        super();
        window.addEventListener('beforeunload', (event) => {
          // Cancel the event as stated by the standard.
          event.preventDefault();
          // Chrome requires returnValue to be set.
          event.returnValue = 'sample value';
        });
            }

            
    connectedCallback(){
        window.onbeforeunload = ()=>{
            console.log("Hiii")
            deleteCurrentPDFData({pdfId:this.pdfId}).then((result)=>{
                console.log(result);
            }).catch((error)=>{
                console.log(JSON.stringify(error));
            })
        }
    }
    @api recordId;
    pdfId;
    imageUrl = 'https://www.sparksuite.com/images/logo.png'
    invoiceData={
        invoiceNo:'123',
        invoiceCreated:'January 1, 2019',
        invoiceDue:'January 10, 2020',
        companyName:'Sparksuite, Inc.',
        address1:'12345 Sunny Road',
        address2:' Sunnyville, CA 12345'
    }
    clientData={
        client:'Acme Corp',
        username:'John Doe',
        email:'john@example.com'
    }
    services=[
        {name:'Consultant fee', amount:1000.00},
        {name:'Website design', amount:300.00},
        {name:'Hosting (3 months)', amount:75.00}
    ]

    get totalAmount(){
        return this.services.reduce((total, service)=>{
            return total = total+service.amount
        }, 0)
    }

    pdfHandler(){
        let content = this.template.querySelector('.container')
        console.log(content.outerHTML)
        this.pdfId = Date.now();
        updateData({pdfId:this.pdfId ,htmlData:content.outerHTML}).then((result)=>{
            generatePdf({pdfId:result, email:"email@email.com"}).then((response)=>{
                console.log(response);
            })
            .catch((error)=>{
                console.log(JSON.stringify(error));
            })
        }).catch((error)=>{
            console.log(JSON.stringify(error));
        })
        // generatePDF({htmlData:content.outerHTML}).then(result=>{
        //     console.log("attachment id", result)
        //     window.open(`https://playful-impala-6b89nt-dev-ed--c.documentforce.com/servlet/servlet.FileDownload?file=${result.Id}`)
        // }).catch(error=>{
        //     console.error(error)
        // })
    }
}