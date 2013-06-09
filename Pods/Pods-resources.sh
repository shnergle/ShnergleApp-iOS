#!/bin/sh

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy.txt
touch "$RESOURCES_TO_COPY"

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "rsync -rp ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -rp "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename $1 .xcdatamodeld`.momd"
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename $1 .xcdatamodeld`.momd"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
install_resource 'Facebook-iOS-SDK/src/FacebookSDKResources.bundle'
install_resource 'Facebook-iOS-SDK/src/FBUserSettingsViewResources.bundle'
install_resource 'Google-Maps-iOS-SDK/GoogleMaps.framework/Versions/A/Resources/GoogleMaps.bundle'
install_resource 'WEPopover@krzd/popoverArrowDown.png'
install_resource 'WEPopover@krzd/popoverArrowDown@2x.png'
install_resource 'WEPopover@krzd/popoverArrowDownSimple.png'
install_resource 'WEPopover@krzd/popoverArrowLeft.png'
install_resource 'WEPopover@krzd/popoverArrowLeft@2x.png'
install_resource 'WEPopover@krzd/popoverArrowLeftSimple.png'
install_resource 'WEPopover@krzd/popoverArrowRight.png'
install_resource 'WEPopover@krzd/popoverArrowRight@2x.png'
install_resource 'WEPopover@krzd/popoverArrowRightSimple.png'
install_resource 'WEPopover@krzd/popoverArrowUp.png'
install_resource 'WEPopover@krzd/popoverArrowUp@2x.png'
install_resource 'WEPopover@krzd/popoverArrowUpSimple.png'
install_resource 'WEPopover@krzd/popoverBg.png'
install_resource 'WEPopover@krzd/popoverBg@2x.png'
install_resource 'WEPopover@krzd/popoverBgSimple.png'

rsync -avr --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rm "$RESOURCES_TO_COPY"
