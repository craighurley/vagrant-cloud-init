# vagrant-cloud-init

Vagrant project for testing cloud-init scripts.

## How to Use

1. Edit the `meta-data.yaml` and `user-data.yaml` files located in `<project-directory>/cloud-init/nocloud-net/`.
    * Note that the vagrant provsioner copies the above files to `/var/lib/cloud/seed/nocloud-net/` without the `.yaml` extension.

1. Start the box, login and check the configuration.

    ```sh
    $ vagrant up
    $ vagrant ssh
    <box> $ # check configuration
    ```

1. Once you're finished, you can destroy the box with

    ```sh
    $ vagrant destroy
    ```

If you want to test changes without restarting the box, follow these steps:

1. Edit the `meta-data` and `user-data` files located on the box in `/var/lib/cloud/seed/nocloud-net/`.

1. Remove particular files that identify the current cloud-init instance configuration (which stop `cloud-init` from re-running).

    ```sh
    <box> $ sudo rm -fr /var/lib/cloud/sem/* /var/lib/cloud/instance /var/lib/cloud/instances/*
    ```

1. Force `cloud-init` to run again.

    ```sh
    <box> $ sudo cloud-init init
    <box> $ sudo cloud-init modules
    ```

## Notes

### Modules

As this project is using `vagrant`, it relies on the `nocloud` module.  There are two variations of this module; one that does not provide network access and one that does; this project uses the latter by default.

1. No network access: `/var/lib/cloud/seed/nocloud/`
1. Network access enabled: `/var/lib/cloud/seed/nocloud-net/`

## Links

[http://cloudinit.readthedocs.io](http://cloudinit.readthedocs.io)
