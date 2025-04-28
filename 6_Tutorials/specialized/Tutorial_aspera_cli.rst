Aspera CLI
###########

This guide walks you through installing, configuring, and using the **Aspera Command Line Interface (ascli)** on Rockfish to download files from the JHG Aspera server.


Start an Interactive Session (Optional)
***************************************

Start an interactive session if you plan to run downloads from a compute node:

.. code-block:: bash

   interact -p shared -n 6 -t 02:00:00

Install `ascli`
***************

1. **Load the Ruby module:**

.. code-block:: bash

   module load Ruby/3.1.2

2. **Install `aspera-cli`:**

.. code-block:: bash

   gem install aspera-cli --user-install

3. **Add `ascli` to your PATH:**

.. note::

   Confirm the installation path of `ascli`. It should be either:
   ``$HOME/.gem/ruby/3.1.0/bin`` or ``$HOME/.local/share/gem/ruby/3.1.0/bin``.

.. code-block:: bash

   echo 'export PATH="$HOME/.local/share/gem/ruby/3.1.0/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc

.. note::

   ✅ You only need to do the installation and path configuration once.

Configure `ascli`
*****************

1. **Load the Aspera Connect module and start SSH agent:**

.. code-block:: bash

   module load Aspera-Connect/4.1.1
   eval "$(ssh-agent -s)"

2. **Run the configuration wizard:**

.. code-block:: bash

   ascli config wizard

When prompted, enter the following:

- ``argument: url (e.g:)>``  
  ``https://jhg-aspera2.jhgenomics.jhu.edu``

- ``option: username>``  
  Your JHG Aspera username (e.g., your JH email)

- ``option: password>``  
  Your JHG Aspera password

Downloading Data
****************

Use the following command to download data (replace placeholders with your actual credentials):

.. code-block:: bash

   ascli shares files download \
     --url=https://jhg-aspera2.jhgenomics.jhu.edu \
     --username=your@email \
     --password=XXXXXXX \
     /cidr-newby/U6-MPRA-1 \
     --ts=@json:'{"target_rate_kbps":300000,"resume_policy":"sparse_csum"}'

Using `ascli` in the Future
***************************

Next time you need to use `ascli`, simply run:

.. code-block:: bash

   module load Ruby/3.1.2
   module load Aspera-Connect/4.1.1
   eval "$(ssh-agent -s)"

Then you're ready to use `ascli` again.