#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        vendor/lib*/sensors.*.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --remove-needed libhidltransport.so "${2}"
            "${PATCHELF}" --replace-needed libutils.so libutils-v32.so "${2}"
            sed -i 's/_ZN7android6Thread3runEPKcim/_ZN7utils326Thread3runEPKcim/g' "${2}"
            ;;
        vendor/lib64/libexynoscamera3.so)
            [ "$2" = "" ] && return 0
            xxd -p "${2}" | tr -d \\n > "${2}".hex
            # NOP SecCameraIPCtoRIL::enable m_sendRequest()
            sed -i "s/140000940a000014/1f2003d50a000014/g" "${2}".hex
            # NOP SecCameraIPCtoRIL::disable m_sendRequest()
            sed -i "s/a8ffff970a000014/1f2003d50a000014/g" "${2}".hex
            # enable RAW on all cameras
            sed -i "s/ab022036/1f2003d5/g" "${2}".hex
            xxd -r -p "${2}".hex > "${2}"
            rm "${2}".hex
            # Add missing reference to libui_shim.so
            grep -q "libshim_ui.so" "${2}" || "$PATCHELF" --add-needed libshim_ui.so "$2"
            ;;
        vendor/lib/soundfx/libaudioeffectoffload.so | vendor/lib64/soundfx/libaudioeffectoffload.so)
	        "$PATCHELF" --replace-needed libtinyalsa.so libtinyalsa.exynos2100.so "$2"
	        ;;
	    vendor/lib/hw/audio.primary.exynos2100.so)
            [ "$2" = "" ] && return 0
	        "$PATCHELF" --replace-needed libaudioroute.so libaudioroute.exynos2100.so "$2"
            "$PATCHELF" --replace-needed libtinyalsa.so libtinyalsa.exynos2100.so "$2"
            ;;
        *)
            return 1
            ;;
    esac

    return 0
}

function blob_fixup_dry() {
    blob_fixup "$1" ""
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export DEVICE=o1s
export DEVICE_COMMON=universal2100-common
export VENDOR=samsung
export VENDOR_COMMON=${VENDOR}

"./../../${VENDOR_COMMON}/${DEVICE_COMMON}/extract-files.sh" "$@"
