# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
use_frameworks!
pod 'Alamofire', '~> 5.2'
pod 'AlamofireImage', '~> 4.1'

pod 'Firebase/Analytics'
pod 'Firebase/Auth'
pod 'Firebase/Crashlytics'
pod 'Firebase/Messaging'

pod 'KakaoSDKCommon'  # 필수 요소를 담은 공통 모듈
pod 'KakaoSDKAuth'  # 카카오 로그인
pod 'KakaoSDKUser'  # 사용자 관리
pod 'naveridlogin-sdk-ios'

pod 'FBSDKCoreKit'
pod 'FBSDKLoginKit'
pod 'FBSDKShareKit'

pod "BSImagePicker", "~> 3.1"
pod 'Mantis', '~> 1.4.1'
pod 'PhoneNumberKit', '~> 3.3'
pod 'ObjectMapper', '~> 3.5'
pod 'JWTDecode', '~> 2.4'
pod 'CryptoSwift'
pod 'SwiftKeychainWrapper'


end

target 'StartCode' do
shared_pods

end

target 'StartCodePro' do
shared_pods

end
