alter                                       Proc [admin].[ph_up_BaseGradeCodeHandler]
			@action_kind		CHAR(10)	--cmd_gd_new: 생성, cmd_gd_mod:수정, cmd_gd_rem:삭제
,			@dn_id			SMALLINT		
,			@type			CHAR(1)
,			@code			VARCHAR(3)
,			@new_type		CHAR(1)
,			@new_code		VARCHAR(3)
,			@codename		NVARCHAR(50)
,			@inuse			CHAR(1)
,			@remove_info		NTEXT
AS
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-- 하는일	: PH_GRADE_CODE 테이블의 생성 및 변경, 삭제
-- 작성자	: 강한주
-- 작성일	: 2005-09-08
-- 컴퍼넌트	: phs.ObjectMain.DomainManager
-- 메소드	: HandleGradeCode
-- 참조하는 SP	: 
-- 참조되는 SP	:
-- 실  행 	: 
/*	
	begin tran	
	declare @remove_info		nvarchar(4000)
	SET @remove_info = N'<remove_info>
				<grade type="A" code="A1"/>
				<grade type="A" code="A2"/>
				<grade type="A" code="B1"/>
				<grade type="A" code="E2"/>
				<grade type="A" code="N1"/>
				<grade type="A" code="O1"/>
			</remove_info>'

	EXEC admin.ph_up_BaseGradeCodeHandler 'cmd_gd_new', 1, 'A', '', '', '111', '111', 'Y', ''
	--rollback
	SELECT * FROM admin.PH_GRADE_CODE (NOLOCK)

	SELECT * FROM PH_FOLDER_INSTANCE	
*/
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
set nocount on
set transaction isolation level read committed


DECLARE @usage_state		CHAR(1)
	
	IF @inuse = 'Y'
	BEGIN
		SET @usage_state = 'A'
	END
	ELSE
	BEGIN
		SET @usage_state = 'B'
	END

IF @action_kind ='cmd_gd_mod'
BEGIN
	-- PH_GRADE_CODE 테이블에 직급 기본정보 변경
	UPDATE admin.PH_GRADE_CODE WITH(ROWLOCK) 
	SET Type = @new_type, Code = @new_code, CodeName= @codename, InUse = @inuse
	WHERE DN_ID = @dn_id AND Type = @type AND Code = @code
/*
	-- 결재 정보 반영
	IF @type = 'A'
	BEGIN
		-- 기존 직위와 변경된 직위가 같으면 해당 정보 업데이트
		IF @new_type = 'A'
		BEGIN
			UPDATE coviorg.dbo.ORG_JOBPOSITION WITH(ROWLOCK) 
			SET PSTN_CODE = @new_code, NAME = @codename, USAGE_STATE = @usage_state
		
			UPDATE coviorg.dbo.ORG_JOBTITLE WITH(ROWLOCK) 
			SET TITLE_CODE = @new_code, NAME = @codename, USAGE_STATE = @usage_state
		END
		-- 기존 직위를 새로운 직급으로 변경시에는 기존 직위를 삭제하고, 변경된 직급을 새로 입력
		ELSE IF @new_type = 'B'
		BEGIN
			DELETE FROM coviorg.dbo.ORG_JOBPOSITION WITH(ROWLOCK) 
			WHERE PSTN_CODE = @code AND ENT_CODE = @dn_id

			DELETE FROM coviorg.dbo.ORG_JOBTITLE WITH(ROWLOCK) 
			WHERE TITLE_CODE = @code AND ENT_CODE = @dn_id

			INSERT INTO coviorg.dbo.ORG_JOBLEVEL WITH(ROWLOCK) (LEVEL_CODE, ENT_CODE, NAME, USAGE_STATE)
			VALUES (@new_code, @dn_id, @codename, @usage_state)
		END
		-- 기존 직위를 직위2 이상으로 변경시에는 해당 사항 없으므로 기존 직위만 삭제
		ELSE
		BEGIN
			DELETE FROM coviorg.dbo.ORG_JOBPOSITION WITH(ROWLOCK) 
			WHERE PSTN_CODE = @code AND ENT_CODE = @dn_id		

			DELETE FROM coviorg.dbo.ORG_JOBTITLE WITH(ROWLOCK) 
			WHERE TITLE_CODE = @code AND ENT_CODE = @dn_id		
		END
	END
	ELSE IF @type = 'B'
	BEGIN
		-- 기존 직급과 변경된 직급이 같으면 해당 정보 업데이트
		IF @new_type = 'B'
		BEGIN
			UPDATE coviorg.dbo.ORG_JOBLEVEL WITH(ROWLOCK) 
			SET LEVEL_CODE = @new_code, NAME = @codename, USAGE_STATE = @usage_state
		END
		-- 기존 직급을 새로운 직위로 변경시에는 기존 직급을 삭제하고, 변경된 직위를 새로 입력
		ELSE IF @new_type = 'A'
		BEGIN
			DELETE FROM coviorg.dbo.ORG_JOBLEVEL WITH(ROWLOCK) 
			WHERE LEVEL_CODE = @code AND ENT_CODE = @dn_id

			INSERT INTO coviorg.dbo.ORG_JOBPOSITION WITH(ROWLOCK) (PSTN_CODE, ENT_CODE, NAME, USAGE_STATE)
			VALUES (@new_code, @dn_id, @codename, @usage_state)

			INSERT INTO coviorg.dbo.ORG_JOBTITLE WITH(ROWLOCK) (TITLE_CODE, ENT_CODE, NAME, USAGE_STATE)
			VALUES (@new_code, @dn_id, @codename, @usage_state)
		END
		-- 기존 직급을 직위2 이상으로 변경시에는 해당 사항 없으므로 기존 직급만 삭제
		ELSE
		BEGIN
			DELETE FROM coviorg.dbo.ORG_JOBLEVEL WITH(ROWLOCK) 
			WHERE LEVEL_CODE = @code AND ENT_CODE = @dn_id
		END
	END
*/
END
ELSE IF @action_kind ='cmd_gd_new'
BEGIN
	INSERT INTO admin.PH_GRADE_CODE WITH(ROWLOCK) (DN_ID, Type, Code, CodeName, InUse)
	VALUES (@dn_id, @new_type, @new_code, @codename, @inuse)
/*
	-- 결재 정보 반영		
	IF @new_type = 'A'
	BEGIN
		INSERT INTO coviorg.dbo.ORG_JOBPOSITION WITH(ROWLOCK) (PSTN_CODE, ENT_CODE, NAME, USAGE_STATE)
		VALUES (@new_code, @dn_id, @codename, @usage_state)

		INSERT INTO coviorg.dbo.ORG_JOBTITLE WITH(ROWLOCK) (TITLE_CODE, ENT_CODE, NAME, USAGE_STATE)
		VALUES (@new_code, @dn_id, @codename, @usage_state)
	END
	ELSE IF @new_type = 'B'
	BEGIN
		INSERT INTO coviorg.dbo.ORG_JOBLEVEL WITH(ROWLOCK) (LEVEL_CODE, ENT_CODE, NAME, USAGE_STATE)
		VALUES (@new_code, @dn_id, @codename, @usage_state)
	END
*/
END
ELSE IF @action_kind ='cmd_gd_rem'
BEGIN
	DECLARE 	@hDoc 			INT
		
	EXEC sp_xml_preparedocument @hDoc OUTPUT, @remove_info	
	
	-- 만일의 경우를 대비해서 해당 DN에 한번이라도 사용된것은 제외하고 삭제한다.
	DELETE 	admin.PH_GRADE_CODE WITH(ROWLOCK)
	FROM admin.PH_GRADE_CODE a 
		INNER JOIN OPENXML (@hDoc, '//remove_info/grade', 2)
				WITH (	Type		CHAR(1)		'@type',
					Code		VARCHAR(3)	'@code') b
		ON  a.Type = b.Type AND a.Code = b.Code	
		LEFT OUTER JOIN (SELECT cc.DN_ID, aa.GradeType, aa.GradeCode, aa.PeriodTo
					FROM admin.ph_VIEW_BASE_USER_GRADE aa (NOLOCK)
					INNER JOIN admin.PH_OBJECT_UR bb (NOLOCK)
					ON aa.UserID = bb.UserID
					INNER JOIN admin.PH_DOMAIN cc (NOLOCK)
					ON bb.DNAlias =  cc.DNAlias) c
		ON a.DN_ID = c.DN_ID AND b.Type = c.GradeType AND b.Code = c.GradeCode
		WHERE a.DN_ID = @dn_id AND c.DN_ID IS NULL
/*
	-- 결재 정보 반영
	DELETE FROM coviorg.dbo.ORG_JOBPOSITION WITH(ROWLOCK)
	FROM coviorg.dbo.ORG_JOBPOSITION a(NOLOCK)
	INNER JOIN OPENXML (@hDoc, '//remove_info/grade', 2)
				WITH (	Type		CHAR(1)		'@type',
					Code		VARCHAR(3)	'@code') b
	ON PSTN_CODE = b.Code AND b.Type = 'A' AND ENT_CODE = @dn_id

	DELETE FROM coviorg.dbo.ORG_JOBTITLE WITH(ROWLOCK)
	FROM coviorg.dbo.ORG_JOBTITLE a(NOLOCK)
	INNER JOIN OPENXML (@hDoc, '//remove_info/grade', 2)
				WITH (	Type		CHAR(1)		'@type',
					Code		VARCHAR(3)	'@code') b
	ON TITLE_CODE = b.Code AND b.Type = 'A' AND ENT_CODE = @dn_id

	DELETE FROM coviorg.dbo.ORG_JOBLEVEL WITH(ROWLOCK)
	FROM coviorg.dbo.ORG_JOBLEVEL a(NOLOCK)
	INNER JOIN OPENXML (@hDoc, '//remove_info/grade', 2)
				WITH (	Type		CHAR(1)		'@type',
					Code		VARCHAR(3)	'@code') b
	ON LEVEL_CODE = b.Code AND b.Type = 'B' AND ENT_CODE = @dn_id
*/	
	EXEC sp_xml_removedocument @hDoc	-- Dom Document Release
END
		
SET NOCOUNT OFF
RETURN














