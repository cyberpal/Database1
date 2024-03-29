﻿CREATE TABLE [dbo].[Movimiento_Presentado_MP] (
    [importe]                           DECIMAL (12, 2) NULL,
    [signo_importe]                     CHAR (1)        NULL,
    [moneda]                            INT             NULL,
    [cantidad_cuotas]                   INT             NULL,
    [nro_tarjeta]                       NVARCHAR (50)   NULL,
    [codigo_barra]                      VARCHAR (128)   NULL,
    [fecha_movimiento]                  DATETIME        NULL,
    [nro_autorizacion]                  VARCHAR (8)     NULL,
    [nro_cupon]                         INT             NULL,
    [nro_agrupador_boton]               VARCHAR (50)    NULL,
    [cargos_marca_por_movimiento]       DECIMAL (12, 2) NULL,
    [signo_cargos_marca_por_movimiento] CHAR (1)        NULL,
    [id_log_paso]                       INT             NULL,
    [id_medio_pago]                     INT             NULL,
    [id_movimiento_mp]                  INT             IDENTITY (1, 1) NOT NULL,
    [id_codigo_operacion]               INT             NULL,
    [fecha_pago]                        DATETIME        NULL,
    [nro_lote]                          VARCHAR (15)    NULL,
    [hash_nro_tarjeta]                  VARCHAR (80)    NULL,
    [validacion_resultado_mov]          VARCHAR (250)   NULL,
    [fecha_alta]                        DATETIME        NOT NULL,
    [usuario_alta]                      VARCHAR (20)    NOT NULL,
    [fecha_modificacion]                DATETIME        NULL,
    [usuario_modificacion]              VARCHAR (20)    NULL,
    [fecha_baja]                        DATETIME        NULL,
    [usuario_baja]                      VARCHAR (20)    NULL,
    [version]                           BIT             CONSTRAINT [DF_MPMP_version] DEFAULT ((0)) NOT NULL,
    [mask_nro_tarjeta]                  VARCHAR (20)    NULL,
    [campo_mp_1]                        VARCHAR (10)    NULL,
    [valor_1]                           VARCHAR (15)    NULL,
    [campo_mp_2]                        VARCHAR (10)    NULL,
    [valor_2]                           VARCHAR (15)    NULL,
    [campo_mp_3]                        VARCHAR (10)    NULL,
    [valor_3]                           VARCHAR (15)    NULL,
    CONSTRAINT [PK_Movimiento_Presentado_MP] PRIMARY KEY CLUSTERED ([id_movimiento_mp] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_Movimientos_a_conciliar_Medio_De_Pago] FOREIGN KEY ([id_medio_pago]) REFERENCES [dbo].[Medio_De_Pago] ([id_medio_pago]),
    CONSTRAINT [FK_MPMP_codigo_operacion] FOREIGN KEY ([id_codigo_operacion]) REFERENCES [dbo].[Codigo_Operacion] ([id_codigo_operacion])
);

