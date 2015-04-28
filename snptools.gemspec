# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "Variant Tools"
  spec.version       = '1.0'
  spec.authors       = ["Malte Mader"]
  spec.email         = ["malte.mader@ti.bund.de"]
  spec.summary       = %q{Process and generate different formats containing variation data}
  spec.description   = %q{Process and generate different formats containing variation data}
  spec.homepage      = "http://github/mader/snptools"
  spec.license       = "ICS"

  spec.files         = ['lib/tools.rb']
  spec.executables   = ['bin/varianttools.rb']
  spec.test_files    = ['tests/test_snptools.rb']
  spec.require_paths = ["lib"]
end
