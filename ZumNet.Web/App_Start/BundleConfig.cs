using System.Web.Optimization;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
using GlobExpressions;
using BundleTransformer.Core.Bundles;
using BundleTransformer.Core.Orderers;
using BundleTransformer.Core.Resolvers;
using System.Web;

namespace ZumNet.Web
{
    public class CssRewriteUrlTransformWrapper : IItemTransform
    {
        public string Process(string includedVirtualPath, string input)
        {
            return new CssRewriteUrlTransform().Process("~" + VirtualPathUtility.ToAbsolute(includedVirtualPath), input);
        }
    }

    public class BundleConfig
    {
        // For more information on bundling, visit https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            // bundles.UseCdn = true;
            // BundleTable.EnableOptimizations = true;

            // Replace a default bundle resolver in order to the debugging HTTP handler
            // can use transformations of the corresponding bundle
            BundleResolver.Current = new CustomBundleResolver();

            bundles.Add(new ScriptBundle("~/bundle/jquery").Include("~/Scripts/jquery-{version}.js"));
            bundles.Add(new ScriptBundle("~/bundle/jqueryval").Include("~/Scripts/jquery.validate*"));

            // Modernizr의 개발 버전을 사용하여 개발하고 배우십시오. 그런 다음
            // 프로덕션에 사용할 준비를 하고 https://modernizr.com의 빌드 도구를 사용하여 필요한 테스트만 선택하세요.
            bundles.Add(new ScriptBundle("~/bundle/modernizr").Include("~/Scripts/modernizr-*"));

            // ------------------------------------------------------------------------------------
            // Application assets
            //

            // Bundle jquery-validation-unobtrusive package
            bundles.Add(new ScriptBundle("~/bundle/vendor/js/validate-unobtrusive/validate-unobtrusive").Include(
                        "~/node_modules/jquery-validation-unobtrusive/dist/jquery.validate.unobtrusive.js"));

            
            bundles.Add(new StyleBundle("~/bundle/css/site").Include("~/Content/site.css"));
            bundles.Add(new ScriptBundle("~/bundle/js/site").Include("~/Vendor/libs/waves/waves.min.js")
                                                            .Include("~/Vendor/libs/bootbox/bootbox.js")
                                                            .Include("~/Scripts/site.js")
                                                            .Include("~/Scripts/Controls/treeOrg.js")
                                                            .Include("~/Scripts/Controls/treeFolder.js")
                                                            );


            bundles.Add(SassBundle("~/bundle/css/theme-cresyn").Include("~/Content/theme-cresyn.scss"));
            bundles.Add(SassBundle("~/bundle/css/theme-cresyn-blue").Include("~/Content/theme-cresyn-blue.scss"));

            //관리툴 용 js
            bundles.Add(new ScriptBundle("~/bundle/js/main").Include("~/Vendor/libs/waves/waves.min.js")
                                                            .Include("~/Vendor/libs/bootbox/bootbox.js")
                                                            .Include("~/Areas/WoA/Scripts/main.js")
                                                            .Include("~/Areas/WoA/Scripts/tree.js")
                                                            );

            // ------------------------------------------------------------------------------------
            // Core stylesheets
            //

            bundles.Add(SassBundle("~/bundle/vendor/fonts").Include("~/Vendor/fonts/fonts.scss"));
            //아래 묶음처리시 브라우저 다운로드시 자주 오류 발생 : net::ERR_HTTP2_PROTOCOL_ERROR
            //bundles.Add(SassBundle("~/bundle/vendor/icons").Include("~/Vendor/fonts/fontawesome.css")
            //                                               .Include("~/Vendor/fonts/materialdesignicons.css")
            //                                               .Include("~/Vendor/fonts/feather.css"));

            //bundles.Add(SassBundle("~/bundle/vendor/css/bootstrap").Include("~/Vendor/css/bootstrap.scss"));
            //bundles.Add(SassBundle("~/bundle/vendor/css/appwork").Include("~/Vendor/css/appwork.scss"));
            //bundles.Add(SassBundle("~/bundle/vendor/css/zumworks").Include("~/Vendor/css/bootstrap.scss").Include("~/Vendor/css/appwork.scss"));
            //bundles.Add(SassBundle("~/bundle/vendor/css/theme-corporate").Include("~/Vendor/css/theme-corporate.scss"));
            //bundles.Add(SassBundle("~/bundle/vendor/css/colors").Include("~/Vendor/css/colors.scss"));
            //bundles.Add(SassBundle("~/bundle/vendor/css/uikit").Include("~/Vendor/css/uikit.scss"));
            bundles.Add(SassBundle("~/bundle/vendor/css/csskit").Include("~/Vendor/css/colors.scss")
                                                                .Include("~/Vendor/css/uikit.scss")
                                                                .Include("~/Vendor/libs/waves/waves.scss")
                                                                );

            // ------------------------------------------------------------------------------------
            // Automatically bundle ~/Vendor/css directory
            //

            // Bundle path: ~/bundle/vendor/css/{filename}
            foreach (string[] bundleFile in GetVendorBundles("css", "css", "**/*", "scss"))
            {
                bundles.Add(SassBundle(bundleFile[0]).Include(bundleFile[1]));
            }

            // ------------------------------------------------------------------------------------
            // Automatically bundle ~/Vendor/js directory
            //

            // Bundle path: ~/bundle/vendor/js/{filename}
            foreach (string[] bundleFile in GetVendorBundles("js", "js", "**/*", "js"))
            {
                bundles.Add(new Bundle(bundleFile[0]).Include(bundleFile[1]));
            }

            // ------------------------------------------------------------------------------------
            // Automatically bundle ~/Vendor/css/pages directory
            //

            // Bundle path: ~/bundle/vendor/css/pages/{filename}
            foreach (string[] bundleFile in GetVendorBundles("css\\pages", "css/pages", "**/*", "scss"))
            {
                bundles.Add(SassBundle(bundleFile[0]).Include(bundleFile[1]));
            }

            // ------------------------------------------------------------------------------------
            // Automatically bundle ~/Vendor/fonts directory
            //

            // Bundle path: ~/bundle/vendor/fonts/{filename}
            foreach (string[] bundleFile in GetVendorBundles("fonts", "fonts", "*", "css"))
            {
                bundles.Add(new Bundle(bundleFile[0]).Include(bundleFile[1], new CssRewriteUrlTransformWrapper()));
            }

            // ------------------------------------------------------------------------------------
            // Automatically bundle ~/Vendor/libs directory
            //

            // Bundle path: ~/bundle/vendor/css/{libdir}/{filename}
            foreach (string[] bundleFile in GetVendorBundles("libs", "css", "**/*", "scss"))
            {
                if (bundleFile[2] == "true")
                {
                    bundles.Add(SassBundle(bundleFile[0]).Include(bundleFile[1], new CssRewriteUrlTransformWrapper()));
                }
                else
                {
                    bundles.Add(SassBundle(bundleFile[0]).Include(bundleFile[1]));
                }
            }

            // Bundle path: ~/bundle/vendor/js/{libdir}/{filename}
            foreach (string[] bundleFile in GetVendorBundles("libs", "js", "**/*", "js"))
            {
                bundles.Add(new Bundle(bundleFile[0]).Include(bundleFile[1]));
            }

            BundleTable.EnableOptimizations = true;
        }

        private static Bundle SassBundle(string path)
        {
            return new CustomStyleBundle(path)
            {
                Orderer = new NullOrderer()
            };
        }

        private static string[][] GetVendorBundles(string sourcePath, string bundlePath, string globPattern, string ext)
        {
            // Application root directory path
            string APP_PATH = AppDomain.CurrentDomain.BaseDirectory;
            //

            DirectoryInfo dirInfo = new DirectoryInfo(APP_PATH + "\\Vendor\\" + sourcePath);
            IEnumerable<FileInfo> contents = dirInfo.GlobFiles(globPattern + "." + ext);

            List<string[]> bundles = new List<string[]>();

            Regex normalizeRegex = new Regex("\\\\");

            sourcePath = normalizeRegex.Replace(sourcePath, "/") + "/";

            Regex pathRegex = new Regex(".*?" + Regex.Escape("/Vendor/" + sourcePath));
            Regex nameRegex = new Regex("\\." + Regex.Escape(ext) + "$");

            Regex urlRewriteTestRegex = new Regex("/(" +
                    "minicolors/minicolors" + "|" +
                    "blueimp-gallery/gallery-video" + "|" +
                    "blueimp-gallery/gallery" + "|" +
                    "jstree/themes/default/style" + "|" +
                    "jstree/themes/default-dark/style" + "|" +
                    "photoswipe/photoswipe" +
                ")\\.scss$");

            foreach (FileInfo file in contents)
            {
                string filePath = pathRegex.Replace(normalizeRegex.Replace(file.FullName, "/"), "");
                string relativeBundlePath = "~/bundle/vendor/" + bundlePath + "/" + nameRegex.Replace(filePath, "");
                string relativeSourcePath = "~/Vendor/" + sourcePath + filePath;
                bool urlRewrite = urlRewriteTestRegex.IsMatch(relativeSourcePath);

                bundles.Add(new string[] { relativeBundlePath, relativeSourcePath, urlRewrite ? "true" : "false" });
            }

            return bundles.ToArray();
        }

    }
}