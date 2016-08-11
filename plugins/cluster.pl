# Cluster
# An MLN plugin to populate important head and compute node
# files on virtual hosts with information necessary for 
# cluster applications such as torque.
#
# Author: Matt Disney < matthew.disney at iu dot hio dot no >

my $pi_version = 0.1;

my $pi_DEBUG = 0;

sub cluster_version {
	print ("cluster version $pi_version\n");
}

sub cluster_configure {

    # first we check if this host has a myplugin block: 
    my @cluster_lines = getArray("/global/cluster");
    my $check_path    = "$MOUNTDIR/var/spool/torque";

    unless ( @cluster_lines ) {
       $pi_DEBUG && out("Cluster plugin not enabled\n");
       return;
    }
  
#    unless ( -f $check_path ) {
#       $pi_DEBUG && out("Warning: $check_path is not present. Disabling cluster plugin.\n");
#       return;
#    }

    $pi_DEBUG && out("Cluster plugin enabled.\n");

    my $hostname   = $_[0];
    my $serverfile = "/var/spool/torque/server_name";
    my $nodesfile  = "/var/spool/torque/server_priv/nodes";
    my @nodeslist  = getHosts();
    my $headnode   = getScalar("/global/cluster/head");
    my @headnodelines;

    @headnodelist = ($headnode);

    # Create the torque node lists
    $pi_DEBUG && out("Nodelist: @nodeslist\n");

    $pi_DEBUG && out("Writing head node ($headnode) to $hostname:$serverfile\n");
    writeToFile($hostname,$serverfile,\@headnodelist,"644");
    
    # If we're the headnode, we want the nodelist 
    if ( $hostname eq $headnode )  {
       $pi_DEBUG && out("Writing nodes list to headnode ($hostname:$nodesfile)\n");
       writeToFile($hostname,$nodesfile,\@nodeslist,"644");


       # Create the /etc/exports file
       my $exportsfile = "/etc/exports";
       my $homedir     = "/home";
       my $options     = "rw,root_squash";
       my @exportary;
       my $exportline  = $homedir;

       for my $node (@nodeslist) { 
          push(@exportary,"$node($options)");
       }

       $exportline = join(' ', ($homedir, @exportary));
       @exportlines = ($exportline);
 
       $pi_DEBUG && out("Writing to $headnode:$exportsfile:\n@exportlines\n");
       writeToFile($hostname,$exportsfile,\@exportlines,"644");
    }  
    else {
       my $masterfile = "/etc/auto.master";
       my $homefile    = "/etc/auto.home";

       my $masterline = "/home		auto.home";
       my $homeline   = "*		$headnode:/home/&";

       my @masterlines = ($masterline);
       my @homelines   = ($homeline);

       $pi_DEBUG && out("Writing to $hostname:$masterfile:\n@masterlines\n");
       writeToFile($hostname,$masterfile,\@masterlines,"644");

       $pi_DEBUG && out("Writing to $hostname:$homefile:\n@homelines\n");
       writeToFile($hostname,$homefile,\@homelines,"644");
    }

}


1;
