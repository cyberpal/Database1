CREATE TABLE [dbo].[Ajuste] (
    [id_ajuste]            INT             NOT NULL,
    [id_codigo_operacion]  INT             NOT NULL,
    [id_cuenta]            INT             NOT NULL,
    [monto]                NUMERIC (18, 2) NOT NULL,
    [id_motivo_ajuste]     INT             NOT NULL,
    [estado_ajuste]        VARCHAR (20)    CONSTRAINT [DF_Ajuste_estado_ajuste] DEFAULT ('Aprobado') NOT NULL,
    [fecha_alta]           DATETIME        NOT NULL,
    [usuario_alta]         VARCHAR (20)    NOT NULL,
    [fecha_modificacion]   DATETIME        NULL,
    [usuario_modificacion] VARCHAR (20)    NULL,
    [fecha_baja]           DATETIME        NULL,
    [usuario_baja]         VARCHAR (20)    NULL,
    [version]              INT             CONSTRAINT [DF_Ajuste_version] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Ajuste] PRIMARY KEY CLUSTERED ([id_ajuste] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_Ajuste_Codigo_Operacion] FOREIGN KEY ([id_codigo_operacion]) REFERENCES [dbo].[Codigo_Operacion] ([id_codigo_operacion]),
    CONSTRAINT [FK_Ajuste_Cuenta] FOREIGN KEY ([id_cuenta]) REFERENCES [dbo].[Cuenta] ([id_cuenta]),
    CONSTRAINT [FK_Ajuste_Motivo_Ajuste] FOREIGN KEY ([id_motivo_ajuste]) REFERENCES [dbo].[Motivo_Ajuste] ([id_motivo_ajuste])
);

