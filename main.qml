    import QtQuick
    import QtQuick.Window
    import QtQuick.Controls
    import QtWebEngine
    import org.kde.kirigami as Kirigami
    import QtCore
    import QtQuick.Dialogs

    // txhammer 11/2025
    // kde plasma qt 6 qml app
    // g-mail suite workspace app using Qt.WebEngineView
    // load multiple webviews to create an Google Workspaces like app
    // included google apps [gmail,gcal,contacts,chat,voip,news,maps,drive,search]
    // keep google out your normal web browser
    // NOTE: Google account info/password is saved encrypted in: $HOME/.local/share/QtProject/QtQmlViewer/QtWebEngine/gmail/

    ApplicationWindow {
        id:root
        visible:true
        visibility:"Maximized"
        title:"Google Workspaces"
        color: Kirigami.Theme.backgroundColor
        onClosing: Qt.quit();

        //property bool darkMode : Application.styleHints.colorScheme === Qt.ColorScheme.Dark
        property string selectedView:"viewGmail"
        property var currentDownloadRequest: null
        property int webIndex:0
        property int openPopupCount: 0

        ListModel {
            id: itemsModel
            ListElement { itemId: "gmail"; icon: "gmail.png"; label: "Inbox"; view: "viewGmail"; url: "https://mail.google.com/mail/u/0/#inbox"; loaded: false }
            ListElement { itemId: "gcal"; icon: "gcal.png"; label: "Calendar"; view: "viewCal"; url: "https://calendar.google.com/calendar/u/0/r"; loaded: false }
            ListElement { itemId: "contacts"; icon: "contacts.png"; label: "Contacts"; view: "viewContacts"; url: "https://contacts.google.com/?hl=en#contacts"; loaded: false }
            ListElement { itemId: "chat"; icon: "chat.png"; label: "Chat"; view: "chat"; url: "https://mail.google.com/chat/u/0/#chat/home"; loaded: false }
            ListElement { itemId: "voice"; icon: "voice.png"; label: "VOIP"; view: "voip"; url: "https://voice.google.com/u/0/calls"; loaded: false }
            ListElement { itemId: "maps"; icon: "maps.png"; label: "Maps"; view: "maps"; url: "https://www.google.com/maps/"; loaded: false }
            ListElement { itemId: "news"; icon: "news.png"; label: "News"; view: "news"; url: "https://news.google.com/topstories/"; loaded: false }
            ListElement { itemId: "drive"; icon: "drive.png"; label: "G-Drive"; view: "drive"; url: "https://drive.google.com/drive/"; loaded: false }
            ListElement { itemId: "search"; icon: "search.png"; label: "Search"; view: "search"; url: "https://google.com"; loaded: false }
        }

        Shortcut {
            sequence: "Ctrl+Q"
            onActivated: root.close()
        }

        Instantiator { // shortcuts keys switch views gmail,gcal..search (1-9)
            model: itemsModel
            delegate: Shortcut {
                sequence: "Ctrl+" + (index + 1)
                onActivated: root.selectedView = model.view
            }
        }

        Component.onCompleted: {
            Qt.application.name = "GoogleWorkSpaces"
            Qt.application.organization = "StandaloneApps"
            Qt.application.domain = "local"
        }

        Settings {
            id: appSettings
            category: "WebBrowser"
            location: StandardPaths.writableLocation(StandardPaths.ConfigLocation) + "/gmail"
            property string serializedZoomMap: "{}"
        }

        property var zoomMap: {
            try {
                return JSON.parse(appSettings.serializedZoomMap)
            } catch (e) {
                return ({})
            }
        }

        FileDialog {
            id: webDownloadDialog
            title: "Save Browser Download As..."
            fileMode: FileDialog.SaveFile

            onAccepted: {
                if (currentDownloadRequest) {
                    // 1. Convert the picked QUrl to a clean filesystem path string
                    let cleanPath = String(selectedFile).replace("file://", "");

                    // 2. Extract the directory path and the file name separately
                    let lastSlash = cleanPath.lastIndexOf("/");
                    let directory = cleanPath.substring(0, lastSlash);
                    let fileName = cleanPath.substring(lastSlash + 1);

                    // 3. Update the download object parameters
                    currentDownloadRequest.downloadDirectory = directory;
                    currentDownloadRequest.downloadFileName = fileName;

                    // 4. Fire the transfer
                    currentDownloadRequest.accept();
                    console.log("Download saved via native dialog to: " + cleanPath);
                }
            }

            onRejected: {
                if (currentDownloadRequest) {
                    currentDownloadRequest.cancel();
                    console.log("Download cancelled by user via native dialog");
                }
            }
        }

        function handleNewWindow(request) {
            var newWin = newWindowComponent.createObject(root)
            request.openIn(newWin.webView)
        }

        Component {
            id: newWindowComponent

            Window {
                id: popupWindow
                width: 1000
                height: 750
                visible: true
                title: popupWebView.title || "Google Workspace"
                flags: Qt.Window | Qt.FramelessWindowHint

                Shortcut {
                    sequence: "Esc"
                    context: Qt.WindowShortcut // Ensures Esc only closes the currently focused popup
                    onActivated: popupWindow.close()
                }

                property alias webView: popupWebView

                Component.onCompleted: root.openPopupCount++

                onClosing: {
                    root.openPopupCount = Math.max(0, root.openPopupCount - 1)
                    popupWindow.destroy()
                }

                WebLoader {
                    id: popupWebView
                    viewUrl: "" // request.openIn() populates the URL automatically
                    forceDark: true
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
            //httpUserAgent: "Mozilla/5.0 (wayland; Linux x86_64; rv:159.0) Gecko/20100101 Firefox/159.0"
            httpUserAgent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36"
            onDownloadRequested: function(download) {
                // Save the download reference to the persistent root property
                currentDownloadRequest = download;

                // Pre-fill the native dialog filename with the site's suggested name
                webDownloadDialog.currentFile = String(StandardPaths.writableLocation(StandardPaths.DownloadLocation)) + "/" + download.suggestedFileName;

                // Open the native window prompt immediately
                webDownloadDialog.open();
            }
        }

        Timer {
            id: fallbackTimer
            interval: 6000 // 6 seconds max wait
            running: false
            repeat: false
            onTriggered: {
                itemsModel.setProperty(webIndex, "loaded", true)
            }
        }

        Repeater {
            model: itemsModel
            delegate: Item {
                id: viewDelegate
                anchors.left: navbar.right
                anchors.top: navbar.top
                anchors.leftMargin: 10
                height: root.height
                width: root.width - navbar.width - 10
                opacity: selectedView === model.view ? 1 : 0
                visible: opacity > 0
                z: opacity > 0 ? 1 : 0

                WebLoader {
                    id: webLoader
                    viewUrl: ""
                    forceDark: index === 0 ? false : true

                        onLoadingChanged: {
                            if (!loading) {
                                if (webIndex === index) fallbackTimer.stop()
                                itemsModel.setProperty(index, "loaded", true)
                            } else if (!model.loaded) {
                                webIndex = index
                                fallbackTimer.restart()
                            }
                        }
                }

                Binding {
                    target: webLoader
                    property: "viewUrl"
                    value: model.url
                    when: index === 0 || itemsModel.get(index - 1).loaded || selectedView === model.view
                    restoreMode: Binding.RestoreNone
                }

                Behavior on opacity { NumberAnimation { duration: 300 } }
            }
        }

        Column {
            id: navbar
            spacing: 20
            width: 60
            leftPadding: 10
            topPadding: 10

            Repeater {
                model: itemsModel
                delegate: Column {
                    spacing: 15
                    width:55
                    height:64
                    leftPadding:5
                    topPadding:5
                    Image {
                        width: 36
                        height: 36
                        source: "./icons/" + model.icon
                        smooth: true
                        opacity:selectedView == model.view  ||  mouseArea.containsMouse ? 1:.5
                        Text {
                            anchors.top:parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: model.label
                            color: Kirigami.Theme.textColor
                            font.pointSize: 10
                            antialiasing: true
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: selectedView = model.view
                        }
                    }
                }
            }

            // Settings button (separate since it has different behavior)
            Item { height: 50; width: 1 } // spacer

            Image {
                id:settings
                width: 36
                height: 36
                source: "./icons/settings.png"
                smooth: true
                opacity:settingsMouseArea.containsMouse ? 1:.5

                MouseArea {
                    id: settingsMouseArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: settingsPopup.open()
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
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

            contentItem:
            Text {
                text: "Clear Cache"
                color:Kirigami.Theme.textColor
                topPadding:5
                leftPadding:10
                antialiasing: true

                MouseArea {
                    id: mouseAreaPopup
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered:parent.color=Kirigami.Theme.linkColor
                    onExited:parent.color=Kirigami.Theme.textColor
                    onClicked:{
                        webProfile.clearHttpCache()
                        settingsPopup.close()
                    }
                }
            }
        }

        Rectangle {
            id: dimOverlay
            anchors.fill: parent
            color: "#000000"
            opacity: root.openPopupCount > 0 ? 0.75 : 0.0
            visible: opacity > 0
            z:  root.openPopupCount > 0 ? 99 : -1

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }
    }
