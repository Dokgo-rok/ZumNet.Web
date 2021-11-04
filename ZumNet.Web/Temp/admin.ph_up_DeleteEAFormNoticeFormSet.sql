CREATE      PROCEDURE [admin].[ph_up_DeleteEAFormNoticeFormSet]
	@formid			VARCHAR(33)

AS
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- 하는일	: 결재 양식 알림 정보 제거
-- 작성자	: 최지훈
-- 작성일	: 2021-09-01
/*
	begin transaction
	EXEC admin.[ph_up_DeleteEAFormNoticeFormSet] '87653197BC014AEDA17F6881894E0260'
	rollback transaction

	select * from admin.PH_EA_FORM_NOTICE (nolock) where formid = '87653197BC014AEDA17F6881894E0260'
*/
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

IF @formid <> ''
BEGIN
    DELETE FROM admin.PH_EA_FORM_NOTICE WHERE FormID = @formid 
END
ELSE
BEGIN
	-- 전체 삭제
    DELETE FROM admin.PH_EA_FORM_NOTICE WHERE 1 = 1
END

SET NOCOUNT OFF
RETURN

