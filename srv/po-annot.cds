namespace zvks.srv.po_annot;

using {zvks.srv.po_service.PurchaseOrderSRV} from './po-service';

@path     : '/PurchaseOrderSRV'
@requires : 'authenticated-user'
annotate PurchaseOrderSRV with {};

//---------------------------------------------------------------
// Address Set
//---------------------------------------------------------------
annotate PurchaseOrderSRV.AddressSet with {
    @UI.Hidden : true
    ID;
};

//---------------------------------------------------------------
// Product Set
//---------------------------------------------------------------
annotate PurchaseOrderSRV.ProductSet with {
    @UI.Hidden : true
    ID;
};

//---------------------------------------------------------------
// BP Set
//---------------------------------------------------------------
annotate PurchaseOrderSRV.BPSet with {
    @UI.Hidden : true
    ID;

    //Value Helps
    @Common    : {
        ValueList : {
            $Type          : 'Common.ValueListType',
            CollectionPath : 'BPSet',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    ValueListProperty : 'BP_NO',
                    LocalDataProperty : BP_NO,
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'BP_ROLE'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'COMPANY_NAME'
                }
            ]
        },
        Text      : COMPANY_NAME
    }
    BP_NO
};

    //---------------------------------------------------------------
// Purchase Order Set
//---------------------------------------------------------------
@UI                      : {
    //  List Page
    SelectionFields              : [
        PO_NO,
        LIFECYCLE_STATUS,
        OVERALL_STATUS,
        CURRENCY_code
    ],
    LineItem                     : [
        //Actions
        // {
        //     $Type             : 'UI.DataFieldForAction',
        //     Label             : 'Boost',
        //     Action            : 'PurchaseOrderSRV.boost',
        //     // Determining : '',
        //     // Inline : true,
        //     ![@UI.Importance] : #High,
        // },
        //Functions
        //...
        //List Columns
        {
            $Type             : 'UI.DataField',
            Value             : PO_NO,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : NET_AMOUNT,
            ![@UI.Importance] : #Medium
        },
        {
            $Type             : 'UI.DataField',
            Value             : TAX_AMOUNT,
            ![@UI.Importance] : #Medium
        },
        {
            $Type             : 'UI.DataField',
            Value             : GROSS_AMOUNT,
            ![@UI.Importance] : #Medium
        },
        {
            $Type             : 'UI.DataField',
            Value             : CURRENCY_code,
            ![@UI.Importance] : #Medium
        },
        {
            $Type                     : 'UI.DataField',
            Value                     : LIFECYCLE_STATUS,
            ![@UI.Importance]         : #High,
            Criticality               : LIFECYCLE_CRITICALITY,
            CriticalityRepresentation : #WithIcon
        },
        {
            $Type             : 'UI.DataField',
            Value             : OVERALL_STATUS,
            ![@UI.Importance] : #High
        }
    ],
    //-------------------------------------------
    //  Object Page
    //-------------------------------------------
    HeaderInfo                   : {
        $Type          : 'UI.HeaderInfoType',
        TypeName       : '{webapp>i18n>PO}',
        TypeNamePlural : '{webapp>i18n>POS}',
        Title          : {
            Label : '{webapp>i18n>PO}',
            Value : PO_NO
        },
        Description    : {
            Label : '{webapp>i18n>COMPANY_NAME}',
            Value : BUSINESS_PARTNER.COMPANY_NAME,
        },
        ImageUrl       : 'sap-icon://sales-order',
    },
    HeaderFacets                 : [
        {
            $Type  : 'UI.ReferenceFacet',
            Target : ![@UI.DataPoint#tgNetAmount]
        },
        {
            $Type  : 'UI.ReferenceFacet',
            Target : ![@UI.DataPoint#tgTaxAmount]
        },
        {
            $Type  : 'UI.ReferenceFacet',
            Target : ![@UI.DataPoint#tgGrossAmount]
        },
        {
            $Type  : 'UI.ReferenceFacet',
            Target : ![@UI.DataPoint#tgLifeCycleStatus]
        }
    ],

    DataPoint #tgNetAmount       : {
        $Type : 'UI.DataPointType',
        Title : 'Net Amount',
        Value : NET_AMOUNT
    },
    DataPoint #tgTaxAmount       : {
        $Type : 'UI.DataPointType',
        Title : 'Tax Amount',
        Value : TAX_AMOUNT
    },
    DataPoint #tgGrossAmount     : {
        $Type : 'UI.DataPointType',
        Title : 'Gross Amount',
        Value : GROSS_AMOUNT
    },
    DataPoint #tgLifeCycleStatus : {
        $Type                     : 'UI.DataPointType',
        Title                     : 'Life Cycle',
        Value                     : LIFECYCLE_STATUS,
        Criticality               : LIFECYCLE_CRITICALITY,
        CriticalityRepresentation : #WithIcon
    },
    Facets                       : [
        {
            ID     : 'idPO',
            $Type  : 'UI.ReferenceFacet',
            Label  : '{webapp>i18n>PO_TAB}',
            Target : ![@UI.FieldGroup#tgPO]
        },
        {
            ID     : 'IdBPCollection',
            $Type  : 'UI.CollectionFacet',
            Label  : '{webapp>i18n>BP_TAB}',
            Facets : [
                {
                    ID     : 'idBPContact',
                    $Type  : 'UI.ReferenceFacet',
                    Label  : 'Contact', //Not working '{webapp>i18n>BP_TAB}',
                    Target : ![@UI.FieldGroup#tgBPContact]
                },
                {
                    ID     : 'idBPAddress',
                    $Type  : 'UI.ReferenceFacet',
                    Label  : 'Address', //Not working '{webapp>i18n>BP_TAB_ADDRESS}',
                    Target : ![@UI.FieldGroup#tgBPAddress]
                }
            ]
        },
        {
            ID     : 'idPOItem',
            Label  : '{webapp>i18n>ITEM_TAB}',
            $Type  : 'UI.ReferenceFacet',
            Target : 'ITEMS/@UI.LineItem',
        }
    ],
    // General Information Tab
    FieldGroup #tgPO             : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : OVERALL_STATUS
            },
            {
                $Type : 'UI.DataField',
                Value : NOTE
            }
        ]
    },
    FieldGroup #tgBPContact      : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : BUSINESS_PARTNER.BP_NO
            },
            {
                $Type : 'UI.DataField',
                Value : BUSINESS_PARTNER.BP_ROLE
            },
            {
                $Type : 'UI.DataField',
                Value : BUSINESS_PARTNER.EMAIL_ADDRESS
            },
            {
                $Type : 'UI.DataField',
                Value : BUSINESS_PARTNER.FAX_NUMBER
            },
            {
                $Type : 'UI.DataField',
                Value : BUSINESS_PARTNER.PHONE_NUMBER
            },
            {
                $Type : 'UI.DataField',
                Value : BUSINESS_PARTNER.WEB_ADDRESS
            }
        ]
    },
    FieldGroup #tgBPAddress      : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : BUSINESS_PARTNER.ADDRESS.ADDRESS_TYPE
            },
            {
                $Type : 'UI.DataField',
                Value : BUSINESS_PARTNER.ADDRESS.BUILDING
            },
            {
                $Type : 'UI.DataField',
                Value : BUSINESS_PARTNER.ADDRESS.STREET
            },
            {
                $Type : 'UI.DataField',
                Value : BUSINESS_PARTNER.ADDRESS.CITY
            },
            {
                $Type : 'UI.DataField',
                Value : BUSINESS_PARTNER.ADDRESS.COUNTRY
            },
            {
                $Type : 'UI.DataField',
                Value : BUSINESS_PARTNER.ADDRESS.POSTAL_CODE
            }
        ]
    }
}

@odata.draft.enabled : true
@restrict            : [
    {
        //{ grant:<events>, to:<roles>, where:<filter-condition> }
        grant : ['READ'],   // [READ, CREATE, UPDATE, DELETE]
        to    : 'Viewer',
        where : 'LIFECYCLE_STATUS = $user.LIFECYCLE_STATUS'
    },
    {
        grant : ['CREATE, UPDATE, DELETE'], //or [WRITE]
        to    : 'Admin'
    }
]
annotate PurchaseOrderSRV.POSet with {
    @UI.Hidden           : true
    ID;

    @UI.Hidden           : true
    BUSINESS_PARTNER;

    // @title               : '{i18n>POSET_GROSS_AMOUNT}'
    // GROSS_AMOUNT;

    @title               : '{i18n>POSET_LIFECYCLE_STATUS}'
    LIFECYCLE_STATUS;

    @UI.Hidden           : true
    LIFECYCLE_CRITICALITY;
} actions {
    @Title               : '{i18n>POSET_BOOST}'
    boost
};

    //---------------------------------------------------------------
// Purchase Order Item Set
//---------------------------------------------------------------
@UI            : {
    LineItem                  : [
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_NO,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT.PRODUCT_NO,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT.DESCRIPTION,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT.PRICE,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT.CURRENCY_code,
        }
    ],
    // Object Page
    HeaderInfo                : {
        $Type          : 'UI.HeaderInfoType',
        TypeName       : '{webapp>i18n>POITEM}',
        TypeNamePlural : '{webapp>i18n>POITEMS}',
        Title          : {Value : PO_ITEM_NO},
        Description    : {Value : PRODUCT.DESCRIPTION},
        ImageUrl       : 'sap-icon://product'
    },
    Facets                    : [
        {
            ID     : 'idPD',
            $Type  : 'UI.ReferenceFacet',
            Label  : '{webapp>i18n>PD_TAB}',
            Target : ![@UI.FieldGroup#tgPD]
        },
        {
            ID     : 'idDimensions',
            $Type  : 'UI.ReferenceFacet',
            Label  : '{webapp>i18n>DIMENTION_TAB}',
            Target : ![@UI.FieldGroup#tgPDDimension]
        }
    ],
    FieldGroup #tgPD          : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.PRODUCT_NO
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.DESCRIPTION
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.CATEGORY
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.PRICE
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.CURRENCY_code
            }
        ]
    },
    FieldGroup #tgPDDimension : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.WIDTH
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.DEPTH
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.HEIGHT
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.DIM_UNIT
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.WEIGHT_MEASURE
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.WEIGHT_UNIT
            }
        ]
    }
}
annotate PurchaseOrderSRV.POItemsSet with {
    @UI.Hidden : true
    ID;
    @UI.Hidden : true
    PARENT;
    @UI.Hidden : true
    PRODUCT;
};
