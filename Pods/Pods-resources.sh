#!/bin/sh

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
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
      echo "rsync -av --exclude '*/.svn/*' ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
      rsync -av --exclude '*/.svn/*' "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
      ;;
  esac
}
install_resource 'Appirater/ca.lproj'
install_resource 'Appirater/cs.lproj'
install_resource 'Appirater/da.lproj'
install_resource 'Appirater/de.lproj'
install_resource 'Appirater/el.lproj'
install_resource 'Appirater/en.lproj'
install_resource 'Appirater/es.lproj'
install_resource 'Appirater/fi.lproj'
install_resource 'Appirater/fr.lproj'
install_resource 'Appirater/he.lproj'
install_resource 'Appirater/hu.lproj'
install_resource 'Appirater/id.lproj'
install_resource 'Appirater/it.lproj'
install_resource 'Appirater/ja.lproj'
install_resource 'Appirater/ko.lproj'
install_resource 'Appirater/nb.lproj'
install_resource 'Appirater/nl.lproj'
install_resource 'Appirater/pl.lproj'
install_resource 'Appirater/pt.lproj'
install_resource 'Appirater/ro.lproj'
install_resource 'Appirater/ru.lproj'
install_resource 'Appirater/sk.lproj'
install_resource 'Appirater/sv.lproj'
install_resource 'Appirater/tr.lproj'
install_resource 'Appirater/zh-Hans.lproj'
install_resource 'Appirater/zh-Hant.lproj'
install_resource 'FlatUIKit/Resources/Lato-Black.ttf'
install_resource 'FlatUIKit/Resources/Lato-BlackItalic.ttf'
install_resource 'FlatUIKit/Resources/Lato-Bold.ttf'
install_resource 'FlatUIKit/Resources/Lato-BoldItalic.ttf'
install_resource 'FlatUIKit/Resources/Lato-Hairline.ttf'
install_resource 'FlatUIKit/Resources/Lato-HairlineItalic.ttf'
install_resource 'FlatUIKit/Resources/Lato-Italic.ttf'
install_resource 'FlatUIKit/Resources/Lato-Light.ttf'
install_resource 'FlatUIKit/Resources/Lato-LightItalic.ttf'
install_resource 'FlatUIKit/Resources/Lato-Regular.ttf'
