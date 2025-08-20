SUMMARY = "wireutils: simple scripts for debugging"
DESCRIPTION = "installs a couple helpful scripts for dealing with vector"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI = " \
    file://anki-debug.sh \
    file://ddn.sh \
    file://vmesg.sh \
    file://reonboard.sh \
    file://temper.sh \
"
S = "${WORKDIR}"

do_install() {
    install -d ${D}${sbindir}
    install -m 0755 ${WORKDIR}/anki-debug.sh  ${D}${sbindir}/anki-debug
    install -m 0755 ${WORKDIR}/ddn.sh         ${D}${sbindir}/ddn
    install -m 0755 ${WORKDIR}/vmesg.sh       ${D}${sbindir}/vmesg
    install -m 0755 ${WORKDIR}/reonboard.sh   ${D}${sbindir}/reonboard
    install -m 0755 ${WORKDIR}/temper.sh      ${D}${sbindir}/temper
}

FILES_${PN} = "${sbindir}/ddn \
               ${sbindir}/anki-debug \
               ${sbindir}/vmesg \
               ${sbindir}/reonboard \
               ${sbindir}/temper"

RDEPENDS_${PN} = "bash"
