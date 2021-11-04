ALTER      PROCEDURE [admin].[ph_up_SelectEAFormNotice]
	@formid			VARCHAR(33)
AS
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- 하는일	: 결재 양식 알림 정보 조회
-- 작성자	: 최지훈
-- 작성일	: 2021-09-01
/*
	begin transaction
	EXEC admin.[ph_up_SelectEAFormNotice] ''
	EXEC admin.[ph_up_SelectEAFormNotice] '87653197BC014AEDA17F6881894E0260'
	rollback transaction

	select * from admin.PH_EA_FORM_NOTICE (nolock) where formid = '87653197BC014AEDA17F6881894E0260'
*/
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

IF @formid <> ''
BEGIN
	SELECT a.FormID, a.ClassID, a.DocName, REPLACE(a.MainTable, 'FORM_', '') AS 'MainTable', a.Usage
		, a.Version, b.Period, b.Field, b.Deferment, b.MailUse, b.MsgUse, b.PushUse
		, CASE WHEN b.FormID IS NULL THEN 'N' ELSE 'Y' END AS 'FormSet'
	FROM admin.PH_EA_FORMS a (NOLOCK)
	LEFT OUTER JOIN admin.PH_EA_FORM_NOTICE b (NOLOCK)
	ON a.FormID = b.FormID
	WHERE a.FormID = @formid
	ORDER BY DocName, Version
END
ELSE
BEGIN
	SELECT a.FormID, a.ClassID, a.DocName, REPLACE(a.MainTable, 'FORM_', '') AS 'MainTable', a.Usage
		, a.Version, b.Period, b.Field, b.Deferment, b.MailUse, b.MsgUse, b.PushUse
		, CASE WHEN b.FormID IS NULL THEN 'N' ELSE 'Y' END AS 'FormSet'
	FROM admin.PH_EA_FORMS a (NOLOCK)
	LEFT OUTER JOIN admin.PH_EA_FORM_NOTICE b (NOLOCK)
	ON a.FormID = b.FormID
	ORDER BY DocName, Version
END

SET NOCOUNT OFF
RETURN

