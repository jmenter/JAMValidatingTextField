Pod::Spec.new do |s|

  s.name         = "JAMValidatingTextField"
  s.version      = "0.0.5"
  s.summary      = "JAMValidatingTextField adds validation facilities to UITextField in iOS."

  s.description  = <<-DESC
                   A longer description of JAMValidatingTextField in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/jmenter/JAMValidatingTextField"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "Jeff Menter" => "jmenter@gmail.com" }

  s.platform     = :ios
  s.requires_arc = true

  s.ios.deployment_target = '6.0'

  s.source       = { :git => "https://github.com/jmenter/JAMValidatingTextField.git", :tag => s.version }

  s.source_files  = 'Classes', '*.{h,m}'
  s.exclude_files = 'Classes/Exclude'


end
