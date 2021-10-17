ALTER PROCEDURE [admin].[ph_up_BaseUpdateURDetail1Info]
		@userid			INT
,		@personno1		VARCHAR(20)		--주민등록번호 앞자리
,		@personno2		VARCHAR(63)		--주민등록번호 뒷자리시
,		@birth			CHAR(10)		--생년월일
,		@birthtype		CHAR(1)			--양력:1/음력:2
,		@mobile			VARCHAR(30)		--휴대폰
,		@telephone		VARCHAR(30)		--사무실전화
,		@keyword1		NVARCHAR(100)
,		@keyword2		NVARCHAR(100)
,		@keyword3		NVARCHAR(100)
,		@keyword4		NVARCHAR(100)
,		@keyword5		NVARCHAR(100)
,		@keyword6		NVARCHAR(100)
,		@keyword7		NVARCHAR(100)
AS

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- 하는일 	: 사용자 상세 정보1 수정
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

-- 상세 정보 업데이트
UPDATE admin.PH_USER_DETAIL WITH(ROWLOCK)
SET PersonNo1 = @personno1
	, Birth = @birth
	, BirthType = @birthtype
	, Mobile = @mobile
	, Telephone = @telephone
	, Keyword1 = @keyword1
	, Keyword2 = @keyword2
	, Keyword3 = @keyword3
	, Keyword4 = @keyword4
	, Keyword5 = @keyword5
	, Keyword6 = @keyword6
	, Keyword7 = @keyword7
WHERE UserID = @userid


-- 주민등록 번호 뒷자리는 패스워드 필드의 특성상 따로 변경여부에 따라서 업데이트 한다.
IF @personno2 <> ''
BEGIN
	UPDATE admin.PH_USER_DETAIL WITH(ROWLOCK) SET PersonNo2 =@personno2 WHERE UserID = @userid
END

SET NOCOUNT OFF
RETURN


















