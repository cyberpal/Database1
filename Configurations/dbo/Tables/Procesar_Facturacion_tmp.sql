CREATE TABLE [dbo].[Procesar_Facturacion_tmp] (
    [I]                      INT             IDENTITY (1, 1) NOT NULL,
    [id]                     VARCHAR (36)    NULL,
    [LocationIdentification] INT             NULL,
    [LiquidationTimeStamp]   DATETIME        NULL,
    [LiquidationStatus]      INT             NULL,
    [BillingTimeStamp]       DATETIME        NULL,
    [BillingStatus]          INT             NULL,
    [CreateTimeStamp]        DATETIME        NULL,
    [Amount]                 DECIMAL (12, 2) NULL,
    [FeeAmount]              DECIMAL (12, 2) NULL,
    [TaxAmount]              DECIMAL (12, 2) NULL,
    [OperationName]          VARCHAR (128)   NULL,
    CONSTRAINT [PK_Procesar_Facturacion_tmp] PRIMARY KEY CLUSTERED ([I] ASC) WITH (FILLFACTOR = 80)
);

