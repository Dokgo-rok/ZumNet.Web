-- ALTER DATABASE PHEKP_CRESYN SET COMPATIBILITY_LEVEL = 130

ALTER      PROCEDURE [admin].[ph_up_UpdateEAFormChargeJson]
	@formid			VARCHAR(33)
,	@chargejson		NVARCHAR(MAX)
AS
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- 하는일	: 결재 양식 담당부서/담당자 설정
-- 작성자	: 최지훈
-- 작성일	: 2021-08-30
/*
	begin transaction

	DECLARE @chargejson NVARCHAR(MAX)
	SET @chargejson =   
	  N'[
		{
			"ChargeID" : 1354,
			"ObjectType" : "GR",
			"Seq" : 1,
			"ChargeDeptID" : 0,
			"Reserved1" : ""
		},
		{
			"ChargeID" : 101361,
			"ObjectType" : "UR",
			"Seq" : 1,
			"ChargeDeptID" : 1478,
			"Reserved1" : ""
		}
	]'  
	EXEC admin.[ph_up_UpdateEAFormChargeJson] 'EBD6A28AE4EE4BA0A6AF0F2CC2D7F1C7', @chargejson
	
	rollback transaction

	select * from admin.ph_ea_form_charge (nolock) where formid = '4FD18826D0624DA4A1C07DA2351EF0E8'
	select * from admin.ph_ea_forms (nolock) where formid = '4FD18826D0624DA4A1C07DA2351EF0E8'
*/
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

IF @formid <> '' and @chargejson <> '' and ISJSON(@chargejson) > 0
BEGIN
	-- 기존에 있으면 먼저 삭제
	DELETE FROM admin.PH_EA_FORM_CHARGE WITH (ROWLOCK)
	WHERE FormID = @formid

	INSERT INTO admin.PH_EA_FORM_CHARGE (FormID, ChargeID, ObjectType, Seq, ChargeDeptID, CreateDate, Reserved1)
	SELECT @formid
		, M.ChargeID
		, M.ObjectType
		, M.Seq
		, M.ChargeDeptID
		, GETDATE()
		, M.Reserved1
	FROM OPENJSON ( @chargejson )  
	WITH (   
		ChargeID		int				'$.ChargeID',  
		ObjectType		char(2)			'$.ObjectType',  
		Seq				smallint        '$.Seq',  
		ChargeDeptID	int				'$.ChargeDeptID',  
		Reserved1		nvarchar(4000)  '$.Reserved1'
	) AS M
END

SET NOCOUNT OFF
RETURN

