CREATE TABLE [dbo].[Acumulador_Promociones_bkp] (
    [id_acumulador_promociones] INT             IDENTITY (1, 1) NOT NULL,
    [id_promocion]              INT             NOT NULL,
    [fecha_transaccion]         DATETIME        NULL,
    [cuenta_transaccion]        INT             NULL,
    [importe_total_tx]          DECIMAL (12, 2) NULL,
    [cantidad_tx]               INT             NULL
);

