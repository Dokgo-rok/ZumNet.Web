ALTER                PROCEDURE [admin].[ph_up_BFHandleEAFormEtcManagement]
(
		@formid						VARCHAR(33)
,		@webEditor					VARCHAR(20)
,		@htmlFile					NVARCHAR(255)
,		@processNameString			VARCHAR(200)
,		@validation					VARCHAR(1000)
)
AS
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- 하는일	: PH_EA_FORMS(양식 관리) 테이블의 정보 테이블 관련 수정
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
	EXEC admin.ph_up_BFHandleEAFormEtcManagement 'F5193E13AB9B4527811B8A87A3D64468', '', '', 'SUGGESTNAME', 'MtextSUGGESTNAME제안명'
	--rollback transaction

	select * from  admin.PH_EA_FORMS with(nolock) where formID = 'F5193E13AB9B4527811B8A87A3D64468'
*/
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

UPDATE admin.PH_EA_FORMS WITH(ROWLOCK)
SET WebEditor = @webEditor
	, HtmlFile = @htmlFile
	, ProcessNameString = @processNameString
WHERE FormID = @formid




SET NOCOUNT OFF
RETURN











