ALTER PROCEDURE [admin].[ph_up_BaseUpdateURBasicInfo]
		@userid			INT
,		@displayname	NVARCHAR(100)
,		@longname		NVARCHAR(100)		--전체이름
,		@fname			NVARCHAR(50)		--이름
,		@lname			NVARCHAR(50)		--성
,		@empid			VARCHAR(30)		--사번
,		@indate			CHAR(10)		--입사일
,		@secondmail		VARCHAR(30)		--보조메일계정
,		@gradecode1		VARCHAR(10)
,		@gradecode2		VARCHAR(10)
,		@gradecode3		VARCHAR(10)
,		@gradecode4		VARCHAR(10)
,		@gradecode5		VARCHAR(10)
,		@isgw			CHAR(1) 
,		@ispdm			CHAR(1)
,		@iserp			CHAR(1)
,		@ismsg			CHAR(1)
AS

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- 하는일 	: 사용자 기본 정보 수정
-- 작성자 	: 최지훈
-- 작성일 	: 2021-10-02
-- 컴퍼넌트	: 
-- 메소드	: 
-- 참조하는 SP	: 
-- 참조되는 SP	: 
-- 실   행 : 
/*

*/
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--소속그룹 아이디 가져오기(주로 부서)

if @userid = 0
begin
	RETURN -1
end

-- 기본 정보 업데이트
UPDATE admin.PH_OBJECT_UR
SET DisplayName = @displayname
	, LongName = @longname
	, FirstName = @fname
	, LastName = @lname
	, EmpID = @empid
	, InDate = @indate
	, SecondMail = @secondmail
	, IsGW = @isgw
	, IsPDM = @ispdm
	, IsERP = @iserp
	, IsMSG = @ismsg
WHERE UserID = @userid


-- 직위/직급 업데이트
/**** 사용자 등급 처리 PROCESS***********/
--1. 기존에 사용하던 등급과의 변동 여부확인
--2. 생성일(PeriodFrom)과 동일일에 변경시는 버젼관리 없이 해당 Row 업데이트
--3. 생성일 이후에 변경시는 기존Row에 PeriodTo 입력, 변경된 사항 INSERT
/***************************************/

IF (SELECT COUNT(*) FROM admin.PH_USER_ORGANIZATION WITH(NOLOCK) 
	WHERE UserID = @userid AND (PeriodTo IS NULL OR PeriodTo='') AND GradeCode1=@gradecode1 
		AND GradeCode2=@gradecode2 AND GradeCode3=@gradecode3
		AND GradeCode4=@gradecode4 AND GradeCode5=@gradecode5) = 0
BEGIN
	--생성일과 동일한 날짜에 변경
	IF (SELECT COUNT(*) FROM admin.PH_USER_ORGANIZATION WITH(NOLOCK) 
		WHERE UserID = @userid AND (PeriodTo IS NULL OR PeriodTo='') AND PeriodFrom= Convert(CHAR(10),getdate(),121)) = 1
	BEGIN
		UPDATE admin.PH_USER_ORGANIZATION WITH(ROWLOCK)
			SET GradeCode1 = @gradecode1
				, GradeCode2 = @gradecode2
				, GradeCode3 = @gradecode3
			    , GradeCode4 = @gradecode4
				, GradeCode5 = @gradecode5
			WHERE UserID = @userid AND (PeriodTo IS NULL OR PeriodTo='') 
	END
	ELSE
	BEGIN
		DECLARE @parent_grid		INT

		SELECT @parent_grid = (SELECT GR_ID FROM admin.PH_USER_ORGANIZATION WITH(NOLOCK) where UserID = @userid AND (PeriodTo IS NULL OR PeriodTo=''))

		UPDATE admin.PH_USER_ORGANIZATION WITH(ROWLOCK)
			SET PeriodTo = Convert(CHAR(10),getdate(),121)
			WHERE UserID = @userid AND (PeriodTo IS NULL OR PeriodTo='') 
		
		--겸직 경우에는 모든 항목이 PeriodTo 에 널값이 들어감으로 현재 부서에 해당하는 직위/직책만 널 처리 한다(2016-04-21)
		UPDATE admin.PH_USER_ORGANIZATION WITH(ROWLOCK)
			SET PeriodTo = Convert(CHAR(10),getdate(),121)
			WHERE UserID = @userid AND GR_ID = @parent_grid AND (PeriodTo IS NULL OR PeriodTo='') 

		INSERT INTO admin.PH_USER_ORGANIZATION WITH(ROWLOCK) (UserID, GR_ID, PeriodFrom, GradeCode1, GradeCode2, GradeCode3, GradeCode4, GradeCode5)
			VALUES(@userid, @parent_grid, Convert(CHAR(10),getdate(),121), @gradecode1, @gradecode2, @gradecode3,@gradecode4, @gradecode5)		
	END
END


SET NOCOUNT OFF
RETURN


















