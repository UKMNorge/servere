# Set configs common for all boxes
def commonConf(boxName, box)
    # Edit disk and memory
    box.disksize.size = $boxConf[boxName][:disksize]
    box.vm.network "private_network", ip: $boxConf[boxName][:ip]
    box.vm.hostname = $boxConf[boxName][:hostname]
end

def shareAndConfigureSubdomains(boxName, box, config)
    hostname_aliases = Array.new

    pillarFile = './pillar/ukm/subdomains/'+ boxName +'.sls'
    if File.exist?(File.expand_path(pillarFile))
        pillarSubdomainConfig = YAML.load_file(pillarFile)

        if pillarSubdomainConfig.kind_of?(Array)
            pillarSubdomainConfig['subdomains'].each do |subdomain, domainData|
                share(box, boxName+'/'+domainData['subdomain'], '/var/www/'+domainData['subdomain']+'/')
                hostname_aliases << domainData['subdomain']+".ukm.dev"
            end
        end
    end
    box.hostmanager.aliases = hostname_aliases
end

# Actually run salt-provisioning
def doProvision(boxName, box)
    box.vm.provision :salt do |salt|
        salt.pillar({
            "networking" => {
                "host" => $boxConf[boxName][:hostname],
                "ip" => $boxConf[boxName][:ip]
            }
        })
        salt.minion_config = "salt/vagrant-minion-"+ boxName
        salt.run_highstate = true
        salt.verbose = true
    end
end