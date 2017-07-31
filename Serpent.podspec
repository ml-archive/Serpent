#
#  Be sure to run `pod spec lint Serpent.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "Serpent"
  s.version      = "1.1.0"
  s.summary      = "A protocol to serialize Swift structs and classes for encoding and decoding."
  s.homepage     = "https://github.com/nodes-ios/Serpent"
  s.description  = <<-DESC
  Serpent is a framework made for creating model objects or structs that can be easily serialized and deserialized from/to JSON. It's easily expandable and handles all common data types used when consuming a REST API, as well as recursive parsing of custom objects.
  It's designed to be used together with our helper app, the Model Boiler, making model creation a breeze. Serpent is implemented using protocol extensions and static typing.
  Also provides extensions for Alamofire and Cashier.
                   DESC

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #

  # Permissive license
  s.license = "MIT"

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "Nodes Agency - iOS" => "ios@nodes.dk" }
  s.social_media_url   = "http://twitter.com/nodes_ios"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  s.platforms = { :ios => "8.0", :osx => "10.10", :watchos => "2.0", :tvos => "9.0" }

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source = { :git => "https://github.com/nodes-ios/Serpent.git", :tag => s.version }

  # ――― Subspecs ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #

  s.default_subspecs = 'Core'

  # Main subspec
  s.subspec 'Core' do |core|
    # Add all files
    core.source_files = "Serpent/Serpent/Classes/**/*"

    # Exclude extensions by default
    core.exclude_files = "Serpent/Serpent/Classes/Extensions/CashierExtension.swift", "Serpent/Serpent/Classes/Extensions/AlamofireExtension.swift"
  end

  # Subspec for all extensions
  s.subspec 'Extensions' do |ext|
    ext.dependency 'Serpent/Core'
    ext.dependency 'Serpent/AlamofireExtension'
    ext.dependency 'Serpent/CashierExtension'
  end

  # Subspec for Alamofire extension
  s.subspec 'AlamofireExtension' do |alamo|
    alamo.dependency 'Serpent/Core'
    alamo.dependency 'Alamofire', '~> 4.1'
    alamo.source_files = "Serpent/Serpent/Classes/Extensions/AlamofireExtension.swift"
  end

  # Subspec for Cashier extension
  s.subspec 'CashierExtension' do |cashier|
    cashier.dependency 'Serpent/Core'
    cashier.dependency 'Cashier', '~> 1.2.1'
    cashier.source_files = "Serpent/Serpent/Classes/Extensions/CashierExtension.swift"
  end

end
