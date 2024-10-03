#! /bin/bash
starttime=`date +'%Y-%m-%d %H:%M:%S'`
#一般只修改KD,KERNEL值就可以了，其他几乎可不动。
#export KD=xxxxx_defconfig
#export KD=vendor/xxxxx_defconfig
export KERNEL=Image
export KD=stock_defconfig

echo "           "
echo "           "
echo "你设置的内核配置文件为$KD,并打印在kernel-defconfig.log"
echo "           "
echo "           "



#一些解释，必看。
#可在终端中直接指定KD，export KD=xxxxx_defconfig 或export KD=vendor/xxxxx_defconfig然后直接运行此脚本即可编译内核，而不必每次都来修改KD值，特别是想要用多个编译器编译时，省掉些麻烦。当然来直接修改也可以。

#手机的内核配置文件(内核配置文件KERNEL_DEFCONFIG简称KD），一般在内核源码目录下的arch/arm64/configs或arch/arm64/configs/vendor下，一般为机型代号，高通骁龙处理器代号啥的，比如mi5 的为gemini_defconfig,一加8系列为kona_pref_defconfig,按实际情况修改
#KD可取的值(内核配置文件KERNEL_DEFCONFIG简称KD） xxxxx_defconfig, vendor/xxxxx_defconfig

#export KD=xxxxx_defconfig
#export KD=vendor/xxxxx_defconfig


#内核产品的格式类型通常为Image或 Image.gz-dtb，Image.gz等，默认Image
#export KERNEL=Image


echo "           "
echo "设置编译环境中....."
echo "           "
#env 设置编译环境
#clang版本11 , binutils版本2.27
export ARCH=arm64
export SUBARCH=arm64

#export PATH="/root/Toolchain/clang-r383902b/bin:/root/Toolchain/google_gcc-4.9/bin:$PATH"

export PATH="/root/clang-r383902/bin:/root/gcc/aarch64/bin:/root/gcc/arm/bin:$PATH"

args="-j8 \
ARCH=arm64 \
SUBARCH=arm64 \
LD=ld.lld \
O=out \
CROSS_COMPILE=aarch64-linux-android- \
CROSS_COMPILE_ARM32=arm-linux-androideabi- \
CLANG_TRIPLE=aarch64-linux-gnu- "


#内核将在 out/arch/arm64/boot下生成通常为Image,Image.gz.dtb,Image.gz等
make CC="ccache clang" ${args} ${KD}
make CC="ccache clang" ${args} 2>&1 | tee kernel.log


echo ccache缓存如下
ccache -s
echo "           "
echo "--------------------------------"
endtime=`date +'%Y-%m-%d %H:%M:%S'`
start_seconds=$(date --date=" $starttime" +%s);
end_seconds=$(date --date="$endtime" +%s);
echo Start: $starttime.
echo End: $endtime.
echo "Build Time: "$((end_seconds-start_seconds))"s."
echo "--------------------------------"
