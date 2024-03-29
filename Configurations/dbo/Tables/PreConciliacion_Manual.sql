﻿CREATE TABLE [dbo].[PreConciliacion_Manual] (
    [id_preconciliacion_manual] INT             IDENTITY (1, 1) NOT NULL,
    [id_transaccion]            CHAR (36)       NULL,
    [importe]                   DECIMAL (12, 2) NULL,
    [moneda]                    INT             NULL,
    [cantidad_cuotas]           INT             NULL,
    [nro_tarjeta]               VARCHAR (50)    NULL,
    [codigo_barra]              VARCHAR (128)   NULL,
    [fecha_movimiento]          DATETIME        NULL,
    [nro_autorizacion]          VARCHAR (50)    NULL,
    [nro_cupon]                 VARCHAR (50)    NULL,
    [nro_agrupador_boton]       VARCHAR (50)    NULL,
    [flag_preconciliado_manual] BIT             NOT NULL,
    [flag_procesado]            BIT             NOT NULL,
    [fecha_alta]                DATETIME        NULL,
    [usuario_alta]              VARCHAR (20)    NULL,
    [fecha_modificacion]        DATETIME        NULL,
    [usuario_modificacion]      VARCHAR (20)    NULL,
    [fecha_baja]                DATETIME        NULL,
    [usuario_baja]              VARCHAR (20)    NULL,
    [version]                   INT             NOT NULL,
    [fecha_presentacion]        DATETIME        NULL,
    [id_log_paso]               INT             NULL,
    [id_movimiento_decidir]     INT             NULL,
    CONSTRAINT [PK_PreConciliacion_Manual] PRIMARY KEY CLUSTERED ([id_preconciliacion_manual] ASC) WITH (FILLFACTOR = 80)
);

