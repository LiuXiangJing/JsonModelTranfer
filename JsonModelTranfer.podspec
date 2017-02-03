#
#  Be sure to run `pod spec lint JsonModelTranfer.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|



  s.name         = "JsonModelTranfer"
  s.version      = "1.0.2"
    s.summary      = "简单的JsonModel转化器"


  s.homepage     = "https://github.com/LiuXiangJing/JsonModelTranfer.git"

  s.license      = "MIT"


  s.author             = { "刘咕噜" => "lxj_tintin@126.com" }
  s.platform     = :ios, "8.0"


  s.source       = { :git => "https://github.com/LiuXiangJing/JsonModelTranfer.git", :tag => "#{s.version}" }

  s.source_files  = "JsonModelTranfer", "JsonModelTranfer/**/JsonModelTranfer.framework"


  s.frameworks = "Foundation", "CoreData"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


end
