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
