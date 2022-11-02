# Salt Master Test


This is a simple test for managing robot configurations using Salt.

The main design goals are as follows:

#### Version control robot configuration

We frequently need to install new packages, change config files, etc and need to carefully track and version those changes in a git repo.

New versions of the configuration should be represented by new tags in that git repo so that we can easily roll configurations forwards and backwards, as well as canary new configs on certain robots.

A dummy configuration repo can be found [here](https://github.com/randvoorhies/robot-configuration), which simply writes the version number to a file.

#### Apply different versions to different robots

We need the flexibility to A/B test different configurations, as well as canary new experiements.  Our management system needs to be able to easily deploy different versions of our configuration to different robots at-will.

#### Release new versions of our configuration without changing the Salt Master

All of our robot management software stack gets deployed as binary Docker images out to customer sites. Our robot software/configuration release cycle runs at different rates than our management software release cycle, so we need to be able to push out new robot configs without having to simultaneously push out management software configs.

This means that our solution cannot rely on changing an `.sls` file on the master every time we want to release a new robot version.

### The Solution So Far

This repo presents a solution that seems to work, based around "one weird trick" (salt masters hate him!).

You can check it out in the `salt.sls` file, but it's short enough to just paste here:

```yaml
{{ pillar['robot_version'] }}:
  '*':
    - robot-configuration
```

The robot's version can then be specified in a pillar (see `srv/pillar/versions.sls`) such that each robot can have it's own version.

This seems to be a little bit of an abuse of the way Salt renders templates, but any downsides remain to be seen.

### Future Work

Assuming this all works out, we'll need to:

- Actually make the `robot-configuration` do useful configuration.
- Build a way to load the pillar data that's currently in `versions.sls` from the robot management database instead.
- Figure out how to query what version has been installed on a robot.
    - This could be as simple as writing a `version.txt` file as part of the config process and possibly loading it as a custom grain.

