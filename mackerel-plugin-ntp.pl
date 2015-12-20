#!/usr/bin/env perl
# -*- coding:utf-8 -*-
# -*- mode:perl -*-

use strict;
use warnings;

if(exists $ENV{MACKEREL_AGENT_PLUGIN_META} && $ENV{MACKEREL_AGENT_PLUGIN_META} == 1){
    require JSON;
    # graph settings
    print "# mackerel-agent-plugin\n";
    print JSON::encode_json({
        "graphs" => {
            "ntp.offset" => {
                "label" => "ntp offset",
                "unit" => "float",
                "metrics" => [
                    {"name" => "offset",
                     "label" => "offset"},
                    ],
                },
            }
        }), "\n";
    exit 0;
}

my $epochtime = `date +%s`;
chomp($epochtime);

# ntpq -c rv | grep offset | sed -e 's/^.*offset=\(-\?[0-9\.]\+\).*$/\1/'
my $result = `ntpq -c rv | grep offset`;
chomp($result);

if($result =~ m/offset=(-?[0-9\.]+)/){
    printf("%s\t%s\t%s\n", "ntp.offset.offset", $1, $epochtime);
}
