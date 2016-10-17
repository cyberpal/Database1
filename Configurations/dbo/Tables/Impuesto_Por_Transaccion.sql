CREATE TABLE [dbo].[Impuesto_Por_Transaccion] (
    [id_impuesto_por_transaccion] INT             IDENTITY (1, 1) NOT NULL,
    [id_transaccion]              CHAR (36)       NOT NULL,
    [id_cargo]                    INT             NULL,
    [id_impuesto]                 INT             NOT NULL,
    [monto_calculado]             DECIMAL (12, 2) NULL,
    [alicuota]                    DECIMAL (12, 2) NULL,
    [fecha_alta]                  DATETIME        NULL,
    [usuario_alta]                VARCHAR (20)    NULL,
    [fecha_modificacion]          DATETIME        NULL,
    [usuario_modificacion]        VARCHAR (20)    NULL,
    [fecha_baja]                  DATETIME        NULL,
    [usuario_baja]                VARCHAR (20)    NULL,
    [version]                     INT             NOT NULL,
    [ProviderTransactionID]       VARCHAR (64)    NULL,
    [CreateTimestamp]             DATETIME        NULL,
    [SaleConcept]                 VARCHAR (255)   NULL,
    [CredentialEmailAddress]      VARCHAR (64)    NULL,
    [Amount]                      DECIMAL (12, 2) NULL,
    [FeeAmount]                   DECIMAL (12, 2) NULL,
    CONSTRAINT [PK_Impuesto_Por_Transaccion] PRIMARY KEY CLUSTERED ([id_impuesto_por_transaccion] ASC) WITH (FILLFACTOR = 80)
);



