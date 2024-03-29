﻿CREATE TABLE [dbo].[Actividad_Transaccional_Cuenta] (
    [id_actividad_cuenta]        INT             IDENTITY (1, 1) NOT NULL,
    [id_cuenta]                  INT             NOT NULL,
    [cant_tx_dia_TC]             INT             CONSTRAINT [DF_Actividad_Transaccional__cant_tx_di] DEFAULT ((0)) NULL,
    [cant_tx_dia_TD]             INT             CONSTRAINT [DF_Actividad_Transaccional_Cuenta_cant_tx_dia_TD] DEFAULT ((0)) NULL,
    [cant_tx_dia_cupon]          INT             CONSTRAINT [DF_Actividad_Transaccional_Cuenta_cant_tx_dia_cupon] DEFAULT ((0)) NULL,
    [cant_tx_dia_cupon_vencido]  INT             CONSTRAINT [DF_Actividad_Transaccional_Cuenta_cant_tx_dia_cupon_vencido] DEFAULT ((0)) NULL,
    [cant_tx_dia_cashOut]        INT             CONSTRAINT [DF_Actividad_Transaccional_Cuenta_cant_tx_dia_cashOut] DEFAULT ((0)) NULL,
    [monto_tx_dia_TC]            DECIMAL (12, 2) CONSTRAINT [DF_Actividad_Transaccional__monto_tx_d] DEFAULT ((0)) NULL,
    [monto_tx_dia_TD]            DECIMAL (12, 2) CONSTRAINT [DF_Actividad_Transaccional_Cuenta_monto_tx_dia_TD] DEFAULT ((0)) NULL,
    [monto_tx_dia_cupon]         DECIMAL (12, 2) CONSTRAINT [DF_Actividad_Transaccional_Cuenta_monto_tx_dia_cupon] DEFAULT ((0)) NULL,
    [monto_tx_dia_cupon_vencido] DECIMAL (12, 2) CONSTRAINT [DF_Actividad_Transaccional_Cuenta_monto_tx_dia_cupon_vencido] DEFAULT ((0)) NULL,
    [monto_tx_dia_cashOut]       DECIMAL (12, 2) CONSTRAINT [DF_Actividad_Transaccional_Cuenta_monto_tx_dia_cashOut] DEFAULT ((0)) NULL,
    [fecha_procesada]            DATETIME        NOT NULL,
    [id_log_proceso]             INT             NOT NULL,
    [fecha_alta]                 DATETIME        NULL,
    [usuario_alta]               VARCHAR (20)    NULL,
    [fecha_modificacion]         DATETIME        NULL,
    [usuario_modificacion]       VARCHAR (20)    NULL,
    [fecha_baja]                 DATETIME        NULL,
    [usuario_baja]               VARCHAR (20)    NULL,
    [version]                    INT             CONSTRAINT [DF_Actividad_Transaccional_Cuenta_version] DEFAULT ((0)) NOT NULL,
    [cant_tx_dia_TC_mPos]        INT             NULL,
    [cant_tx_dia_TD_mPos]        INT             NULL,
    [monto_tx_dia_TC_mPos]       DECIMAL (12, 2) NULL,
    [monto_tx_dia_TD_mPos]       DECIMAL (12, 2) NULL,
    CONSTRAINT [PK_Actividad_Transaccional_] PRIMARY KEY CLUSTERED ([id_actividad_cuenta] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_Actividad_Transaccional__Actividad_Transaccional_] FOREIGN KEY ([id_actividad_cuenta]) REFERENCES [dbo].[Actividad_Transaccional_Cuenta] ([id_actividad_cuenta])
);

