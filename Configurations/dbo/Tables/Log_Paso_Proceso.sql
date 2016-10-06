﻿CREATE TABLE [dbo].[Log_Paso_Proceso] (
    [id_log_paso]            INT             IDENTITY (1, 1) NOT NULL,
    [id_log_proceso]         INT             NULL,
    [id_paso_proceso]        INT             NULL,
    [fecha_inicio_ejecucion] DATETIME        NULL,
    [fecha_fin_ejecucion]    DATETIME        NULL,
    [descripcion]            VARCHAR (25)    NULL,
    [archivo_entrada]        VARCHAR (256)   NULL,
    [archivo_salida]         VARCHAR (256)   NULL,
    [resultado_proceso]      BIT             NULL,
    [motivo_rechazo]         VARCHAR (100)   NULL,
    [registros_procesados]   INT             NULL,
    [importe_procesados]     DECIMAL (12, 2) NULL,
    [registros_aceptados]    INT             NULL,
    [importe_aceptados]      DECIMAL (12, 2) NULL,
    [registros_rechazados]   INT             NULL,
    [importe_rechazados]     DECIMAL (12, 2) NULL,
    [registros_salida]       INT             NULL,
    [importe_salida]         DECIMAL (12, 2) NULL,
    [fecha_alta]             DATETIME        NULL,
    [usuario_alta]           VARCHAR (20)    NULL,
    [fecha_modificacion]     DATETIME        NULL,
    [usuario_modificacion]   VARCHAR (20)    NULL,
    [fecha_baja]             DATETIME        NULL,
    [usuario_baja]           VARCHAR (20)    NULL,
    [version]                INT             CONSTRAINT [DF_Log_Paso_Proceso_version] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Log_Paso_Proceso] PRIMARY KEY CLUSTERED ([id_log_paso] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_Log_Paso_Proceso_Log_Proceso] FOREIGN KEY ([id_log_proceso]) REFERENCES [dbo].[Log_Proceso] ([id_log_proceso]),
    CONSTRAINT [FK_Log_Paso_Proceso_Paso_Proceso] FOREIGN KEY ([id_paso_proceso]) REFERENCES [dbo].[Paso_Proceso] ([id_paso_proceso])
);

