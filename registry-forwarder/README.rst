registry-forwarder
==================

Launch the ``registry-forwarder`` AKA ``fwdr``:

.. code-block:: shell

    docker run -d -i -t -p 80 --name fwdr -v $HOME/.ssh/docker-registry:/root/.ssh registry-forwarder

Then use it (see ``dockerhost.dock`` for how to build a ``dockerhost``:

.. code-block:: shell

    docker run --rm -i -t --link fwdr:<registry-hostname> \
        --privileged -v /var/lib/docker \
        dockerhost
    root@container:/# docker pull <registry-hostname>/scratch


Getting started
---------------

Create a new "``~/.ssh``" directory that holds:
* ``config`` where ``Host`` is ``docker-registry``
* ``id_dsa``, ``id_ecdsa``, ``id_ed25519`` or ``id_rsa`` without a passphrase

I have the directory placed in ``~/.ssh/docker-registry``.

Then make sure permissions are right:

.. code-block:: shell

    chmod u+rw-x ~/.ssh/docker-registry/id_*
    chmod go-rwx ~/.ssh/docker-registry/id_*
    sudo chown -R root:root ~/.ssh/docker-registry

The start the container and make the first SSH connection to get the known hosts
(or add ``known_hosts`` manually).

.. code-block:: shell

    docker run --rm -i -t -v $HOME/.ssh/docker-registry:/root/.ssh registry-forwarder bash
    root@5a9fcac54071:/# ssh docker-registry


Setting up passphrase-less secret key
-------------------------------------

Generate a new passphrase-less key:

.. code-block:: shell

    sudo ssh-keygen -t rsa -b 2048 -f $HOME/.ssh/docker-registry/id_rsa

Hit enter twice to make the passphrase empty.

Then copy the public key to ``authorized_keys`` on your "``docker-registry``" host:

.. code-block:: shell

    sudo cat id_rsa.pub | xargs -I {} ssh docker-registry "echo {} >> ~/.ssh/authorized_keys"


Template ``config``
-------------------

.. code-block::

    Host docker-registry
    Hostname <hostname or IP of the docker registry>
    User <the username on the docker registry host>

