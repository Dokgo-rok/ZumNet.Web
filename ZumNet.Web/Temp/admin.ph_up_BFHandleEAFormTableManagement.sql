ALTER                    PROCEDURE [admin].[ph_up_BFHandleEAFormTableManagement]
(
		@command					CHAR(2)
,		@formid						VARCHAR(33)
,		@tableDef					NTEXT
,		@tableCount					TINYINT
,		@usage						CHAR(1)
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
	EXEC admin.ph_up_BFHandleEAFormTableManagement 'M', '82F242C1A3CA4A78B6D83A5B9F37B78F'
	, N'<maintable><field><name>LOGOPATH</name><label>로고</label><type>nvarchar</type><length>200</length><default></default><isnull>null</isnull></field><field><name>EQUIPNAME</name><label>설비명</label><type>nvarchar</type><length>200</length><default></default><isnull>null</isnull></field><field><name>MAKER</name><label>MAKER</label><type>nvarchar</type><length>200</length><default></default><isnull>null</isnull></field><field><name>ORDERDATE</name><label>발주일</label><type>nvarchar</type><length>200</length><default></default><isnull>null</isnull></field><field><name>RECEIVEDATE</name><label>입고예정일</label><type>nvarchar</type><length>200</length><default></default><isnull>null</isnull></field><field><name>CHECKPERSON</name><label>검수자</label><type>nvarchar</type><length>200</length><default></default><isnull>null</isnull></field><field><name>CHECKDATE</name><label>검수일</label><type>nvarchar</type><length>200</length><default></default><isnull>null</isnull></field><field><name>ENTRYTYPE</name><label>검수단계</label><type>nvarchar</type><length>200</length><default></default><isnull>null</isnull></field><field><name>CHECKRESULT</name><label>검수결과</label><type>nvarchar</type><length>200</length><default></default><isnull>null</isnull></field><field><name>DESCRIPITON</name><label>특기사항</label><type>nvarchar</type><length>2000</length><default></default><isnull>null</isnull></field></maintable>'
	--rollback transaction

	select * from  admin.PH_EA_FORMS with(nolock) where maintable = 'FORM_SYSTEMADDREQ'

	<subtables><subtable1 cnt="5"><field><name>CORPORATION</name><label>법인명</label><type>nvarchar</type><length>20</length><default></default><isnull>null</isnull></field><field><name>DEPARTMENT</name><label>부서명</label><type>nvarchar</type><length>50</length><default></default><isnull>null</isnull></field><field><name>APPLICANTID</name><label>사용자아이디</label><type>nvarchar</type><length>20</length><default></default><isnull>null</isnull></field><field><name>DOCSECURE</name><label>문서보안</label><type>nvarchar</type><length>20</length><default></default><isnull>null</isnull></field><field><name>CHECKPERIOD</name><label>기간1</label><type>nvarchar</type><length>20</length><default></default><isnull>null</isnull></field><field><name>FROMDATE</name><label>기간2</label><type>nvarchar</type><length>20</length><default></default><isnull>null</isnull></field><field><name>TODATE</name><label>기간3</label><type>nvarchar</type><length>20</length><default></default><isnull>null</isnull></field><field><name>REASON</name><label>사유</label><type>nvarchar</type><length>200</length><default></default><isnull>null</isnull></field></subtable1><subtable2 cnt="5"><field><name>CORPORATION</name><label>법인명</label><type>nvarchar</type><length>20</length><default></default><isnull>null</isnull></field><field><name>DEPARTMENT</name><label>부서명</label><type>nvarchar</type><length>50</length><default></default><isnull>null</isnull></field><field><name>APPLICANTID</name><label>사용자아이디</label><type>nvarchar</type><length>20</length><default></default><isnull>null</isnull></field><field><name>IPCON1</name><label>아이피1</label><type>nvarchar</type><length>10</length><default></default><isnull>null</isnull></field><field><name>IPCON2</name><label>아이피2</label><type>nvarchar</type><length>10</length><default></default><isnull>null</isnull></field><field><name>CHECKPERIOD</name><label>기한1</label><type>nvarchar</type><length>20</length><default></default><isnull>null</isnull></field><field><name>FROMDATE1</name><label>기한2</label><type>nvarchar</type><length>20</length><default></default><isnull>null</isnull></field><field><name>TODATE1</name><label>기한3</label><type>nvarchar</type><length>20</length><default></default><isnull>null</isnull></field><field><name>REASON</name><label>사유</label><type>nvarchar</type><length>200</length><default></default><isnull>null</isnull></field></subtable2><subtable3 cnt="5"><field><name>CORPORATION</name><label>법인명</label><type>nvarchar</type><length>20</length><default></default><isnull>null</isnull></field><field><name>DEPARTMENT</name><label>부서명</label><type>nvarchar</type><length>50</length><default></default><isnull>null</isnull></field><field><name>APPLICANTID</name><label>사용자아이디</label><type>nvarchar</type><length>20</length><default></default><isnull>null</isnull></field><field><name>APPLICANTEMPNO</name><label>사번</label><type>nvarchar</type><length>20</length><default></default><isnull>null</isnull></field><field><name>ERPCLASS1</name><label>분류1</label><type>nvarchar</type><length>30</length><default></default><isnull>null</isnull></field><field><name>ERPCLASS2</name><label>분류2</label><type>nvarchar</type><length>30</length><default></default><isnull>null</isnull></field><field><name>REASON</name><label>사유</label><type>nvarchar</type><length>300</length><default></default><isnull>null</isnull></field></subtable3></subtables>
*/
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

IF @command = 'MT'
-- 메인 테이블 정의 업데이트
BEGIN
	UPDATE admin.PH_EA_FORMS WITH(ROWLOCK)
	SET MainTableDef = @tableDef
	WHERE FormID = @formid
END
ELSE IF @command = 'US'
-- USAGE 필드 정의 업데이트
BEGIN
	UPDATE admin.PH_EA_FORMS WITH(ROWLOCK)
	SET Usage = @usage
	WHERE FormID = @formid
END
ELSE IF @command = 'ST'
-- 하위 테이블 정의 업데이트
BEGIN
	UPDATE admin.PH_EA_FORMS WITH(ROWLOCK)
	SET SubTableDef = @tableDef
		, SubTableCount = @tableCount
	WHERE FormID = @formid
END




SET NOCOUNT OFF
RETURN











