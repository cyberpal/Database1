CREATE TABLE [dbo].[Plazo_Liberacion] (
    [id_plazo_liberacion]     INT          IDENTITY (1, 1) NOT NULL,
    [id_tipo_medio_pago]      INT          NOT NULL,
    [id_tipo_cuenta]          INT          NULL,
    [id_rubro]                INT          NULL,
    [id_cuenta]               INT          NULL,
    [plazo_liberacion]        INT          NOT NULL,
    [plazo_liberacion_cuotas] INT          NULL,
    [flag_permite_baja]       BIT          CONSTRAINT [DF_Plazo_Liberacion_flag_permi] DEFAULT ((1)) NOT NULL,
    [fecha_alta]              DATETIME     NULL,
    [usuario_alta]            VARCHAR (20) NULL,
    [fecha_modificacion]      DATETIME     NULL,
    [usuario_modificacion]    VARCHAR (20) NULL,
    [fecha_baja]              DATETIME     NULL,
    [usuario_baja]            VARCHAR (20) NULL,
    [version]                 INT          CONSTRAINT [DF_Plazo_Liberacion_version] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Plazo_Liberacion] PRIMARY KEY CLUSTERED ([id_plazo_liberacion] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_Plazo_Liberacion_Tipo_Medio_Pago_id_cuenta] FOREIGN KEY ([id_cuenta]) REFERENCES [dbo].[Cuenta] ([id_cuenta]),
    CONSTRAINT [FK_Plazo_Liberacion_Tipo_Medio_Pago_id_rubro] FOREIGN KEY ([id_tipo_medio_pago]) REFERENCES [dbo].[Tipo_Medio_Pago] ([id_tipo_medio_pago]),
    CONSTRAINT [FK_Plazo_Liberacion_Tipo_Medio_Pago_id_tipo_medio_pago] FOREIGN KEY ([id_rubro]) REFERENCES [dbo].[Tipo_Medio_Pago] ([id_tipo_medio_pago])
);

