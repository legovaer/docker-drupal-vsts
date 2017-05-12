Microsoft Visual Studio Team Services Build Agent optimized for Drupal
======================================================================

A Linux Build Agent that can be used for deploying Drupal applications.

Summary
-------

This image contains:

* MySQL 5.17
* PHP 7.0
* The latest release of Drupal Console
* Composer
* VSTS Agent

## How to use these images
VSTS agents must be started with account connection information, which is provided through two environment variables:

- `VSTS_ACCOUNT`: the name of the Visual Studio account
- `VSTS_TOKEN`: a personal access token (PAT) for the Visual Studio account that has been given at least the **Agent Pools (read, manage)** scope.

To run the default VSTS agent image for a specific Visual Studio account:

```
docker run \
  -e VSTS_ACCOUNT=<name> \
  -e VSTS_TOKEN=<pat> \
  -it legovaer/docker-drupal-vsts
```

Agents can be further configured with additional environment variables:

- `VSTS_AGENT`: the name of the agent (default: `"$(hostname)"`)
- `VSTS_POOL`: the name of the agent pool (default: `"Default"`)
- `VSTS_WORK`: the agent work folder (default: `"_work"`)

The `VSTS_AGENT` and `VSTS_WORK` values are evaluated inside the container as an expression so they can use shell expansions. The `VSTS_AGENT` value is evaluated first, so the `VSTS_WORK` value may reference the expanded `VSTS_AGENT` value.


### Passwords

* MySQL: `root:` (no password)
* SSH: `root:root`

### Exposed ports

* 22 (SSH)
* 3306 (MySQL)

### Github

Clone the repository locally and build it:

	git clone https://github.com/legovaer/docker-drupal-vsts.git
	cd docker-drupal-vsts
	docker build -t yourname/drupal-vsts .
  
### Docker repository

Get the image:

	docker pull legovaer/drupal-vsts
