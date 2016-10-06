CREATE TABLE [dbo].[Banco] (
    [id_banco]                     INT           NOT NULL,
    [codigo]                       VARCHAR (3)   NULL,
    [denominacion]                 VARCHAR (40)  NOT NULL,
    [logo]                         VARCHAR (200) NULL,
    [fecha_alta]                   DATETIME      NULL,
    [usuario_alta]                 VARCHAR (20)  NULL,
    [fecha_modificacion]           DATETIME      NULL,
    [usuario_modificacion]         VARCHAR (20)  NULL,
    [fecha_baja]                   DATETIME      NULL,
    [usuario_baja]                 VARCHAR (20)  NULL,
    [version]                      INT           CONSTRAINT [DF_Banco_version] DEFAULT ((0)) NOT NULL,
    [flag_cliente_unico]           BIT           CONSTRAINT [DF_Banco_flag_cliente_unico] DEFAULT ((0)) NOT NULL,
    [flag_adherido_billetera]      BIT           CONSTRAINT [DF_Banco_flag_adherido_billetera] DEFAULT ((0)) NOT NULL,
    [flag_envia_relacion]          BIT           CONSTRAINT [DF_Banco_flag_envia_relacion] DEFAULT ((0)) NOT NULL,
    [id_tipo_acreditacion]         INT           CONSTRAINT [DF_Banco_tipo_acreditacion] DEFAULT ((62)) NOT NULL,
    [flag_permite_preautorizacion] BIT           NULL,
    [flag_red_debito]              BIT           NULL,
    [descripcion_corta]            VARCHAR (50)  NULL,
    CONSTRAINT [PK_Banco] PRIMARY KEY CLUSTERED ([id_banco] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [fk_id_tipo_acreditacion] FOREIGN KEY ([id_tipo_acreditacion]) REFERENCES [dbo].[Tipo] ([id_tipo]),
    UNIQUE NONCLUSTERED ([codigo] ASC) WITH (FILLFACTOR = 80)
);

