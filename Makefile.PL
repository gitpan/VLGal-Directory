use 5.006;
use ExtUtils::MakeMaker;

my ($VERSION) = '$Revision: 0.01 $' =~ /\$Revision:\s+([^\s]+)/;

WriteMakefile(
    NAME     => 'VLGal::Directory',
    VERSION  => $VERSION,
    PREREQ_PM => {
        'DirHandle' => 0,
        'Error' => 0,
        'File::Basename' => 0,
        'File::Copy' => 0,
        'File::MMagic' => 0,
        'File::Spec' => 0,
        'IO::File' => 0,
        'Image::Magick' => 0,
    },
    EXE_FILES => [ qw ( vlgal ) ],
    (
        $] >= 5.005 ?    ## Add these new keywords supported since 5.005
        (
            ABSTRACT => 'Vincenzo\'s little gallery direcrory',
            AUTHOR   => 'Vincenzo Zocca <Vincenzo@zocca.do.not.sPam.com>'
        ) : ()
    ),
    clean => {
        FILES => 'gen/tmp diff-all pod-all sdiff-all ' .
                 'smpl/index-vlgal.html smpl/.vlgal ' .
                 'smpl/*/index-vlgal.html smpl/*/.vlgal ' .
                 'smpl/*/*/index-vlgal.html smpl/*/*/.vlgal ' .
                 't/*.out vlgal',
    },
);

