ALTER      PROCEDURE [admin].[ph_up_UpdateEAFormNoticeFormSet]
	@formid			VARCHAR(33)
,	@period			SMALLINT
,	@field			VARCHAR(30)
,	@deferment		SMALLINT
,	@mailuse		CHAR(1)

AS
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- 하는일	: 결재 양식 알림 정보 설정
-- 작성자	: 최지훈
-- 작성일	: 2021-09-01
/*
	begin transaction
	EXEC admin.[ph_up_UpdateEAFormNoticeFormSet] '87653197BC014AEDA17F6881894E0260', 1440, 'R', 0, 'Y'
	rollback transaction

	select * from admin.PH_EA_FORM_NOTICE (nolock) where formid = '87653197BC014AEDA17F6881894E0260'
*/
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

IF EXISTS(SELECT FormID FROM admin.PH_EA_FORM_NOTICE (NOLOCK) WHERE FormID = @formid)
BEGIN
    UPDATE admin.PH_EA_FORM_NOTICE SET Period = @period, Field = @field, Deferment = @deferment, MailUse = @mailuse WHERE FormID = @formid    
END
ELSE
BEGIN
    INSERT INTO admin.PH_EA_FORM_NOTICE (FormID, Period, Field, Deferment, MailUse) VALUES (@formid, @period, @field, @deferment, @mailuse)    
END

SET NOCOUNT OFF
RETURN

