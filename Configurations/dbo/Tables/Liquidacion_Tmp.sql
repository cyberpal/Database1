﻿CREATE TABLE [dbo].[Liquidacion_Tmp] (
    [I]                          INT             NOT NULL,
    [Id]                         CHAR (36)       NOT NULL,
    [CreateTimestamp]            DATETIME        NULL,
    [LocationIdentification]     INT             NULL,
    [ProductIdentification]      INT             NULL,
    [OperationName]              VARCHAR (128)   NULL,
    [Amount]                     DECIMAL (12, 2) NULL,
    [FeeAmount]                  DECIMAL (12, 2) NULL,
    [TaxAmount]                  DECIMAL (12, 2) NULL,
    [CashoutTimestamp]           DATETIME        NULL,
    [FilingDeadline]             DATETIME        NULL,
    [PaymentTimestamp]           DATETIME        NULL,
    [FacilitiesPayments]         INT             NULL,
    [LiquidationStatus]          INT             NOT NULL,
    [LiquidationTimestamp]       DATETIME        NULL,
    [PromotionIdentification]    INT             NULL,
    [ButtonCode]                 VARCHAR (20)    NULL,
    [Flag_Ok]                    INT             NULL,
    [TransactionStatus]          VARCHAR (20)    NULL,
    [BuyerAccountIdentification] INT             NULL,
    [AdditionalData]             XML             NULL,
    [CredentialDocumentType]     VARCHAR (36)    NULL,
    [CredentialDocumentNumber]   VARCHAR (24)    NULL,
    [CredentialMask]             VARCHAR (20)    NULL,
    [ProviderTransactionID]      VARCHAR (64)    NULL,
    [SaleConcept]                VARCHAR (255)   NULL,
    [CredentialEmailAddress]     VARCHAR (64)    NULL,
    CONSTRAINT [PK_Liquidacion_Tmp] PRIMARY KEY CLUSTERED ([I] ASC)
);



