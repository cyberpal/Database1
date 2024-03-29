﻿CREATE TABLE [dbo].[Cargo] (
    [id_cargo]             INT             IDENTITY (1, 1) NOT NULL,
    [id_tipo_medio_pago]   INT             NULL,
    [id_tipo_cuenta]       INT             NULL,
    [id_base_de_calculo]   INT             NULL,
    [id_tipo_aplicacion]   INT             NULL,
    [valor]                DECIMAL (12, 2) NULL,
    [flag_estado]          BIT             NOT NULL,
    [fecha_alta]           DATETIME        NULL,
    [usuario_alta]         VARCHAR (20)    NULL,
    [fecha_modificacion]   DATETIME        NULL,
    [usuario_modificacion] VARCHAR (20)    NULL,
    [fecha_baja]           DATETIME        NULL,
    [usuario_baja]         VARCHAR (20)    NULL,
    [version]              INT             CONSTRAINT [DF_Cargo_version] DEFAULT ((0)) NOT NULL,
    [flag_permite_baja]    BIT             NOT NULL,
    [id_tipo_cargo]        INT             NULL,
    [grupo_cargo]          INT             CONSTRAINT [DF_Cargo_grupo_cargo] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_Cargo] PRIMARY KEY CLUSTERED ([id_cargo] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_Cargo_Tipo_Cargo] FOREIGN KEY ([id_tipo_cargo]) REFERENCES [dbo].[Tipo_Cargo] ([id_tipo_cargo]),
    CONSTRAINT [FK_Cargo_Tipo_id_base_de_calculo] FOREIGN KEY ([id_base_de_calculo]) REFERENCES [dbo].[Tipo] ([id_tipo]),
    CONSTRAINT [FK_Cargo_Tipo_id_tipo_aplicacion] FOREIGN KEY ([id_tipo_aplicacion]) REFERENCES [dbo].[Tipo] ([id_tipo]),
    CONSTRAINT [FK_Cargo_Tipo_id_tipo_cuenta] FOREIGN KEY ([id_tipo_cuenta]) REFERENCES [dbo].[Tipo] ([id_tipo]),
    CONSTRAINT [FK_Cargo_Tipo_Medio_Pago] FOREIGN KEY ([id_tipo_medio_pago]) REFERENCES [dbo].[Tipo_Medio_Pago] ([id_tipo_medio_pago])
);

