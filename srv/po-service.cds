namespace zvks.srv.po_service;

using {
    zvks.db.data_model.master,
    zvks.db.data_model.transaction
} from '../db/data-model';

service PurchaseOrderSRV {

    entity AddressSet as projection on master.address;
    entity ProductSet as projection on master.product;
    entity BPSet      as projection on master.businesspartner;
    entity POSet      as projection on transaction.purchaseorder {
        * , 
       
        //round(GROSS_AMOUNT, 2) as GROSS_AMOUNT : Decimal(15, 2),

        case LIFECYCLE_STATUS
        when 'N' then 'New'
        when 'B' then 'Blocked' 
        when 'D' then 'Delivered' end as LIFECYCLE_STATUS : String(20),

        case LIFECYCLE_STATUS
        when 'N' then 2                                         // Warning: Orange
        when 'B' then 1                                         // Error: Red
        when 'D' then 3 end as LIFECYCLE_CRITICALITY : Integer, // Green: Success
        //when 'D' then 3 end as CRITICALITY : Integer, // Green: Success

        ITEMS : redirected to POItemsSet

    } 
    // actions {
    //     function largestOrder() returns array of POSet;
    //     //action boost(I_LIFECYCLY_STATUS: type of POSet:LIFECYCLE_STATUS);
    //     action boost();
    // }
    ;

    entity POItemsSet as projection on transaction.poitems {
        *,
        PARENT : redirected to POSet, 
        PRODUCT : redirected to ProductSet,
    };


//https://cap.cloud.sap/docs/guides/providing-services#actions-and-functions
//   // Sync API
//   action like (review: type of Reviews:ID);
//   action unlike (review: type of Reviews:ID);

//   // Async API
//    event reviewed : {
//      subject: type of Reviews:subject;
//      rating: Decimal(2,1)
//    }
}