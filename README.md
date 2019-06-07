# chef_automate_wrapper

## Overview
Use this cookbook to install, configure and start a stand alone chef automate server

## Usage
Include this cookbook's default recipe in your run list.


## Attributes
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
|channel|The name of the channel to use for the installation|symbol|:current|no|
|version|The version of chef server to install|string|latest|no|
|accept_license|Accept the chef server EULA|boolean|true|no|
|config|the config to pass to the automate server|string|''|no|
|data_collector_token|The token to use when sending dta to the data collector url|string|nil|no|
