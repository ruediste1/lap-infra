# coreos-vagrant is configured through a series of configuration
# options (global ruby variables) which are detailed below. To modify
# these options, first copy this file to "config.rb". Then simply
# uncomment the necessary lines, leaving the $, and replace everything
# after the equals sign..

# to support different configurations for different hosts and nodes,
# some parameters are represented as map. The key is <hostname>_<node nr>

# Size of the CoreOS cluster created by Vagrant
# key: <hostname>
$num_instances.merge!({ 'jupiter' => 1})

# Official CoreOS channel from which updates should be downloaded
# $update_channel.merge!({})

# Log the serial consoles of CoreOS VMs to log/
# Enable by setting value to true, disable with false
# WARNING: Serial logging is known to result in extremely high CPU usage with
# VirtualBox, so should only be used in debugging situations
#$enable_serial_logging=false

# Enable port forwarding of Docker TCP socket
# Set to the TCP port you want exposed on the *host* machine, default is 2375
# If 2375 is used, Vagrant will auto-increment (e.g. in the case of $num_instances > 1)
# You can then use the docker tool locally by setting the following env var:
#   export DOCKER_HOST='tcp://127.0.0.1:2375'
#$expose_docker_tcp=2375

# File for the server disk
#$server_disk_file = 'server_disk.vdi'

# Setting for VirtualBox VMs
#$vb_gui = false

$vb_memory.merge!({'jupiter_1' => '2048'})
#$vb_cpus.merge!({})

# Static IPs
$static_ip.merge!({ 'jupiter_1' => '192.168.0.10' })

$bridge_interface.merge!({'jupiter_1' => 'wlan0' })
