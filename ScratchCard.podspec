Pod::Spec.new do |s|
s.name = "ScratchCard"
s.version = "1.0.10"
s.license = "MIT"
s.summary = "A ScratchCard view on iOS(swift)."
s.homepage = "https://github.com/joehour/ScratchCard"
s.authors = { "joe" => "joemail168@gmail.com" }
s.source = { :git => "https://github.com/joehour/ScratchCard.git", :tag => s.version.to_s }
s.requires_arc = true
s.ios.deployment_target = "8.0"
s.source_files = "ScratchCard/*.{swift}"
end
