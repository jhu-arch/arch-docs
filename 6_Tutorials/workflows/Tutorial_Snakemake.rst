Snakemake Workflows
###################

.. image:: https://img.shields.io/conda/dn/bioconda/snakemake.svg?label=Bioconda
    :target: https://bioconda.github.io/recipes/snakemake/README.html

.. image:: https://img.shields.io/pypi/pyversions/snakemake.svg
    :target: https://www.python.org

.. image:: https://img.shields.io/pypi/v/snakemake.svg
    :target: https://pypi.python.org/pypi/snakemake

.. image:: https://img.shields.io/github/workflow/status/snakemake/snakemake/Publish%20to%20Docker%20Hub?color=blue&label=docker%20container&branch=main
    :target: https://hub.docker.com/r/snakemake/snakemake

.. image:: https://github.com/snakemake/snakemake/workflows/CI/badge.svg?branch=main&label=tests
    :target: https://github.com/snakemake/snakemake/actions?query=branch%3Amain+workflow%3ACI

.. image:: https://img.shields.io/badge/stack-overflow-orange.svg
    :target: https://stackoverflow.com/questions/tagged/snakemake

The `Snakemake`_ workflows management system is a tool to create reproducible and scalable data analyses.

The Snakemake language extends the Python language, adding syntactic structures for rule definition and additional controls. All added syntactic structures begin with a keyword followed by a code block that is either in the same line or indented and consists of multiple lines. The resulting syntax resembles that of original Python constructs.

A Snakemake workflow is defined by specifying rules in a Snakefile. The rules decompose the workflow into small steps by specifying how to create sets of output files from sets of input files. It will automatically determine the dependencies between the rules by matching file names.

This tutorial presents a bioinformatics pipeline using ``Snakemake`` and :doc:`the Reproducibility Framework (RF)<Tutorial_Reproducibility_Framework>`.

It will used the two classes of L1-associated somatic variants in the human brain from Salk Institute for Biological Studies dataset.

.. note::
  Bioproject: ``PRJEB10849`` SRA Study: ``ERP012147``.

  https://trace.ncbi.nlm.nih.gov/Traces/sra/?run=ERR1016570

Pipeline
********

Then, let's create the `pipeline`_ directory structure to store this tutorial.

.. code-block:: console

  [userid@login03 ~]$ mkdir -p pipeline/_h
  [userid@login03 ~]$ mkdir -p pipeline/cutadapt/_h
  [userid@login03 ~]$ mkdir -p pipeline/cutadapt/bwamem/_h
  [userid@login03 ~]$ mkdir -p pipeline/cutadapt/genome/_h
  [userid@login03 ~]$ mkdir -p pipeline/cutadapt/bwamem/rmdup/_h
  [userid@login03 ~]$ mkdir -p pipeline/cutadapt/bwamem/rmdup/tags/_h
  [userid@login03 ~]$ mkdir -p pipeline/cutadapt/bwamem/rmdup/tags/tabix/_h

A directory structure like this is expected to run our pipeline.

.. code-block:: console

  [userid@login03 pipeline]$ rf status
  .                                   done  (step done)
  └── cutadapt                        done
      ├── bwamem              ready to run  (step with the run file, but not performed)
      │   └── rmdup          no run script
      │       └── tags       no run script  (step without the run file)
      │           └── tabix  no run script
      └── genome                         no _h
          └── hg19                ready to run
              ├── bwa             ready to run
              └── chromsizes      ready to run

Once the scripts are ready to run, as is the case with the genome step. Just run the ``rf`` command recursively using the ``-r`` tag.

.. code-block:: console

  [userid@login03 pipeline]$ cd genome/
  [userid@login03 genome]$ rf sbatch -r .

  Start /home/userid/pipeline/genome/hg19: 2022-05-04 17:30:53-04:00
  End /home/userid/pipeline/genome/hg19: 2022-05-04 17:30:53-04:00
  Start /home/userid/pipeline/genome/hg19/bwa: 2022-05-04 17:30:53-04:00
  End /home/userid/pipeline/genome/hg19/bwa: 2022-05-04 17:30:53-04:00
  Start /home/userid/pipeline/genome/hg19/chromsizes: 2022-05-04 17:30:53-04:00
  End /home/userid/pipeline/genome/hg19/chromsizes: 2022-05-04 17:30:53-04:00

  [rdesouz4@login03 genome]$ rf status
  .                           no _h
  └── hg19                     done
      ├── bwa                  done
      └── chromsizes           done

SRA Toolkit
***********

To download sequence data files using SRA Toolkit, you need create a ``run`` file into ``pipeline/_h`` folder.

.. code-block:: console

  #!/bin/bash

  #SBATCH -J sra_tools
  #SBATCH -p defq
  #SBATCH -N 1
  #SBATCH --time=2:00:00
  #login01SBATCH --cpus-per-task=4
  #SBATCH --output=Array_test.%A_%a.out
  #SBATCH --array=1-101

  ml sra-tools/3.0.0

  # Bioproject PRJEB10849 samples

  sra_numbers=($(echo {1016570..1016671}))

  sra_id='ERR'${sra_numbers[ $SLURM_ARRAY_TASK_ID - 1 ]}

  prefetch --max-size 100G $sra_id --force yes --verify no
  fastq-dump --outdir . --gzip --skip-technical  --readids --read-filter pass --dumpbase --split-3 --clip ${sra_id}/${sra_id}.sra

  rm $sra_id -Rf

The  ``rf`` command will call the ``run`` script to retrieve SRA Normalized Format files with full base quality scores, and store them ``fastq`` files into ``_m`` folder.

.. code-block:: console

  [userid@login03 ~]$ cd pipeline/
  [userid@login03 ~]$ chmod +x _h/run
  [userid@login03 pipeline]$ rf sbatch -v .
  all: /home/userid/pipeline/_m/SUCCESS

  .ONESHELL:
  /home/userid/pipeline/_m/SUCCESS:
  	echo -n "Start /home/userid/pipeline: "; date --rfc-3339=seconds
  	mkdir /home/userid/pipeline/_m
  	cd /home/userid/pipeline/_m
  	sbatch ../_h/run > nohup.out 2>&1
  	touch SUCCESS
  	echo -n "End /home/userid/pipeline: "; date --rfc-3339=seconds

  Start /home/userid/pipeline: 2022-04-27 16:14:52-04:00
  End /home/userid/pipeline: 2022-04-27 16:14:52-04:00


.. note::
  * **Writing Workflows** : "In Snakemake, `workflows`_ are specified as Snakefiles. Inspired by GNU Make, a `Snakefile`_ contains rules that denote how to create output files from input files. Dependencies between rules are handled implicitly, by matching filenames of input files against output files. Thereby wildcards can be used to write general rules."

  * **Snakefiles and Rules** : "A Snakemake workflow defines a data analysis in terms of rules that are specified in the Snakefile."

We will create a hypothetical scenario with precedent steps, where for example the Level 5 (tabix) depends on the Level 4 (tags), and so on.

.. note::
  **Level 1 (cutadapt)  ->   Level 2 (bwamem) ->   Level 3 (rmdup) ->  Level 4 (tags) ->  Level 5 (tabix)**

Cutadapt
********

.. image:: https://github.com/marcelm/cutadapt/workflows/CI/badge.svg
    :alt:

.. image:: https://img.shields.io/pypi/v/cutadapt.svg?branch=master
    :target: https://pypi.python.org/pypi/cutadapt
    :alt:

.. image:: https://codecov.io/gh/marcelm/cutadapt/branch/master/graph/badge.svg
    :target: https://codecov.io/gh/marcelm/cutadapt
    :alt:

.. image:: https://img.shields.io/badge/install%20with-bioconda-brightgreen.svg?style=flat
    :target: http://bioconda.github.io/recipes/cutadapt/README.html
    :alt: install with bioconda

Cutadapt finds and removes adapter sequences, primers, poly-A tails and other types of unwanted sequence from your high-throughput sequencing reads. It helps with these trimming tasks by finding the adapter or primer sequences in an error-tolerant way.

.. code-block:: console

  [userid@login03 pipeline]$ cd cutadapt/
  [userid@login03 cutadapt]$ vi _h/run

  #!/bin/bash

  #SBATCH -J cutadapt
  #SBATCH -p defq
  #SBATCH --time=2:00:00
  #login01SBATCH --cpus-per-task=4
  #SBATCH --output=cutadapt.job.%j.out

  module load snakemake/7.6.0

  # Syntax to run it on Rockfish cluster
  snakemake --jobs 101 --latency-wait 240 --cluster 'sbatch --parsable --distribution=arbitrary' --snakefile ../_h/snakemake.slurm.script

So, we need create a script to perform the rev_comp_seq. Given a DNA sequence in string object, it will return its reverse.

.. code-block:: console

  [userid@login03 cutadapt]$ vi ~/.local/bin/rc

  #!/bin/bash
  if [ ! -z "$1" ]; then
      echo "$1" | tr "[ATGCatgc]" "[TACGtacg]" | rev
  else
      echo ""
      echo "usage: rc DNASEQUENCE"
      echo ""
  fi

  [userid@login03 cutadapt]$ chmod +x ~/.local/bin/rc
  [userid@login03 cutadapt]$ vi _h/snakemake.slurm.script

cutadapt snakemake.slurm.script
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

  import glob
  import os.path
  import itertools

  SOURCE_DIR = '../../_m'
  EXT = '_pass_1.fastq.gz'

  def sample_dict_iter(path, ext):
    for filename in glob.iglob(path+'/*'+ext):
        sample = os.path.basename(filename)[:-len(ext)]

        yield sample, {'r1_in': SOURCE_DIR + '/' + sample + '_pass_1.fastq.gz',
                       'r2_in': SOURCE_DIR + '/' + sample + '_pass_2.fastq.gz'
          }

  SAMPLE_DICT = {k:v for k,v in sample_dict_iter(SOURCE_DIR, EXT)}

  #insure errors propogate along pipe'd shell commands
  shell.prefix("set -o pipefail; ")

  rule all:
    input:
        expand('../_m/{sample}_{suffix}.fastq.gz',
         sample=SAMPLE_DICT.keys(),
         suffix=['R1','R2'])

  rule cutadapt:
    input:
        r1 = lambda x: SAMPLE_DICT[x.sample]['r1_in'],
        r2 = lambda x: SAMPLE_DICT[x.sample]['r2_in']
    output:
        r1 = '../_m/{sample}_R1.fastq.gz',
        r2 = '../_m/{sample}_R2.fastq.gz'

    params:
        sample = '{sample}'

    shell:
        '''
    module load cutadapt/3.2

    export PATH=$HOME'/.local/bin:'$PATH

    R1_ADAPTER='AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT'
    R2_ADAPTER='CAAGCAGAAGACGGCATACGAGANNNNNNNGTGACTGGAGTTCAGACGTGTGCTCTTCCGATCT'

    NESTED_PRIMER='TAACTAACCTGCACAATGTGCAC'

    R1_FRONT=${{R1_ADAPTER}}
    R2_FRONT=${{R2_ADAPTER}}${{NESTED_PRIMER}}
    R1_END=`rc ${{R2_FRONT}}`
    R2_END=`rc ${{R1_FRONT}}`

    QUALITY_BASE=33
    QUALITY_CUTOFF=28
    MINIMUM_LENGTH=36
    ADAPTOR_OVERLAP=5
    ADAPTOR_TIMES=4

    cutadapt -j 0 --quality-base=${{QUALITY_BASE}} --quality-cutoff=${{QUALITY_CUTOFF}} --minimum-length=${{MINIMUM_LENGTH}} --overlap=${{ADAPTOR_OVERLAP}} --times=${{ADAPTOR_TIMES}} --front=${{R1_FRONT}} --adapter=${{R1_END}} --paired-output tmp.2.{params.sample}.fastq -o tmp.1.{params.sample}.fastq {input.r1} {input.r2} > {params.sample}_R1.cutadapt.out

    cutadapt -j 0 --quality-base=${{QUALITY_BASE}} --quality-cutoff=${{QUALITY_CUTOFF}} --minimum-length=${{MINIMUM_LENGTH}} --overlap=${{ADAPTOR_OVERLAP}} --times=${{ADAPTOR_TIMES}} --front=${{R2_FRONT}} --adapter=${{R2_END}} --paired-output {output.r1} -o {output.r2} tmp.2.{params.sample}.fastq tmp.1.{params.sample}.fastq > {params.sample}_R2.cutadapt.out

    rm -f tmp.2.{params.sample}.fastq tmp.1.{params.sample}.fastq

  '''

.. code-block:: console

  [userid@login03 cutadapt]$ chmod +x _h/run
  [userid@login03 cutadapt]$ rf sbatch .

  Start /home/userid/pipeline/cutadapt: 2022-05-04 14:35:06-04:00
  End /home/userid/pipeline/cutadapt: 2022-05-04 14:35:06-04:00

Monitoring submitted jobs
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

  [userid@login02 _m]$ sqme
    USER   ACCOUNT        JOBID PARTITION       NAME NODES  CPUS TIME_LIMIT     TIME NODELIST ST REASON
  userid   rfadmin      4157118 defq      snakejob.c     1     1    1:00:00    21:15     c221 R None
  userid   rfadmin      4157146 defq      snakejob.c     1     1    1:00:00    21:15     c301 R None
  userid   rfadmin      4157061 defq      snakejob.c     1     1    1:00:00    21:26     c157 R None
  userid   rfadmin      4157072 defq      snakejob.c     1     1    1:00:00    21:26     c132 R None
  userid   rfadmin      4157102 defq      snakejob.c     1     1    1:00:00    21:26     c303 R None
  userid   rfadmin      4157046 defq        cutadapt     1     1    2:00:00    21:28     c124 R None

To monitoring all submitted processed jobs, ``tail -f`` on the file called ``cutadapt.job.<JOBID>.out``.

.. code-block:: console

  [userid@login03 cutadapt]$ cat _m/cutadapt.job.4157046.out

  Building DAG of jobs...
  Using shell: /usr/bin/bash
  Provided cluster nodes: 200
  Job stats:
  job         count    min threads    max threads
  --------  -------  -------------  -------------
  all             1              1              1
  cutadapt      101              1              1
  total         102              1              1

  Select jobs to execute...

  [Wed May  4 14:48:20 2022]
  rule cutadapt:
      input: ../../_m/ERR1016599_pass_1.fastq.gz, ../../_m/ERR1016599_pass_2.fastq.gz
      output: ../_m/ERR1016599_R1.fastq.gz, ../_m/ERR1016599_R2.fastq.gz
      jobid: 26
      wildcards: sample=ERR1016599
      resources: mem_mb=1709, disk_mb=1709, tmpdir=/tmp

  Submitted job 26 with external jobid '4157048'.

  [Wed May  4 14:48:20 2022]
  rule cutadapt:
      input: ../../_m/ERR1016661_pass_1.fastq.gz, ../../_m/ERR1016661_pass_2.fastq.gz
      output: ../_m/ERR1016661_R1.fastq.gz, ../_m/ERR1016661_R2.fastq.gz
      jobid: 86
      wildcards: sample=ERR1016661
      resources: mem_mb=3245, disk_mb=3245, tmpdir=/tmp

  ........
  ........
  ........
  ........

  [Wed May  4 14:48:30 2022]
  rule cutadapt:
      input: ../../_m/ERR1016581_pass_1.fastq.gz, ../../_m/ERR1016581_pass_2.fastq.gz
      output: ../_m/ERR1016581_R1.fastq.gz, ../_m/ERR1016581_R2.fastq.gz
      jobid: 85
      wildcards: sample=ERR1016581
      resources: mem_mb=1891, disk_mb=1891, tmpdir=/tmp

  Submitted job 85 with external jobid '4157148'.
  [Wed May  4 14:49:33 2022]
  Finished job 37.
  1 of 102 steps (1%) done
  [Wed May  4 14:50:31 2022]
  Finished job 30.
  2 of 102 steps (2%) done
  [Wed May  4 14:51:35 2022]
  Finished job 16.
  3 of 102 steps (3%) done
  [Wed May  4 14:51:48 2022]
  Finished job 25.
  4 of 102 steps (4%) done
  [Wed May  4 14:51:49 2022]
  Finished job 87.
  5 of 102 steps (5%) done

Also, it is possible to see the outputs for each sample processed, just monitoring the file called ``slurm-<snakejobid>.out``.

.. code-block:: console

  [userid@login02 _m]$ cat slurm-4157147.out

  Building DAG of jobs...
  Using shell: /usr/bin/bash
  Provided cores: 1 (use --cores to define parallelism)
  Rules claiming more threads will be scaled down.
  Select jobs to execute...

  [Wed May  4 14:48:37 2022]
  rule cutadapt:
      input: ../../_m/ERR1016667_pass_1.fastq.gz, ../../_m/ERR1016667_pass_2.fastq.gz
      output: ../_m/ERR1016667_R1.fastq.gz, ../_m/ERR1016667_R2.fastq.gz
      jobid: 0
      wildcards: sample=ERR1016667
      resources: mem_mb=1000, disk_mb=1000, tmpdir=/tmp

  [Wed May  4 14:51:25 2022]
  Finished job 0.
  1 of 1 steps (100%) done

Burrows-Wheeler Alignment Tool
******************************

.. image:: https://github.com/lh3/bwa/actions/workflows/ci.yaml/badge.svg
    :target: https://github.com/lh3/bwa/actions
    :alt: Build Status

.. image:: https://img.shields.io/sourceforge/dt/bio-bwa.svg
    :target: https://sourceforge.net/projects/bio-bwa/files/?source=navbar
    :alt: SourceForge Downloads

.. image:: https://img.shields.io/github/downloads/lh3/bwa/total.svg
    :target: https://github.com/lh3/bwa/releases
    :alt: GitHub Downloads

.. image:: https://img.shields.io/conda/dn/bioconda/bwa.svg
    :target: https://anaconda.org/bioconda/bwa
    :alt: BioConda Install

`BWA`_ is a software package for mapping low-divergent sequences against a large reference genome, such as the human genome. It consists of three algorithms: BWA-backtrack, BWA-SW and BWA-MEM.

.. code-block:: console

  [userid@login03 cutadapt]$ cd bwamem
  [userid@login03 bwamem]$ vi _h/run


.. code-block:: python

  #!/bin/bash

  #SBATCH -J bwamem
  #SBATCH -p defq
  #SBATCH --time=2:00:00
  #login01SBATCH --cpus-per-task=4
  #SBATCH --output=bwamem.job.job.%j.out

  module load snakemake/7.6.0

  # Syntax to run it on Rockfish cluster
  snakemake --jobs 101 --latency-wait 240 --cluster 'sbatch --parsable --distribution=arbitrary' --snakefile ../_h/snakemake.slurm.script

bwamem snakemake.slurm.script
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. code-block:: console

  [userid@login03 bwamem]$ vi _h/snakemake.slurm.script


.. code-block:: python

  import glob
  import os.path
  import itertools

  SOURCE_DIR = '../../_m'
  EXT = '_R1.fastq.gz'

  def sample_dict_iter(path, ext):
      for filename in glob.iglob(path+'/*'+ext):
          sample = os.path.basename(filename)[:-len(ext)]
          yield sample, {'r1_in': SOURCE_DIR + '/' + sample + '_R1.fastq.gz',
  		                   'r2_in': SOURCE_DIR + '/' + sample + '_R2.fastq.gz'
  		      }

  SAMPLE_DICT = {k:v for k,v in sample_dict_iter(SOURCE_DIR, EXT)}

  #insure errors propogate along pipe'd shell commands
  shell.prefix("set -o pipefail; ")

  rule all:
      input:
          expand('../_m/{sample}.bam',
  	       sample=SAMPLE_DICT.keys())

  rule bwamem:
      input:
          r1 = lambda x: SAMPLE_DICT[x.sample]['r1_in'],
  	      r2 = lambda x: SAMPLE_DICT[x.sample]['r2_in']

      output:
          '../_m/{sample}.bam'

      params:
          sample = '{sample}'

      shell:
          '''
      module load bwa-mem/0.7.17 samtools/1.15.1

      export PATH=$HOME'/.local/bin:'$PATH

      GENOME='../../../../genome/bwa/_m/hg19.fa'

      bwa mem -T 19 -t 4 ${{GENOME}} {input.r1} {input.r2} 2> {params.sample}.stderr | samtools view -S -b - > {output}
  '''

.. code-block:: console

  [userid@login03 bwamem]$ chmod +x _h/run
  [userid@login03 bwamem]$ rf sbatch .

Remove duplicates
*****************

`rmdup`_ is a script part of the SLAV-Seq protocol written by Apuã Paquola, coded in Perl to read .bam input files and apply samtools software to treat paired-end reads and single-end reads.

.. code-block:: console

  [userid@login03 cutadapt]$ cd rmdup
  [userid@login03 rmdup]$ vi _h/run


.. code-block:: python

  #!/bin/bash

  #SBATCH -J rmdup
  #SBATCH -p defq
  #SBATCH --time=2:00:00
  #SBATCH --cpus-per-task=4
  #SBATCH --output=rmdup.job.job.%j.out

  module load snakemake/7.6.0

  # Syntax to run it on Rockfish cluster
  snakemake --jobs 101 --latency-wait 240 --cluster 'sbatch --parsable --distribution=arbitrary' --snakefile ../_h/snakemake.slurm.script

rmdup snakemake.slurm.script
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

  [userid@login03 rmdup]$ vi _h/snakemake.slurm.script


.. code-block:: python

  import glob
  import os.path
  import itertools

  SOURCE_DIR = '../../_m'
  EXT = '.bam'

  def sample_dict_iter(path, ext):
      for filename in glob.iglob(path+'/*'+ext):
          sample = os.path.basename(filename)[:-len(ext)]
          yield sample, {'filename': filename}


  SAMPLE_DICT = {k:v for k,v in sample_dict_iter(SOURCE_DIR, EXT)}

  #insure errors propogate along pipe'd shell commands
  shell.prefix("set -o pipefail; ")

  rule all:
      input:
          expand('../_m/{sample}.bam', sample=SAMPLE_DICT.keys())

  rule process_one_sample:
      input:
          lambda x: SAMPLE_DICT[x.sample]['filename']

      output:
          '../_m/{sample}.bam'
      log:
          stderr = '{sample}.stderr',
          stdout = '{sample}.stdout'
      shell:
          '../_h/slavseq_rmdup.pl {input} {output}'

.. code-block:: console

  [userid@login03 rmdup]$ chmod +x _h/run
  [userid@login03 rmdup]$ rf sbatch .

Add tags
********

`tags`_ is a script part of the SLAV-Seq protocol written by Apuã Paquola, coded in Perl to add the custom flags into bam files.

.. code-block:: console

  [userid@login03 rmdup]$ cd tags
  [userid@login03 tags]$ vi _h/run


.. code-block:: console

  #!/bin/bash

  #SBATCH -J tags
  #SBATCH -p defq
  #SBATCH --time=2:00:00
  #login01SBATCH --cpus-per-task=4
  #SBATCH --output=tags.job.job.%j.out

  module load snakemake/7.6.0

  # Syntax to run it on Rockfish cluster
  snakemake --jobs 101 --latency-wait 240 --cluster 'sbatch --parsable --distribution=arbitrary' --snakefile ../_h/snakemake.slurm.script

tags snakemake.slurm.script
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

  [userid@login03 tags]$ vi _h/snakemake.slurm.script


.. code-block:: python

  import glob
  import os.path
  import itertools

  SOURCE_DIR = '../../_m'
  EXT = '.bam'

  def sample_dict_iter(path, ext):
      for filename in glob.iglob(path+'/*'+ext):
          sample = os.path.basename(filename)[:-len(ext)]
          yield sample, {'filename': SOURCE_DIR + '/' + sample + '.bam'}


  SAMPLE_DICT = {k:v for k,v in sample_dict_iter(SOURCE_DIR, EXT)}

  #insure errors propogate along pipe'd shell commands
  shell.prefix("set -o pipefail; ")

  rule all:
      input:
          expand('../_m/{sample}.bam',
                 sample=SAMPLE_DICT.keys())

  rule tags:
      input:
          '../../_m/{sample}.bam'

      output:
          '../_m/{sample}.bam'

      params:
          sample = '{sample}'

      shell:
          '''
      module load samtools/1.15.1

      export PERL5LIB=$HOME'/perl5/lib/perl5/'
      export CONSENSUS='ATGTACCCTAAAACTTAGAGTATAATAAA'
      export PATH=$HOME'/.local/bin:'$PATH

      GENOME='../../../../../../genome/bwa/_m/hg19.fa'

      PREFIX_LENGTH=`perl -e 'print length($ENV{{CONSENSUS}})+2'`
      R1_FLANK_LENGTH=750
      R2_FLANK_LENGTH=${{PREFIX_LENGTH}}
      SOFT_CLIP_LENGTH_THRESHOLD=5

      (samtools view -h {input} | ../_h/add_tags_hts.pl --genome_fasta_file ${{GENOME}} --prefix_length ${{PREFIX_LENGTH}} --consensus ${{CONSENSUS}} --r1_flank_length ${{R1_FLANK_LENGTH}} --r2_flank_length ${{R2_FLANK_LENGTH}} --soft_clip_length_threshold ${{SOFT_CLIP_LENGTH_THRESHOLD}} | samtools view -S -b - > {output}) 2> {params.sample}.stderr
  '''

.. code-block:: console

  [userid@login03 tags]$ chmod +x _h/run
  [userid@login03 tags]$ rf sbatch .

Tabix
*****

`Tabix`_ indexes a TAB-delimited genome position file in.tab.bgz and creates an index file (in.tab.bgz.tbi or in.tab.bgz.csi) when region is absent from the command-line.

.. code-block:: console

  [userid@login03 tags]$ cd tabix
  [userid@login03 tabix]$ vi _h/run


.. code-block:: console

  #!/bin/bash

  #SBATCH -J tabix
  #SBATCH -p defq
  #SBATCH --time=2:00:00
  #login01SBATCH --cpus-per-task=4
  #SBATCH --output=tabix.job.job.%j.out

  module load snakemake/7.6.0

  # Syntax to run it on Rockfish cluster
  snakemake --jobs 101 --latency-wait 240 --cluster 'sbatch --parsable --distribution=arbitrary' --snakefile ../_h/snakemake.slurm.script

tabix snakemake.slurm.script
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

  [userid@login03 tabix]$ vi _h/snakemake.slurm.script

.. code-block:: python

  import glob
  import os.path
  import itertools
  import os
  import sys
  import warnings
  import subprocess

  SOURCE_DIR = '../../_m'
  EXT = '.bam'

  def sample_dict_iter(path, ext):
      for filename in glob.iglob(path+'/*'+ext):
          sample = os.path.basename(filename)[:-len(ext)]
          yield sample, {'filename': SOURCE_DIR + '/' + sample + '.bam'}

  SAMPLE_DICT = {k:v for k,v in sample_dict_iter(SOURCE_DIR, EXT)}

  #insure errors propogate along pipe'd shell commands
  shell.prefix("set -o pipefail; ")

  rule all:
      input:
          expand('../_m/{sample}.{ext}',
                 sample=SAMPLE_DICT.keys(),
  	       ext=['bgz', 'bgz.tbi'])

  rule tabix:
      input:
          '../../_m/{sample}.bam'

      output:
          bgz = '../_m/{sample}.bgz',
          tbi = '../_m/{sample}.bgz.tbi'

      params:
          sample = '{sample}'

      shell:
          '''
      module load tabix/1.13 samtools/1.15.1 bzip2/1.0.8

      export PATH=$HOME'/.local/bin:'$PATH

      TMP_DIR='tmp.{params.sample}'
      mkdir ${{TMP_DIR}}

      export LC_ALL=C

      ( samtools view {input} | ../_h/sam_to_tabix.py 2>{params.sample}.stderr | sort --temporary-directory=${{TMP_DIR}} --buffer-size=10G -k1,1 -k2,2n -k3,3n | bgzip2 -c > {output.bgz} )

      rmdir ${{TMP_DIR}}

      tabix -s 1 -b 2 -e 3 -0 {output.bgz}
  '''

.. code-block:: console

  [userid@login03 tabix]$ chmod +x _h/run
  [userid@login03 tabix]$ rf sbatch .


Once you coded the pipeline, just run :doc:`the Reproducibility Framework (RF)<Tutorial_Reproducibility_Framework>`

.. code-block:: console

    ├── pipeline                          no _h
      ├── cutadapt                 ready to run
      │    └── bwamem             no run script
      │        └── rmdup          no run script
      │          └── tags         no run script
      │               └── tabix   no run script
      └── genome                          no _h
          └── hg19                 ready to run
              ├── bwa              ready to run
              └── chromsizes       ready to run

You run one level at a time, or you can use the ``-r`` option for recursive. It will perform the ``rf`` command, once the level 1 is finishes, it will run next level, so consecutively.

.. code-block:: console

  [userid@login03 ~]$ interact -c 2 -t 120
  [userid@c010 ~]$ cd pipeline
  [userid@c010 ~]$ rf run -r .

.. warning::
  The ``rf`` command is validated to run in interactive mode, so far.

.. _pipeline: https://github.com/jhu-arch/arch-tutorial/tree/main/tutorial
.. _Cutadapt: https://cutadapt.readthedocs.io/en/stable/
.. _BWA: http://bio-bwa.sourceforge.net/bwa.shtml
.. _rmdup: https://github.com/apuapaquola/slavseq_rf/blob/master/pipeline/fastq/cutadapt/bwamem/rmdup/_h/slavseq_rmdup.pl
.. _tags: https://github.com/apuapaquola/slavseq_rf/blob/master/pipeline/fastq/cutadapt/bwamem/rmdup/tags/_h/add_tags.pl
.. _tabix: http://www.htslib.org/doc/tabix.html
.. _Snakemake: https://snakemake.readthedocs.io/en/stable/tutorial/tutorial.html
.. _Snakefile: ttps://snakemake.readthedocs.io/en/stable/snakefiles/rules.html
.. _workflows: https://snakemake.readthedocs.io/en/stable/snakefiles/writing_snakefiles.html
