include {   CGVIEW                       } from '../../../modules/local/cgview/main'
include {   TINYCOV                      } from '../../../modules/local/tinycov/main'
include { SAMTOOLS                       } from '../../../modules/local/samtools/main'
include { GUNZIP as GUNZIP_GFA       } from '../../../modules/nf-core/gunzip/main'
include { BANDAGE_IMAGE } from '../../../modules/nf-core/bandage/image/main'
workflow VISUALIZATIONS {

    take:
    ch_bam // channel: [ val(meta), [ bam ] ]

    main:
    ch_versions = Channel.empty()

    if (params.aligned){
        def ch_convert = ch_bam.branch { meta, long_file ->
            convert: long_file.extension == 'sam'
            non_convert: long_file.extension == 'bam'
        }.set{conversions}
        SAMTOOLS(conversions.convert)
        ch_versions = ch_versions.mix(SAMTOOLS.out.versions)
        def all_bam = conversions.non_convert.mix(SAMTOOLS.out.bam) //bam files.mix with converted sam files as ch_bam
        TINYCOV(all_bam)
        ch_versions = ch_versions.mix(TINYCOV.out.versions)
    }

    emit:
    versions = ch_versions                     // channel: [ versions.yml ]
}
