﻿CREATE TABLE [dbo].[Movimiento_Presentado_Decidir] (
    [id_movimiento_decidir]    INT             IDENTITY (1, 1) NOT NULL,
    [importe]                  DECIMAL (12, 2) NULL,
    [signo_importe]            CHAR (1)        NULL,
    [moneda]                   INT             NULL,
    [cantidad_cuotas]          INT             NULL,
    [nro_tarjeta]              NVARCHAR (50)   NULL,
    [codigo_barra]             VARCHAR (128)   NULL,
    [fecha_movimiento]         DATETIME        NULL,
    [nro_autorizacion]         VARCHAR (8)     NULL,
    [nro_cupon]                INT             NULL,
    [nro_agrupador]            VARCHAR (50)    NULL,
    [id_log_paso]              INT             NULL,
    [id_medio_pago]            INT             NULL,
    [id_codigo_operacion]      INT             NULL,
    [fecha_presentacion]       DATETIME        NULL,
    [nro_lote]                 VARCHAR (15)    NULL,
    [validacion_resultado_mov] VARCHAR (250)   NULL,
    [id_site]                  INT             NULL,
    [id_transaccion]           VARCHAR (64)    NULL,
    [fecha_alta]               DATETIME        NOT NULL,
    [usuario_alta]             VARCHAR (20)    NOT NULL,
    [fecha_modificacion]       DATETIME        NULL,
    [usuario_modificacion]     VARCHAR (20)    NULL,
    [fecha_baja]               DATETIME        NULL,
    [usuario_baja]             VARCHAR (20)    NULL,
    [version]                  BIT             NOT NULL,
    CONSTRAINT [PK_Movimiento_Presentado_Decidir] PRIMARY KEY CLUSTERED ([id_movimiento_decidir] ASC) WITH (FILLFACTOR = 80)
);
