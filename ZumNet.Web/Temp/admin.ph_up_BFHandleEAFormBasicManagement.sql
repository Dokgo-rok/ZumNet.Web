ALTER                    PROCEDURE [admin].[ph_up_BFHandleEAFormBasicManagement]
(
		@command					VARCHAR(6)
,		@domainid					INT
,		@formid						VARCHAR(33)
,		@classid					INT
,		@processid					INT
,		@docname					NVARCHAR(100)
,		@description				NVARCHAR(1000)
,		@selectable					CHAR(1)
,		@xslname					VARCHAR(100)
,		@cssname					VARCHAR(100)
,		@jsname						VARCHAR(100)
,		@usage						CHAR(1)
,		@mainTable					VARCHAR(100)
)
AS
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- 하는일	: PH_EA_FORMS(양식 관리) 테이블에 정보를 생성, 수정, 삭제한다.(Reserved1,2는 따로 관리된다)
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
	EXEC admin.ph_up_BFHandleEAFormBasicManagement 'create', 1, 'testtest1', 0, 0, N'testtest1', N'description', 'N', '', '', '', '0', 'FORM_TESTTEST1'
	--rollback transaction

	select * from  admin.PH_EA_FORMS with(nolock) where docname like '%test%'
*/
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

DECLARE @sql		NVARCHAR(MAX)
,		@dnalias	NVARCHAR(100)

SET @dnalias = ''
SELECT @dnalias = DNAlias FROM admin.PH_DOMAIN (NOLOCK) WHERE DN_ID = @domainid

IF @command = 'create'
BEGIN
	INSERT INTO admin.PH_EA_FORMS WITH(ROWLOCK)
	(FormID, DN_ID, ClassID, ProcessID, DocName, Description, XslName, CssName, JsName, Usage, Selectable, MainTable
		, Version, MainTableDef, SubTableCount, IsCommon, WebEditor, Limited, ProcessNameString, Validation)
	VALUES
	(@formid, @domainid, @classid, @processid, @docname, @description, @xslname, @cssname, @jsname, @usage, @selectable, @mainTable
		, 1, '', 0, '', '', 'N', '', '')
END
ELSE IF @command = 'modify'
BEGIN
	UPDATE admin.PH_EA_FORMS WITH(ROWLOCK)
	SET ClassID = @classid
		, ProcessID = @processid
		, DocName = @docname
		, Description = @description
		, CssName = @cssname
		, JsName = @jsname
		, Usage = @usage
		, Selectable = @selectable
	WHERE FormID = @formid AND DN_ID = @domainid
END






SET NOCOUNT OFF
RETURN










