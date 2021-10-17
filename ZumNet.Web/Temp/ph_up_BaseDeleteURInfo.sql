ALTER PROCEDURE [admin].[ph_up_BaseDeleteURInfo]
		@userid			INT
AS

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- 하는일 	: 사용자 삭제
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

if @userid = 0
begin
	RETURN -1
end

UPDATE admin.PH_OBJECT_UR WITH(ROWLOCK)
SET IsLive = 'N'
	, OutDate =  Convert(CHAR(10),getdate(),121)
WHERE UserID = @userid

UPDATE admin.PH_USER_ORGANIZATION WITH(ROWLOCK)
SET PeriodTo =  Convert(CHAR(10),getdate(),121)
WHERE UserID = @userid and PeriodTo IS NULL

UPDATE admin.PH_GROUP_MEMBER WITH(ROWLOCK)
SET LeaveDate = getdate()	
WHERE UserID = @userid and LeaveDate IS NULL

-- 구독 정보 삭제
DELETE FROM admin.PH_XFORM_SUBSCRIPTION WITH(ROWLOCK)
WHERE UserID = @userid





SET NOCOUNT OFF
RETURN


















