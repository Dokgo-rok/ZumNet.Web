using System;
using System.Configuration;
using System.IO;
using System.Text;

using ZumNet.Framework.Configuration;
using ZumNet.Framework.Exception;
using ZumNet.Framework.Log;
using ZumNet.Framework.Util;
using DSAPILib;

namespace DocSecurity.App_Code
{
    /// <summary>
    /// SoftcampDS
    /// </summary>
    public class SoftcampDS
    {
        #region [멤버 변수 선언]
        private string _nameSpace = "SoftcampDS.SoftcampDS";
        private int _startTick = 0;
        private bool _executionTimeLog = true;

        private string _keyFile = "";
        private string _settingInfo = "";
        #endregion

        public SoftcampDS()
        {
            _executionTimeLog = Convert.ToBoolean(Config.Read("bExecutionTimeLog"));
            _settingInfo = Config.Read("DocSecuritySetInfo");
            _keyFile = Config.Read("DocSecurityKeyFile");
        }

        /// <summary>
        /// 문서 암호화
        /// </summary>
        /// <param name="srcFile"></param>
        /// <param name="downFolder"></param>
        /// <param name="ext"></param>
        /// <returns></returns>
        public string EncFile(string srcFile, string downFolder, string ext)
        {
            if (ext == "tif" || ext == "tiff" || ext == "jpg" || ext == "jpeg" || ext == "bmp"
                 || ext == "gif" || ext == "png" || ext == "mht" || ext == "mhtml" || ext == "htm" || ext == "html")
            {
                return "NS" + srcFile; //보안 정책 예외 확장자
            }

            SCSLClass scSL = null;
            FileInfo fi = null;
            string strDestFile = "";
            string strReturn = "";
            string strMsg = "";
            int iRt = 0;

            try
            {
                strMsg = "[100]";
                Prepare();

                strMsg = "[200]";
                FileHelper.CreateDirectory(downFolder);
                fi = FileHelper.GetFileInformation(srcFile);
                if (fi.Extension.Length == 0)
                {
                    FileHelper.CopyFile(srcFile, downFolder + fi.Name + "." + ext, true);
                    srcFile = downFolder + fi.Name + "." + ext;
                    strDestFile = downFolder + fi.Name + "_enc." + ext;
                }
                else
                {
                    strDestFile = downFolder + fi.Name;
                }

                strMsg = "[300]";
                scSL = new SCSLClass();

                strMsg = "[400]";
                scSL.SettingPathForProperty(_settingInfo); //2016-04-25 환경설정 메소드 먼저 호출
                scSL.DSAddUserDAC("SECURITYDOMAIN", "111001000", 0, 0, 0); //2016-04-29 인쇄권한 추가

                strMsg = "[500]";
                iRt = scSL.DSIsSupportFile(srcFile);
                if (!Convert.ToBoolean(iRt))
                {
                    strReturn = "NS" + srcFile;//iRt.ToString(); //지원하지 않는 파일형식
                }
                else
                {
                    strMsg = "[600]";
                    iRt = scSL.DSEncFileDACV2(_keyFile, "SECURITYDOMAIN", srcFile, strDestFile, 1); //이미 암호화 된 경우 재암호화
                    if (iRt != 0)
                    {
                        strReturn = "NO" + iRt.ToString();
                    }
                    else
                    {
                        strReturn = "OK" + strDestFile;
                    }
                }
                MeasureExecutionTime("EncFile,", srcFile + " => " + strDestFile + " : " + strReturn);
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "EncFile-" + strMsg);
                //throw new Exception(strMsg + " 위치 오류 발생!");
                strReturn = strMsg + " " + ex.Message;
            }
            finally
            {
                scSL = null;
                fi = null;
            }
            return strReturn;
        }

        /// <summary>
        /// 문서 복호화
        /// </summary>
        /// <param name="srcFile"></param>
        /// <returns></returns>
        public string DecFile(string srcFile)
        {
            DSAPILib.SCSLClass scSL = null;
            FileInfo fi = null;
            string strDestFile = "";
            string strReturn = "";
            string strMsg = "";
            int iRt = 0;

            try
            {
                strMsg = "[100]";
                Prepare();

                strMsg = "[200]";
                scSL = new SCSLClass();

                strMsg = "[300]";
                scSL.SettingPathForProperty(_settingInfo); //2016-04-25 환경설정 메소드 먼저 호출

                strMsg = "[400]";
                iRt = scSL.DSIsSupportFile(srcFile);
                if (!Convert.ToBoolean(iRt))
                {
                    strReturn = "NS" + iRt.ToString(); //지원하지 않는 파일형식
                }
                else
                {
                    strMsg = "[410]";
                    iRt = scSL.IsEncryptFile(srcFile);
                    if (!Convert.ToBoolean(iRt))
                    {
                        strReturn = "NE" + iRt.ToString(); //암호화 파일이 아님
                    }
                    else
                    {
                        strMsg = "[500]";
                        fi = FileHelper.GetFileInformation(srcFile);
                        string strTemp = fi.DirectoryName + @"\" + fi.Name.Replace(fi.Extension, "") + "_copy" + fi.Extension;
                        FileHelper.CopyFile(srcFile, strTemp, true);
                        FileHelper.DeleteFile(srcFile);

                        strDestFile = srcFile;
                        srcFile = strTemp;

                        strMsg = "[600]";
                        iRt = scSL.DSDecFileDAC(_keyFile, "SECURITYDOMAIN", srcFile, strDestFile);
                        if (iRt != 0)
                        {
                            strReturn = "NO" + iRt.ToString();
                        }
                        else
                        {
                            strReturn = "OK";
                        }
                    }
                }
                MeasureExecutionTime("DecFile,", srcFile + " => " + strDestFile + " : " + strReturn);
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "DecFile-" + strMsg);
                //throw new Exception(strMsg + " 위치 오류 발생!");
                strReturn = strMsg + " " + ex.Message;
            }
            finally
            {
                scSL = null;
                fi = null;
            }
            return strReturn;
        }

        #region [실행 시각 기록 관련]
        private void Prepare()
        {
            if (_executionTimeLog)
            {
                _startTick = Environment.TickCount;
            }
        }

        private void MeasureExecutionTime(string method, string log)
        {
            if (_executionTimeLog)
            {
                int iDuringTime = Environment.TickCount - _startTick;
                StringBuilder sbLog = new StringBuilder();

                sbLog.AppendFormat("{0} {1}ms  ", DateTime.Now.ToString("HH:mm:ss"), iDuringTime.ToString().PadLeft(6, ' '));
                sbLog.AppendFormat("{0} {1}{2}", method, log, Environment.NewLine);
                Logging.WriteLog(Logging.LogType.Debug, sbLog.ToString(), _nameSpace);
                sbLog = null;
                _startTick = 0;
            }
        }
        #endregion
    }
}