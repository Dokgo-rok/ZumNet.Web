ALTER                    PROCEDURE [admin].[ph_up_BFChangeProcessActivityStep]
		@stepjson			NVARCHAR(MAX)

AS
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- 하는일	: 프로세스 정의의 순번/하위 순번을 변경한다.
-- 작성자	: 
-- 작성일	: 
-- 주의사항	: 
-- 컴퍼넌트	: 없음
-- 메소드	: 없음
-- 참조하는 SP	: 
-- 참조되는 SP	:
-- 사용 Table	:
/*

	begin transaction

	DECLARE @stepjson NVARCHAR(MAX)
	SET @stepjson =   
	  N'[
		{
			"ActivityID" : "3D6D96ECBB544C8689A8409A7DBBB944",
			"ParentActivityID" : "F0912E7B497D4F79BD39A4034DEF1185",
			"Step" : 1,
			"SubStep" : 0,
			"InLine" : "N"
		},
		{
			"ActivityID" : "F218BFFA20C64865A1D01D72C931E71C",
			"ParentActivityID" : "F0912E7B497D4F79BD39A4034DEF1185",
			"Step" : 2,
			"SubStep" : 0,
			"InLine" : "N"
		},
		{
			"ActivityID" : "70B880891F1442039FD55BD6242F99FB",
			"ParentActivityID" : "F0912E7B497D4F79BD39A4034DEF1185",
			"Step" : 3,
			"SubStep" : 0,
			"InLine" : "N"
		}
	]'  
	
	EXEC admin.[ph_up_BFChangeProcessActivityStep] @stepjson
	
	rollback transaction

	select top 10 * from  admin.BF_PROCESS_ACTIVITY with(nolock) where processid = 9111 order by step asc
*/
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

IF @stepjson <> '' and ISJSON(@stepjson) > 0
BEGIN
	UPDATE PA
	SET PA.Step = M.Step
		, PA.SubStep = M.SubStep
		, PA.ParentActivityID = M.ParentActivityID
		, PA.Inline = M.InLine
	FROM admin.BF_PROCESS_ACTIVITY PA with(ROWLOCK)
	INNER JOIN OPENJSON ( @stepjson )  
	WITH (   
		ActivityID				varchar(33)		'$.ActivityID',  
		ParentActivityID		varchar(33)		'$.ParentActivityID',  
		Step					smallint		'$.Step',  
		SubStep					smallint        '$.SubStep',
		InLine					char(1)			'$.InLine'
	) AS M
	ON PA.ActivityID = M.ActivityID
END


SET NOCOUNT OFF
RETURN




