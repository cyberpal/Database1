﻿CREATE TABLE [dbo].[vuelta_facturacion] (
    [id_vuelta_facturacion] INT             NULL,
    [Nro_item]              CHAR (10)       NULL,
    [Nro_Interno]           NUMERIC (9)     NULL,
    [Mascara]               CHAR (4)        NULL,
    [Descripcion_item]      CHAR (20)       NULL,
    [Rango_precio]          CHAR (100)      NULL,
    [Codigo_contrato]       NUMERIC (9)     NULL,
    [Desc_contrato]         CHAR (30)       NULL,
    [Tipo_comprobante]      CHAR (2)        NULL,
    [Fecha_comprobante]     DATE            NULL,
    [Nro_cliente_int]       NUMERIC (9)     NULL,
    [Descripcion_cliente]   CHAR (80)       NULL,
    [Nro_comprobante]       NUMERIC (9)     NULL,
    [Cantidad]              NUMERIC (15, 5) NULL,
    [Cantidad_medida]       CHAR (6)        NULL,
    [Importe_dolares]       DECIMAL (18, 2) NULL,
    [Importe_dolares_iva]   DECIMAL (18, 2) NULL,
    [Importe_pesos]         DECIMAL (15, 5) NULL,
    [Importe_pesos_iva]     DECIMAL (18, 2) NULL,
    [Campania]              NUMERIC (9)     NULL,
    [Nro_cliente_ext]       CHAR (10)       NULL
);

