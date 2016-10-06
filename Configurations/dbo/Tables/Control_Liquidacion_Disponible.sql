CREATE TABLE [dbo].[Control_Liquidacion_Disponible] (
    [id_control]            INT             IDENTITY (1, 1) NOT NULL,
    [fecha_base_de_cashout] DATE            NULL,
    [fecha_de_cashout]      DATE            NULL,
    [id_cuenta]             INT             NULL,
    [id_codigo_operacion]   INT             NULL,
    [importe]               DECIMAL (12, 2) NULL,
    CONSTRAINT [PK_Control_Liquidacion_Disponible] PRIMARY KEY CLUSTERED ([id_control] ASC)
);

