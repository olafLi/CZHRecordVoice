
Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "CCIRecordVoice"
  s.version      = "0.0.1"
  s.summary      = "CCIRecordVoice is a 录音控件"
  s.description  = <<-DESC
                  CCIRecordVoice is a 录音控件r
                   DESC
  s.homepage     = "https://github.com/olafLi/CZHRecordVoice.git"
  s.license      = "MIT"
  s.author             = { "李腾飞" => "litengfei@winkind-tech.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/olafLi/CZHRecordVoice.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Classes/{CZHVoiceTool,CZHVoiceView}/*.{h,m,swift}","CZHRecordVoice/{CBPopup,Category}/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.resources = "Classes/**/*.{xib}"
  s.public_header_files = "Classes/{CZHVoiceTool,CZHVoiceView}/*.{h}","CZHRecordVoice/{CBPopup,Category}/*.h"
#  s.vendored_libraries = ['Classes/AMR/lib/libopencore-amrnb.a','Classes/AMR/lib/libopencore-amrwb.a']
  s.requires_arc = true

end
