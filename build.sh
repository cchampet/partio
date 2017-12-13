#!/bin/bash

build_partio_lib=1
build_partio_maya=1
build_partio_arnold=1

suppress_build_dirs_prior_build=0
copy_to_local_package=1

build_type=Release

#################################################################################
#    for MAYA 2016:                                                 			#
# rez env gxx-4.8 cmake swig-3.0.5 glew-2.0 python-2.7 mayaAPI-2016 boost-1.48  #
#																				#
#################################################################################

mayaVersion=2018.0.0

arnold_version='5.0.2.1'
mtoa_version='2.1.0.1.21'

swig_executable='/s/apps/packages/dev/swig/3.0.5/platform-linux/bin/swig'

glew_include_dir=$REZ_GLEW_ROOT'/include'
glew_static_library=$REZ_GLEW_ROOT'/lib64/libGLEW.a'

local_build_dir='/datas/hda/build'

#################################################################################
maya_version_short="$(cut -d'.' -f1 <<<"$mayaVersion")"  # ex : 2018

A="$(cut -d'.' -f1 <<<"$mtoa_version")"
B="$(cut -d'.' -f2 <<<"$mtoa_version")"

mtoa_version_short=${A}.${B}

export ARNOLD_HOME=/s/apps/packages/cg/arnold/$arnold_version/platform-linux
export MTOA_ROOT=/s/apps/packages/mikros/mayaModules/mimtoa/$mtoa_version/platform-linux/maya-$maya_version_short

# copy to local package
maya_variant_package=$maya_version_short
mtoa_variant_package=$mtoa_version_short

if [ "$suppress_build_dirs_prior_build" == 1 ]; then

	rm -fr $local_build_dir/partio/partio.build
	rm -fr $local_build_dir/partio/build-Linux-x86_64
	
	mkdir partio.build
	mkdir build-Linux-x86_64
fi

cd partio.build

# Build Partio lib
if [ "$build_partio_lib" == 1 ]; then

	echo "BUILD PARTIO LIB"

	cmake .. \
	  -DBUILD_PARTIO_LIBRARY=1 \
	  -DBUILD_PARTIO_MAYA=0 \
	  -DBUILD_PARTIO_MTOA=0

	make -j12
	make install
fi

# Build Partio Maya plugin
if [ "$build_partio_maya" == 1 ]; then

	echo "BUILD PARTIO MAYA"
		
	maya_executable='/s/apps/packages/cg/maya/'$mayaVersion'/platform-linux/bin/maya'	
	
	cmake .. \
	-DCMAKE_BUILD_TYPE=$build_type \
	-DGLEW_INCLUDE_DIR=$glew_include_dir \
	-DGLEW_STATIC_LIBRARY=$glew_static_library\
	-DMAYA_EXECUTABLE=$maya_executable \
	-DBUILD_PARTIO_LIBRARY=1 \
	-DBUILD_PARTIO_MAYA=1 \
	-DBUILD_PARTIO_MTOA=0
	
	make -j1
	make install	
fi

# Build Partio Arnold
if [ "$build_partio_arnold" == 1 ]; then

    echo "BUILD PARTIO ARNOLD"

    cmake .. \
    -DCMAKE_BUILD_TYPE=$build_type \
    -DSWIG_EXECUTABLE=$swig_executable \
    -DGLEW_INCLUDE_DIR=$glew_include_dir \
    -DGLEW_STATIC_LIBRARY=$glew_static_library \
    -DBUILD_PARTIO_LIBRARY=1 \
    -DBUILD_PARTIO_MAYA=0 \
    -DBUILD_PARTIO_MTOA=1

    make -j12
    make install
fi

# Copy to may local package:
if [ "$copy_to_local_package" == 1 ]; then

	if [ "$build_partio_maya" == 1 ]; then
		cp -v $local_build_dir/partio/build-Linux-x86_64/maya/$maya_variant_package/plug-ins/Linux-x86_64/partio4Maya.so 	/s/apps/users/hda/packages/cgDev/partioMaya/dev/platform-linux/maya-$maya_variant_package/plug-ins
		cp -v $local_build_dir/partio/contrib/partio4Maya/scripts/*.mel 													/s/apps/users/hda/packages/cgDev/partioMaya/dev/platform-linux/maya-$maya_variant_package/scripts
		cp -v $local_build_dir/partio/contrib/partio4Maya/icons/*.xpm 														/s/apps/users/hda/packages/cgDev/partioMaya/dev/platform-linux/maya-$maya_variant_package/icons
	fi

	if [ "$build_partio_arnold" == 1 ]; then
		cp -v "$local_build_dir"/partio/build-Linux-x86_64/arnold/procedurals/partioGenerator.so 			/s/apps/users/hda/packages/cgDev/partioArnold/dev/platform-linux/mimtoa-$mtoa_variant_package/maya-$maya_variant_package/extensions/
		cp -v "$local_build_dir"/partio//contrib/partio4Arnold/plugin/partioTranslator.py 					/s/apps/users/hda/packages/cgDev/partioArnold/dev/platform-linux/mimtoa-$mtoa_variant_package/maya-$maya_variant_package/extensions/
		cp -v "$local_build_dir"/partio/build-Linux-x86_64/extensions/partioTranslator.so 					/s/apps/users/hda/packages/cgDev/partioArnold/dev/platform-linux/mimtoa-$mtoa_variant_package/maya-$maya_variant_package/extensions/
		cp -v "$local_build_dir"/partio/build-Linux-x86_64/arnold/procedurals/partioGenerator.so 			/s/apps/users/hda/packages/cgDev/partioArnold/dev/platform-linux/mimtoa-$mtoa_variant_package/maya-$maya_variant_package/procedurals/
	fi
fi
