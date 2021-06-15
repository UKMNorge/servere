require 'fileutils'

## REQUIRE VAGRANT PLUGINS
doAbort = false
plugins = ['vagrant-hostmanager','vagrant-disksize']
plugins.each do |plugin|
    unless Vagrant.has_plugin?("#{plugin}")
        puts "Missing required vagrant plugin: `#{plugin}`.".red
        doAbort = true
    end
end

if doAbort
    puts "To install missing plugins, run:".red
    puts "$ vagrant plugin install #{plugins.join(' ')}".yellow
    abort
end

## REQUIRE DATA PACKAGE FILES IF BRINGING UP OR PROVISIONING VM
if ARGV.include?("up") || ARGV.include?("provision") || (ARGV.include?("reload") && ARGV.include?("--provision"))
    $dataPackageMissing = []

    caFile = File.expand_path("../datapackage/UKMNorgeCA.pem" )
    if( !File.exist?(caFile)) 
        $dataPackageMissing << File.basename( caFile )
    end
    
    # UKMlib database files
    requireDataPackageFiles('../datapackage/', 'salt/ukmlib/files/', ['ukmdev_dev_ss3.sql','ukmdev_dev_wp.sql','ukmdev_dev_id.sql'])

    # UKMbox-main wordpress
    requireDataPackageFiles('../datapackage/', 'salt/ukmbox-main/files/', ['uploads.tar.gz','plugins.tar.gz'])
    
    # SSL init.sls (certificates)
    requireDataPackageFiles('../datapackage/', 'pillar/ssl/', ['init.sls'])
    
    # Videoconverter database files
    requireDataPackageFiles('../datapackage/', 'salt/ukmbox-videoconverter/files/', ['ukmdev_videoconverter.sql'])

    if( $dataPackageMissing.length() > 0 )
        puts "Missing required file(s) in #{$localNFSpath}datapackage/:".red
        $dataPackageMissing.each do |file|
            puts "  - #{file}"
        end
        puts "See README.md for how to request development data package from UKM Norge."
        puts "$ open README.md".yellow

        abort
    end
end

if ARGV.include?("up") || (ARGV.include?("reload") && ARGV.include?("--provision"))
    puts "In case you've forgotten, remember to approve the UKM Norge (UKM.dev) certificate authority (CA):".blue
    puts " $ open "+ File.expand_path("#{Dir.pwd()}/../datapackage/UKMNorgeCA.pem")
end