
CORL Drupal development platform
================================

This project is designed to allow for easy local development of Drupal platforms
on Linux based environments through Vagrant with the CORL system.

Note:  Currently CORL has only been tested on Linux based systems and there are
known issues with Windows due to C style extensions that are required for the
Nucleon gem that Vagrant can not currently compile.  Hopefully in the near
future this will be resolved.

This project creates a project.loc Vagrant machine that is fully provisioned
for Drupal development and initializes a new site from a Drupal repository.

Getting started
---------------

1. Make sure CORL is installed:

    vagrant plugin install corl

You might consider creating an alias to the corl command set in Vagrant within
your .bashrc or wherever you keep your environment aliases defined.

    alias corl='vagrant corl'

2. Clone this project down or fork on GitHub:

    git clone git://github.com/coraltech/drupal-dev.git
    git remote rm origin
    git remote add origin {your project url}

3. Fork the Drupal Git repository into your own project:

    git clone -b 7.x http://git.drupal.org/project/drupal.git drupal
    git remote add project {your drupal url}
    git push project 7.x

4. Edit the build.json in the top level and change the base Drupal Git url with
the url for your project.

    vim build.json

    # Find the project environment development section and change:
    "www/drupal/project.loc": "git:::http://git.drupal.org/project/drupal.git[7.x]",
    # to:
    "www/drupal/project.loc": "git(hub)?:::{your project url}[{your dev branch}]",

5. Build the local development environment:

    corl node build development

This will clone down all of the packages, provisioner modules, gems, and Drupal
repositories that you have defined in the build.json configurations.

6. Start the Vagrant machine:

    vagrant up

This will start the Vagrant machine, bootstrap the CORL system, run the build
process on the Vagrant server, and provision the machine with the Drupal site.

When this process completes successfully, change the corl_stage fact in the node
configuration to maintain:

    vim nodes/vagrant/project.loc.json

    # Find the corl_stage fact assignment and change:
    "corl_stage": "initialize"
    # to:
    "corl_stage": "maintain"

or run:

    corl node fact corl_stage maintain --nodes=project.loc

If you need to wipe all your changes and start again from scratch, change the
corl_stage back to "initialize" and run:

    vagrant provision

7. Start the Vagrant RSync process

In another continuously running terminal start the Vagrant RSync process to
follow changes to the project and sync with the Vagrant machine.

    vagrant rsync-auto

8. When you need to SSH into the box, run:

    vagrant ssh

9. If you need to reprovision the machine you can run:

    corl node provision --nodes=project.loc

10. Now you should be good to go for local Drupal development...


