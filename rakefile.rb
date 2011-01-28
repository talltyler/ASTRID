require 'sprout'
# Optionally load gems from a server other than rubyforge:
# set_sources 'http://gems.projectsprouts.org'
sprout 'as3'

############################################
# Configure your Project Model
project_model :model do |m|
  m.project_name            = 'Main'
  m.language                = 'as3'
  m.background_color        = '#FFFFFF'
  m.width                   = 970
  m.height                  = 550
  m.target_player           = '10.0.0'
  # m.compiler_gem_version  = '>= 4.0.0'
  # m.use_fdb               = true
  # m.use_fcsh              = true
  # m.preprocessor          = 'cpp -D__DEBUG=false -P - - | tail -c +3'
  # m.preprocessed_path     = '.preprocessed'
  # m.src_dir               = 'src'
  m.lib_dir                 = 'lib/src'
  m.swc_dir                 = 'lib/bin'
  m.bin_dir                 = 'deploy'
  m.doc_dir                 = 'docs'
  # m.test_dir              = 'test'
  # m.asset_dir             = 'assets'
  # m.modules 
  # m.compiler_gem_name     = 'sprout-flex4sdk-tool'
  
  # m.source_path           << "#{m.lib_dir}/somelib"
  # m.libraries             << :corelib
end

desc 'Compile and debug the application'
debug :debug

desc 'Compile run the test harness'
unit :test

desc 'Compile the optimized deployment'
deploy :deploy

desc 'Create documentation'
document :doc

desc 'Compile a SWC file'
swc :swc

desc 'Compile and run the test harness for CI'
ci :cruise

# set up the default rake task
task :default => :debug

# Alias the compilation task with one that is easier to type
task :compile => 'Main.swf'
desc 'Test Me'
# Create an MXMLCTask named for the output file that it creates. This task depends on the
# corelib library and will automatically add the corelib.swc to it's library_path
mxmlc 'Main.swf' do |t|
  t.input                     = 'src/Main.as'
  t.default_size              = '800 600'
  t.default_background_color  = "#FFFFFF"
  t.link_report               = 'test/report.xml'
  t.target_player             = '10.0.0'
  t.frames_frame              = 'app,com.company.project.App'
end