Welcome to Zammad
=================

Zammad is a web based open source helpdesk/ticket system with many features
to manage customer communication via several channels like telephone, facebook,
twitter, chat and e-mails. It is distributed under the GNU AFFERO General Public
 License (AGPL) and tested on Linux, Solaris, AIX, FreeBSD, OpenBSD and Mac OS
10.x. Do you receive many e-mails and want to answer them with a team of agents?
You're going to love Zammad!

What is zammad-docker repo for?
-------------------------------

This repos is meant to be the starting point for somebody who likes to test zammad. 
If you like to run zammad in production you should use one of the DEB or RPM packages.

Getting started with the Zammad Docker image
--------------------------------------------

https://zammad.org/documentation/install/install-docker

Database Connection
--------------------------------------------

This branch does not include a database installation.

Define the database connection by setting these ENV params:

- `DB_ADAPTER=mysql2|postgresql`
- `DB_DATABASE=<db_name>`
- `DB_HOST=<db_host>`
- `DB_PORT=<db_port>`
- `DB_USERNAME=<db_username>`
- `DB_PASSWORD=<db_password>`
