# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

source 'https://github.com/jrBordet/Sources.git'
source 'https://cdn.cocoapods.org/'

def shared_pods
		pod 'SceneBuilder', '1.0.0'
		pod 'RxComposableArchitecture', '2.1.3'
		pod 'SwiftLint'
end

def caprice
		pod 'Caprice', '0.0.6'
end

target 'CoachTimer' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  shared_pods

  pod 'RxDataSources', '4.0.1'
	pod "SwiftPrettyPrint", "~> 1.1.0" #, :configuration => "Debug"
	pod 'SwiftCharts', :git => 'https://github.com/i-schuetz/SwiftCharts.git'

	# add the Firebase pod for Google Analytics
	# pod 'Firebase/Analytics'
	# add pods for any other desired Firebase products
	# https://firebase.google.com/docs/ios/setup#available-pods
	
  target 'CoachTimerTests' do
    inherit! :search_paths
    # Pods for testing
		
		pod 'RxComposableArchitectureTests', '2.1.3'
    
    pod 'SnapshotTesting', '~> 1.7.2'
    pod 'RxBlocking'
    pod 'RxTest'
    pod 'Difference'

    caprice
  end

end

target 'CoachTimerMock' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  shared_pods

	pod 'SwiftCharts', :git => 'https://github.com/i-schuetz/SwiftCharts.git'
  pod 'RxDataSources', '4.0.1'
	pod "SwiftPrettyPrint", "~> 1.1.0" #, :configuration => "Debug"
	
	# add the Firebase pod for Google Analytics
	#pod 'Firebase/Analytics'

end
