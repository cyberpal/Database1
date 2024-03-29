﻿CREATE TABLE [dbo].[Promocion_Comprador] (
    [id_promocion_comprador] INT             IDENTITY (1, 1) NOT NULL,
    [id_tipo_promocion]      INT             NOT NULL,
    [nombre]                 VARCHAR (20)    NOT NULL,
    [descripcion]            VARCHAR (100)   NOT NULL,
    [fecha_inicio]           DATETIME        NOT NULL,
    [fecha_fin]              DATETIME        NOT NULL,
    [id_tipo_aplicacion]     INT             NOT NULL,
    [valor]                  DECIMAL (12, 2) NOT NULL,
    [tope_minimo]            DECIMAL (12, 2) NOT NULL,
    [tope_maximo]            DECIMAL (12, 2) NOT NULL,
    [plazo_liberacion]       INT             NOT NULL,
    [fecha_alta]             DATETIME        NOT NULL,
    [usuario_alta]           VARCHAR (20)    NOT NULL,
    [fecha_modificacion]     DATETIME        NULL,
    [usuario_modificacion]   VARCHAR (20)    NULL,
    [fecha_baja]             DATETIME        NULL,
    [usuario_baja]           VARCHAR (20)    NULL,
    [version]                INT             CONSTRAINT [DF_Promocion_Comprador_version] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_id_promocion_comprador] PRIMARY KEY CLUSTERED ([id_promocion_comprador] ASC),
    CONSTRAINT [FK_Promocion_Comprador_Tipo_Aplicacion] FOREIGN KEY ([id_tipo_aplicacion]) REFERENCES [dbo].[Tipo] ([id_tipo]),
    CONSTRAINT [FK_Promocion_Comprador_Tipo_Promocion] FOREIGN KEY ([id_tipo_promocion]) REFERENCES [dbo].[Tipo] ([id_tipo])
);

