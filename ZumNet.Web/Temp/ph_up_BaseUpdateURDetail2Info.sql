CREATE PROCEDURE [admin].[ph_up_BaseUpdateURDetail2Info]
		@userid			INT
,		@fax			VARCHAR(30)		
,		@homephone		VARCHAR(30)		--집전화
,		@homepage		NVARCHAR(255)		--홈페이지
,		@themepath		TINYINT			--테마경로
,		@zipcode1		VARCHAR(10)		--우편번호(자택)
,		@address1		NVARCHAR(100)		--주소(자택)
,		@detailaddress1		NVARCHAR(100)		--상세주소(자택)
,		@company		NVARCHAR(100)		--회사이름
,		@zipcode2		VARCHAR(10)		--우편번호(회사)
,		@address2		NVARCHAR(100)		--주소(회사)
,		@detailaddress2		NVARCHAR(100)		--상세주소(회사)

AS

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- 하는일 	: 사용자 상세 정보2 수정
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
SET Fax = @fax
	, Homephone = @homephone
	, Homepage = @homepage
	, ZipCode1 = @zipcode1
	, Address1 = @address1
	, DetailAddress1 = @detailaddress1
	, Company = @company
	, ZipCode2 = @zipcode2
	, Address2 = @address2
	, DetailAddress2 = @detailaddress2
WHERE UserID = @userid



SET NOCOUNT OFF
RETURN


















