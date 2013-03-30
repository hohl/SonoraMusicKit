Pod::Spec.new do |s|
  s.name         = 'SonoraMusicKit'
  s.version      = '1.0.0'
  s.license      = 'MIT'
  s.summary      = 'An all-in-one solution for building content rich music applications by supporting the most popular streaming and radio sources.'
  s.homepage     = 'https://github.com/hohl/SonoraMusicKit'
  s.author       = 'Michael Hohl'
  s.source       = { :git => 'git://github.com/hohl/SonoraMusicKit.git', :tag => 'v1.0.0' }
  s.source_files = 'Classes/SonoraMusicKit/*.{h,m}'
  s.requires_arc = true

  s.subspec 'MPMediaLibrary' do |mpmedialibrary|
    mpmedialibrary.platform     = :ios, '5.0'
    mpmedialibrary.source_files = 'Classes/MPMediaLibrary/*.{h,m}'
    mpmedialibrary.frameworks   = 'MediaPlayer', 'AVFoundation'
  end
  s.subspec 'Spotify' do |spotify|
    spotify.platform     = :ios, '5.0'
    spotify.source_files = 'Classes/Spotify/*.{h,m}'
    spotify.dependency     'CocoaLibSpotify', '~> 2.4'
  end
  s.subspec 'OtherServices' do |otherservices|
    otherservices.source_files = 'Classes/Other Services/*.{h,m}'
    otherservices.dependency     'AFNetworking', '~> 1.1'
    otherservices.dependency     'SSKeychain'
  end
end
