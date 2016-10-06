CREATE TABLE [dbo].[Motivo_Ajuste] (
    [id_motivo_ajuste]     INT           NOT NULL,
    [codigo]               VARCHAR (15)  NOT NULL,
    [descripcion]          VARCHAR (MAX) NOT NULL,
    [fecha_alta]           DATETIME      NOT NULL,
    [usuario_alta]         VARCHAR (20)  NOT NULL,
    [fecha_modificacion]   DATETIME      NULL,
    [usuario_modificacion] VARCHAR (20)  NULL,
    [fecha_baja]           DATETIME      NULL,
    [usuario_baja]         VARCHAR (20)  NULL,
    [version]              INT           CONSTRAINT [DF_Motivo_Ajuste_version] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Motivo_Ajuste] PRIMARY KEY CLUSTERED ([id_motivo_ajuste] ASC) WITH (FILLFACTOR = 80)
);

