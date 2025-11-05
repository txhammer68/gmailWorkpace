import QtQuick
import QtQuick.Controls
import QtWebEngine

// txhammer 11/2025
// kde plasma qt 6 qml app
// g-mail suite workspace app using Qt.WebEngineView
// load multiple webviews to create an Google Workspaces like app
// included google apps [gmail,gcal,contacts,chat,voip,news,maps,drive,search]
// keep google out your normal web browser
// NOTE: google password is saved in your $HOME/.config folders

ApplicationWindow {
        id:root
        visible:true
        visibility:"Maximized"
        title:"Google Workspaces"
        color:"black"
        onClosing: Qt.destroy();

        property bool darkMode: Application.styleHints.colorScheme === Qt.ColorScheme.Dark

        Component.onCompleted:{
                Qt.WebEngine.initialize()
        }

        property string selectedView:"gmail"

        Column {
                id:navbar
                spacing:50
                width:55
                leftPadding:15
                topPadding:15

                Image {
                        id:inbox
                        width: 36
                        height: 36
                        source: "./icons/gmail.png"
                        antialiasing:true
                        enabled:true
                        opacity:viewInbox.visible  ||  mouseArea.containsMouse ? 1:.5
                        Text{
                                anchors.top:inbox.bottom
                                anchors.horizontalCenter:parent.horizontalCenter
                                text:"Inbox"
                                color:Theme.viewTextColor
                                font.pointSize:10
                                antialiasing:true
                        }

                        MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked:selectedView="gmail"
                        }
                }

                Image {
                        id:calender
                        width: 36
                        height: 36
                        source: "./icons/gcal.png"
                        antialiasing:true
                        enabled:true
                        opacity:viewCal.visible ||  mouseAreaCal.containsMouse ? 1:.5

                        Text{
                                anchors.top:calender.bottom
                                anchors.horizontalCenter:parent.horizontalCenter
                                text:"Calendar"
                                color:Theme.viewTextColor
                                font.pointSize:10
                                antialiasing:true
                        }

                        MouseArea {
                                id: mouseAreaCal
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked:selectedView="gcal"
                        }
                }

                Image {
                        id:contacts
                        width: 36
                        height: 36
                        source: "./icons/contacts.png"
                        antialiasing:true
                        enabled:true
                        opacity:viewCont.visible ||  mouseAreaContacts.containsMouse ? 1:.5

                        Text{
                                anchors.top:contacts.bottom
                                anchors.horizontalCenter:parent.horizontalCenter
                                text:"Contacts"
                                color:Theme.viewTextColor
                                font.pointSize:10
                                antialiasing:true
                        }

                        MouseArea {
                                id: mouseAreaContacts
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked:selectedView="contacts"
                        }
                }

                Image {
                        id:chat
                        width: 36
                        height: 36
                        source: "./icons/chat.png"
                        antialiasing:true
                        enabled:true
                        opacity:viewChat.visible ||  mouseAreaChat.containsMouse ? 1:.5

                        Text{
                                anchors.top:chat.bottom
                                anchors.horizontalCenter:parent.horizontalCenter
                                text:"Chat"
                                color:Theme.viewTextColor
                                font.pointSize:10
                                antialiasing:true
                        }

                        MouseArea {
                                id: mouseAreaChat
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked:selectedView="chat"
                        }
                }

                Image {
                        id:voice
                        width: 36
                        height: 36
                        source: "./icons/voice.png"
                        antialiasing:true
                        enabled:true
                        opacity:viewVoice.visible ||  mouseAreaVoice.containsMouse ? 1:.5

                        Text{
                                anchors.top:parent.bottom
                                anchors.horizontalCenter:parent.horizontalCenter
                                text:"VOIP"
                                color:Theme.viewTextColor
                                font.pointSize:10
                                antialiasing:true
                        }

                        MouseArea {
                                id: mouseAreaVoice
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked:selectedView="voip"
                        }
                }

                Image {
                        id:maps
                        width: 36
                        height: 36
                        source: "./icons/maps.png"
                        antialiasing:true
                        enabled:true
                        opacity:viewMaps.visible ||  mouseAreaMaps.containsMouse ? 1:.5

                        Text{
                                anchors.top:maps.bottom
                                anchors.horizontalCenter:parent.horizontalCenter
                                text:"Maps"
                                color:Theme.viewTextColor
                                font.pointSize:10
                                antialiasing:true
                        }

                        MouseArea {
                                id: mouseAreaMaps
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked:selectedView="maps"
                        }
                }

                Image {
                        id:news
                        width: 36
                        height: 36
                        source: "./icons/news.png"
                        antialiasing:true
                        enabled:true
                        opacity:viewNews.visible ||  mouseAreaNews.containsMouse ? 1:.5


                        Text{
                                anchors.top:parent.bottom
                                anchors.horizontalCenter:parent.horizontalCenter
                                text:"News"
                                color:Theme.viewTextColor
                                font.pointSize:10
                                antialiasing:true
                        }

                        MouseArea {
                                id: mouseAreaNews
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked:selectedView="news"
                        }
                }

                Image {
                        id:drive
                        width: 36
                        height: 36
                        source: "./icons/drive.png"
                        antialiasing:true
                        enabled:true
                        opacity:viewDrive.visible ||  mouseAreaDrive.containsMouse ? 1:.5


                        Text{
                                anchors.top:parent.bottom
                                anchors.horizontalCenter:parent.horizontalCenter
                                text:"G-Drive"
                                color:Theme.viewTextColor
                                font.pointSize:10
                                antialiasing:true
                        }

                        MouseArea {
                                id: mouseAreaDrive
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked:selectedView="drive"
                        }
                }

                Image {
                        id:search
                        width: 36
                        height: 36
                        source: "./icons/search.png"
                        antialiasing:true
                        enabled:true
                        opacity:viewDrive.visible ||  mouseAreaSearch.containsMouse ? 1:.5

                        Text {
                                anchors.top:parent.bottom
                                anchors.horizontalCenter:parent.horizontalCenter
                                text:"Search"
                                color:Theme.viewTextColor
                                font.pointSize:10
                                antialiasing:true
                        }

                        MouseArea {
                                id: mouseAreaSearch
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked:selectedView="search"
                        }
                }
                Image {
                        id:settings
                        width: 36
                        height: 36
                        source: "./icons/settings.png"
                        antialiasing:true
                        smooth:true
                        enabled:true
                        opacity:mouseAreaSettings.containsMouse ? 1:.45

                        MouseArea {
                                id: mouseAreaSettings
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked:settingsPopup.open()
                        }
                }
        }

Popup {
                id: settingsPopup
                x: settings.x+48
                y: settings.y+5
                width: 120
                height: 48
                padding: 10
                modal: true
                focus: true
                closePolicy: Popup.CloseOnEscape | Popup.Popup.CloseOnPressOutside

                contentItem:
                        Text {
                        text: "Clear Cache"
                        color:"white"
                        topPadding:5
                        leftPadding:10

                        MouseArea {
                                id: mouseAreaPopup
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onEntered:parent.color="cyan"
                                onExited:parent.color="white"
                                onClicked:webProfile.clearHttpCache()
                          }
                }
        }

        WebEngineProfile {
                id:webProfile
                offTheRecord : false
                storageName :"gmail"
                persistentPermissionsPolicy:WebEngineProfile.StoreOnDisk
                persistentCookiesPolicy : WebEngineProfile.AllowPersistentCookies
                httpCacheType:WebEngineProfile.DiskHttpCache
        }

        Item {
                id:viewGmail
                anchors.left:navbar.right
                anchors.top:navbar.top
                anchors.leftMargin:10
                height:root.height
                width:root.width-navbar.width-10

                WebEngineView {
                        id:viewInbox
                        anchors.fill:parent
                        focus:visible
                        visible:selectedView=="gmail"
                        antialiasing:true
                        zoomFactor:1.25
                        url:"https://mail.google.com/mail/u/0/#inbox"
                        backgroundColor :"black"
                        settings {
                                javascriptCanAccessClipboard: true
                                //forceDarkMode: true
                                playbackRequiresUserGesture: true
                                pdfViewerEnabled : true
                        }
                        onNewWindowRequested: function(request) {
                                if (request.userInitiated) {
                                        request.action = WebEngineView.IgnoreRequest
                                        Qt.openUrlExternally(request.requestedUrl)
                                }
                        }
                        profile:webProfile
                        onFeaturePermissionRequested: {
                                grantFeaturePermission(securityOrigin, feature, true) // allows access to system features
                        }
                        onLoadingChanged:{
                                !viewInbox.loading  ? init.start():""  // start loading other webviews
                        }
                }

                WebEngineView {
                        id:viewCal
                        anchors.fill:parent
                        focus:visible
                        visible:selectedView=="gcal"
                        smooth:true
                        antialiasing:true
                        backgroundColor :"black"
                        onNewWindowRequested: function(request) {
                                if (request.userInitiated) {
                                        request.action = WebEngineView.IgnoreRequest
                                        Qt.openUrlExternally(request.requestedUrl)
                                }
                        }
                        settings {
                                javascriptCanAccessClipboard: true
                                //forceDarkMode: true
                                playbackRequiresUserGesture: true
                        }
                        profile:webProfile
                        onFeaturePermissionRequested: {
                                grantFeaturePermission(securityOrigin, feature, true) // allows access to system features
                        }
                }

                WebEngineView {
                        id:viewCont
                        anchors.fill:parent
                        visible:selectedView=="contacts"
                        focus:visible
                        zoomFactor:1.25
                        antialiasing:true
                        backgroundColor :"black"
                        onNewWindowRequested: function(request) {
                                if (request.userInitiated) {
                                        request.action = WebEngineView.IgnoreRequest
                                        Qt.openUrlExternally(request.requestedUrl)
                                }
                        }
                        settings {
                                javascriptCanAccessClipboard: true
                                forceDarkMode: darkMode
                                playbackRequiresUserGesture: true
                        }
                        profile:webProfile
                }

                WebEngineView {
                        id:viewChat
                        anchors.fill:parent
                        focus:visible
                        visible:selectedView=="chat"
                        //opacity:visible
                        antialiasing:true
                        backgroundColor :"black"
                        onNewWindowRequested: function(request) {
                                if (request.userInitiated) {
                                        request.action = WebEngineView.IgnoreRequest
                                        Qt.openUrlExternally(request.requestedUrl)
                                }
                        }
                        settings {
                                javascriptCanAccessClipboard: true
                                forceDarkMode: darkMode
                                playbackRequiresUserGesture: true
                        }
                        profile:webProfile
                }

                WebEngineView {
                        id:viewMaps
                        anchors.fill:parent
                        focus:visible
                        visible:selectedView=="maps"
                        opacity:visible
                        smooth:true
                        antialiasing:true
                        backgroundColor :"black"
                        onNewWindowRequested: function(request) {
                                if (request.userInitiated) {
                                        request.action = WebEngineView.IgnoreRequest
                                        Qt.openUrlExternally(request.requestedUrl)
                                }
                        }
                        profile:webProfile
                        settings {
                                javascriptCanAccessClipboard: true
                                forceDarkMode: darkMode
                                playbackRequiresUserGesture: true
                        }
                }

                WebEngineView {
                        id:viewVoice
                        anchors.fill:parent
                        focus:visible
                        visible:selectedView=="voip"
                        antialiasing:true
                        backgroundColor :"black"
                        onNewWindowRequested: function(request) {
                                if (request.userInitiated) {
                                        request.action = WebEngineView.IgnoreRequest
                                        Qt.openUrlExternally(request.requestedUrl)
                                }
                        }
                        profile:webProfile
                        settings {
                                javascriptCanAccessClipboard: true
                                forceDarkMode: darkMode
                                playbackRequiresUserGesture: true
                        }
                }

                WebEngineView {
                        id:viewNews
                        anchors.fill:parent
                        visible:selectedView=="news"
                        focus:visible
                        antialiasing:true
                        zoomFactor:1.55
                        backgroundColor :"black"
                        onNewWindowRequested: function(request) {
                                if (request.userInitiated) {
                                        request.action = WebEngineView.IgnoreRequest
                                        Qt.openUrlExternally(request.requestedUrl)
                                }
                        }
                        profile:webProfile
                        settings {
                                javascriptCanAccessClipboard: true
                                forceDarkMode: darkMode
                                playbackRequiresUserGesture: true
                                }
                  }

                WebEngineView {
                        id:viewDrive
                        anchors.fill:parent
                        focus:visible
                        visible:selectedView=="drive"
                        antialiasing:true
                        backgroundColor :"black"
                        onNewWindowRequested: function(request) {
                                if (request.userInitiated) {
                                        request.action = WebEngineView.IgnoreRequest
                                        Qt.openUrlExternally(request.requestedUrl)
                                }
                        }
                        profile:webProfile
                        settings {
                                javascriptCanAccessClipboard: true
                                //forceDarkMode: true
                                playbackRequiresUserGesture: true
                        }
                }

                WebEngineView {
                        id:viewSearch
                        anchors.fill:parent
                        focus:visible
                        visible:selectedView=="search"
                        antialiasing:true
                        backgroundColor :"black"
                        onNewWindowRequested: function(request) {
                                if (request.userInitiated) {
                                        request.action = WebEngineView.IgnoreRequest
                                        Qt.openUrlExternally(request.requestedUrl)
                                }
                        }
                        profile:webProfile
                        settings {
                                javascriptCanAccessClipboard: true
                                //forceDarkMode: true
                                playbackRequiresUserGesture: true
                        }
                }
        }

        Timer {
                id:init // wait for inbox to load
                running:false
                repeat:false
                interval:1000
                onTriggered:{
                        viewCal.url="https://calendar.google.com/calendar/u/0/r"
                        viewCont.url="https://contacts.google.com/?hl=en#contacts"
                        viewChat.url="https://mail.google.com/chat/u/0/#chat/home"
                        viewVoice.url="https://voice.google.com/u/0/calls"
                        viewMaps.url="https://www.google.com/maps/"
                        viewNews.url="https://news.google.com/topstories/"
                        viewDrive.url="https://drive.google.com/drive/"
                        viewSearch.url="https://www.google.com/"
                }
        }
}
