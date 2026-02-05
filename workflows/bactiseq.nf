/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
// include { FASTQC                 } from '../modules/nf-core/fastqc/main'
// include { MULTIQC                } from '../modules/nf-core/multiqc/main'
// include { paramsSummaryMap       } from 'plugin/nf-schema'
// include { paramsSummaryMultiqc   } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { softwareVersionsToYAML } from '../subworkflows/nf-core/utils_nfcore_pipeline'
// include { methodsDescriptionText } from '../subworkflows/local/utils_nfcore_bactiseq_pipeline'

//Test bakta
include { DATABASEDOWNLOAD       } from '../subworkflows/local/databasedownload/main.nf'
include { SAMPLESHEETFILTERING   } from '../subworkflows/local/samplesheetfiltering/main.nf'


include { PACBIO_SUBWORKFLOW     }  from '../subworkflows/local/pacbio_subworkflow/main'
include { NANOPORE_SUBWORKFLOW   }  from '../subworkflows/local/nanopore_subworkflow/main'
include { ILLUMINA_SUBWORKFLOW   } from '../subworkflows/local/illumina_subworkflow/main'
include { ASSEMBLED_SUBWORKFLOW  } from '../subworkflows/local/assembled_subworkflow/main'

include { CUSTOMVIS              } from '../modules/local/customvis/main'
include { validateParameters; paramsSummaryLog; samplesheetToList } from 'plugin/nf-schema'

include { GUNZIP as GUNZIP_FASTA } from '../modules/nf-core/gunzip/main'

include { ASSEMBLY_QA            } from '../subworkflows/local/assembly_qa/main.nf'
include { ANNOTATION             } from '../subworkflows/local/annotation/main.nf'
include { VISUALIZATIONS         } from '../subworkflows/local/visualizations/main'
include {ORGANIZE_MOBSUITE       } from '../modules/local/organizemobsuite/main.nf'
/*


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow BACTISEQ {
    main:
    def ch_versions = Channel.empty()
    def ch_all_assembly = Channel.empty()
    def ch_gfa = Channel.empty()

    def ch_bams = Channel.from([[[id: 'testBam1'], file("/mnt/d/Sylvia_thesis_test_runs/bam_files_aligned/SRR12806637.bam")],
    [[id:'testbam2'],  file("/mnt/d/Sylvia_thesis_test_runs/bam_files_aligned/SRR12806638.bam")],
    [[id:'testbam3'],  file("/mnt/d/Sylvia_thesis_test_runs/bam_files_aligned/SRR12806639.bam")]])

    VISUALIZATIONS(ch_bams)
    ch_versions = ch_versions.mix(VISUALIZATIONS.out.versions)
    

    softwareVersionsToYAML(ch_versions).collectFile(
        storeDir: "${params.outdir}/pipeline_info",
        name: 'software_versions.yml',
        sort: true,
        newLine: true)

    ch_multiqc_files = Channel.empty()

    emit:
    // Emit specific outputs individually
    // embl = BAKTA_BAKTA.out.embl
    // gff = BAKTA_BAKTA.out.gff
    // versions = BAKTA_BAKTA.out.versions
    multiqc_report = Channel.empty()

    }



/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
