CREATE PROCEDURE [dbo].[GenerarId]     
 (             
    @sFieldName   VARCHAR(100),
    @sTableName   VARCHAR(100),
    @idSalida   INT OUTPUT
  )          
AS     
BEGIN  
 DECLARE @SQLString NVARCHAR(1000)
 DECLARE @ParmDefinition NVARCHAR(1000)
 DECLARE @Id INT

 SET @SQLString = N'SELECT @IdOUT = isnull(max([' + @sFieldName + ']),0)+1
     FROM [' + @sTableName + '] '
 SET @ParmDefinition = N'@IdOUT varchar(30) OUTPUT'
 
 EXECUTE sp_executesql
       @SQLString,
       @ParmDefinition,
       @IdOUT=@Id OUTPUT

 SELECT @idSalida = @Id

END

