CREATE TABLE [dbo].[Item_Facturacion_tmp] (
    [I]                         INT             NOT NULL,
    [id_item_facturacion]       INT             NULL,
    [id_cuenta]                 INT             NULL,
    [cuenta_aurus]              INT             NULL,
    [suma_cargos]               DECIMAL (18, 2) NULL,
    [suma_impuestos]            DECIMAL (18, 2) NULL,
    [diferencia_ajuste]         DECIMAL (18, 2) NULL,
    [vuelta_facturacion]        VARCHAR (15)    NULL,
    [id_log_vuelta_facturacion] INT             NULL,
    [identificador_carga_dwh]   INT             NULL,
    [impuestos_reales]          DECIMAL (18, 2) NULL,
    [tipo_comprobante]          CHAR (1)        NULL,
    [nro_comprobante]           INT             NULL,
    [fecha_comprobante]         DATE            NULL,
    [mascara]                   CHAR (1)        NULL,
    [fecha_alta]                DATETIME        NULL,
    [usuario_alta]              VARCHAR (20)    NULL,
    [fecha_modificacion]        DATETIME        NULL,
    [usuario_modificacion]      VARCHAR (20)    NULL,
    [letra_comprobante]         CHAR (1)        NULL,
    CONSTRAINT [PK_Item_Facturacion_tmp] PRIMARY KEY CLUSTERED ([I] ASC) WITH (FILLFACTOR = 80)
);

